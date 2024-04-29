import UIKit

protocol SearchFieldViewDelegate: AnyObject {
    func searchButtonTapped(searchText: String)
}

final class SearchFieldView: UICollectionViewCell, SearchBarViewDelegate {

    // MARK: Properties

    weak var delegate: SearchBarViewDelegate?
    static let identifier = String(describing: SearchFieldView.self)
    private let searchBar = SearchBarView()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        searchBar.delegate = self
//        searchBar.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBar(searchBar, textDidChange: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarSearchButtonClicked(searchBar)
    }
}

    // MARK: Layout

extension SearchFieldView {
    private func setupView() {
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
