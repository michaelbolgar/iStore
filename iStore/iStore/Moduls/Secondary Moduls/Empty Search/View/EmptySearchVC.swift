//
//  EmptySearchVC.swift
//  iStore
//

import UIKit

protocol EmptySearchVCProtocol: AnyObject {
    func reloadTableView(at indexPath: IndexPath)
}

final class EmptySearchVC: UIViewController, EmptySearchVCProtocol {
    var presenter: EmptySearchPresenter!

    // MARK: UI Elements
    private let tableView = UITableView()
    private let searchBar = SearchBarView()

    private let searchLabel = UILabel.makeLabel(text: "Last search",
                                                font: UIFont.InterMedium(ofSize: 16),
                                                textColor: UIColor.customDarkGray,
                                                numberOfLines: 1,
                                                alignment: .left)
    private let clearButton = UIButton.makeButton(text: "Clear all",
                                                  titleColor: UIColor.customRed,
                                                  titleSize: 12,
                                                  width: 47,
                                                  height: 15)
    private let grayLine = UIView.makeGreyView()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.hideKeyboard()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Buy"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(clearButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor.black
        presenter = EmptySearchPresenter(view: self)
        presenter.viewDidLoad()
        configureTableView()
        setViews()
        setupUI()
        setupSearchBar()
    }


    // MARK: Private Methods
    private func setupSearchBar() {
        let frame = CGRect(x: 55, y: 0, width: 270, height: 44)
        let titleView = UIView(frame: frame)
        searchBar.frame = frame
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
        searchBar.delegate = self
    }
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmptySearchTableCell.self,
                           forCellReuseIdentifier: EmptySearchTableCell.identifier)
    }
    func reloadTableView(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
             }
    }
    // MARK: Selector Methods
    @objc func clearButtonPressed() { }
}
extension EmptySearchVC {
    func setViews() {
        [grayLine, searchLabel, clearButton, tableView].forEach{view.addSubview($0)}
    }
    func setupUI() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            grayLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayLine.heightAnchor.constraint(equalToConstant: 1),
            grayLine.topAnchor.constraint(equalTo: view.topAnchor, constant: 109),

            searchLabel.centerYAnchor.constraint(equalTo: clearButton.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            clearButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 121),

            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension EmptySearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.productCount
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptySearchTableCell.identifier) as! EmptySearchTableCell
        let product = presenter.getWord(at: indexPath.row)
        cell.set(info: product)
        return cell
  }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension EmptySearchVC: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      print(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        print(searchText)
    }
}
