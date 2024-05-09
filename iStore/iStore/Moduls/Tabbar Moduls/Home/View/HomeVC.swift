import UIKit
import SwiftUI


protocol HomeVCProtocol: AnyObject {
    func reloadData(with section: Int)
}

final class HomeVC: UIViewController, HomeVCProtocol {
    
    var presenter: HomePresenterProtocol!

    //MARK: - UI Elements
    
    private let mockCategorie = MockData.shared.mockCategorie
    private let mockSingleProduct = MockData.shared.mockSingleProduct
    private let sections = ["searchField","categories","products"]
    
    lazy var collectionView: UICollectionView = {
        let collectViewLayout =  UICollectionViewFlowLayout.createTwoColumnFlowLayout(in: view)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectViewLayout)
        collectionView.backgroundColor = .none
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setupViews()
        setDelegates()
        presenter?.setCategories()
        presenter?.setProducts(for: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Private Methods
    private func setupViews() {
        collectionView.register(SearchFieldView.self, forCellWithReuseIdentifier: SearchFieldView.identifier)
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: "CategoryViewCell")
        collectionView.register(SingleItemCell.self, forCellWithReuseIdentifier: SingleItemCell.identifier)
        collectionView.register(HeaderNavBarMenuView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderNavBarMenuView")
        collectionView.register(ProductsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProductsHeaderView")
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
//        searchBar.delegate = self
    }
}
//MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    
    /// fetching collections count
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    /// fetching cells count in each collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch sections[section] {
        case "searchField":
            return 1
        case "categories":
            return presenter.categoryData.count
        case "products":
            return presenter.productData.count
        default:
            return 0
        }
    }
    
    /// fetching cells content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
            
        case "searchField":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchFieldView.identifier, for: indexPath) as?
                    SearchFieldView else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
            
        case "categories":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as? CategoryViewCell else { return UICollectionViewCell() }
            
            let categorie = presenter?.categoryData[indexPath.row] ?? mockCategorie
            cell.configure(with: categorie)
            return cell
            
        case "products":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleItemCell.identifier, for: indexPath) as?
                    SingleItemCell else { return UICollectionViewCell() }
            
            let product = presenter?.productData[indexPath.row] ?? mockSingleProduct
            cell.configure(with: product)
            cell.delegate = self
            return cell
        default:
            fatalError("Unknown section type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let section = sections[indexPath.section]
            switch section {
            case "searchField":
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "HeaderNavBarMenuView",
                    for: indexPath) as! HeaderNavBarMenuView
                header.configureHeader(labelName: "Choose a location")
                header.delegate = self
                return header
            case "categories":
                fallthrough
            case "products":
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ProductsHeaderView",
                                                                             for: indexPath) as! ProductsHeaderView
                header.configureHeader(labelName: "Products")
                header.delegate = self
                return header
            default:
                fatalError("Unknown section type")
            }
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = sections[indexPath.section]
        switch section {
        case "searchField":
            print("Поиск")
        case "categories":
            presenter.setProducts(for: (indexPath.row + 1))
        case "products":
            print("item cell tapped")
            let item = presenter.productData[indexPath.row]
            presenter.showDetailsVC(data: item)
        default:
            fatalError("Unknown section type")
        }
    }
}

//MARK: - Setup View

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

// MARK: - Setup tables

extension HomeVC {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            let section = self?.sections[sectionIndex]
            switch section {
            case "searchField":
                return createSearchFieldSection()
            case "categories":
                return createCategorySection()
            case "products":
                return createProductSection()
            default:
                fatalError("Unknown section type")
            }
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
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(65),
                                                                     heightDimension: .absolute(62)),
                                                   subitems: [item])
    let section = createLayoutSection(group: group,
                                      behavior: .continuous,
                                      interGroupSpacing: 10,
                                      supplementaryItems: [],
                                      contentInsets: false)
    section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
    return section
}

private func createProductSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                        heightDimension: .fractionalHeight(1)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
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


extension HomeVC {
    func reloadData(with section: Int) {
        if section == 2 {
            collectionView.reloadSections(IndexSet(integer: section))
        } else {
            collectionView.reloadData()
        }
    }
}

/// delegate for recognizing tap on Cart button
extension HomeVC: HeaderNavBarMenuViewDelegate {
    func cartButtonTapped() {
        presenter.showCartVC()
    }
}

/// delegate for recognizing tap on the "Add to cart" button
extension HomeVC: SingleItemCellDelegate {
    func buyButtonPressed() {
        print ("add to cart button tapped")
    }
}

extension HomeVC:  ProductsHeaderViewDelegate {
    func filtersButtonTapped() {
        presenter.showFilterVC()
    }
}

extension HomeVC: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.showSearchVC(searchText: searchBar.text ?? "")
    }
}

