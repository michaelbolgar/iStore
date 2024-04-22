import UIKit
import SwiftUI

#warning("внести правки:")
/*

 1. делать лейблы через extension (заметил в ячейках)
 2. выставить марки по шаблону, который я закрепил в ветке в дискорде
 3. поправить кнопку filters и сделать её более похожей на макет в фигме

 */

protocol HomeVCProtocol: AnyObject {
//    func reloadCollectionView(section: Int)
}

protocol HomeVCProtocol: AnyObject {
//    func reloadCollectionView(section: Int)
}

final class HomeVC: UIViewController {
  
   var presenter: HomePresenterProtocol!
    
    //MARK: - Properties
    
    private let sections = MockData.shared.pageData
    
    lazy var collectionView: UICollectionView = {
        let collectViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectViewLayout)
        collectionView.backgroundColor = .none
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Init

    var presenter: HomePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setupViews()
        setDelegates()
    }
    
    //MARK: - Private methods
    private func setupViews() {
        collectionView.register(SearchFieldView.self, forCellWithReuseIdentifier: "SearchFieldView")
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: "CategoryViewCell")
        collectionView.register(ProductViewCell.self, forCellWithReuseIdentifier: "ProductViewCell")
        collectionView.register(HeaderNavBarMenuView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderNavBarMenuView")
        collectionView.register(ProductsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProductsHeaderView")
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
}
//MARK: - UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .searchField(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchFieldView", for: indexPath) as?
                    SearchFieldView else { return UICollectionViewCell() }
            return cell
        case .categories(let categories):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as? CategoryViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(image: categories[indexPath.row].image, category: categories[indexPath.row].categories)
            return cell
            
        case .products(let products):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductViewCell", for: indexPath) as?
                    ProductViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(image: products[indexPath.row].image, title: products[indexPath.row].title, price: products[indexPath.row].price)
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let section = sections[indexPath.section]
            switch section {
            case .searchField(_):
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "HeaderNavBarMenuView",
                    for: indexPath) as! HeaderNavBarMenuView
                header.configureHeader(labelName: section.title)
                return header
            case .categories(_):
                fallthrough
            case .products(_):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ProductsHeaderView",
                                                                             for: indexPath) as! ProductsHeaderView
                header.configureHeader(labelName: section.title)
                return header
            }
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - UICollectionViewDelegate
extension HomeVC: UICollectionViewDelegate {
    
}

//MARK: - AddViews
extension HomeVC {
    private func addViews() {
        view.addSubview(collectionView)
        addConstraints()
    }
    
    private func addConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
//MARK: - Create Layout
extension HomeVC {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .searchField(_):
                return self.createSearchFieldSection()
            case .categories(_):
                return self.createCategorySection()
            case .products(_):
                return self.createProductSection()
            }
        }
    }
    
    private func createLayoutSection(group: NSCollectionLayoutGroup,
                                     behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                                     interGroupSpacing: CGFloat,
                                     supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
                                     contentInsets: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        section.supplementariesFollowContentInsets = contentInsets
        return section
    }
    
    private func createSearchFieldSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .absolute(20)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        section.contentInsets = .init(top: 30, leading: 20, bottom: 40, trailing: 20)
        return section
        
    }
    private func createCategorySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalWidth(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(57),
                                                                         heightDimension: .absolute(61)),
                                                       subitems: [item])
        let section = createLayoutSection(group: group,
                                          behavior: .continuous,
                                          interGroupSpacing: 16,
                                          supplementaryItems: [],
                                          contentInsets: false)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        return section
    }
    
    private func createProductSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(349),
                                                                         heightDimension: .absolute(217)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        section.contentInsets = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                heightDimension: .estimated(30)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
}

