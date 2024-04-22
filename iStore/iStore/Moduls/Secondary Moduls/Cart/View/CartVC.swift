import UIKit


protocol CartVCProtocol: AnyObject {
    func reloadTableView(at indexPath: IndexPath)
}

final class CartVC: UIViewController, CartVCProtocol {
    var presenter: CartPresenter!

    // MARK: UI Elements
    private let tableView = UITableView()

    private let footerView = UIView()

    private let orderLabel = UILabel.makeLabel(text: "Order Summary",
                                                          font: UIFont.InterSemiBold(ofSize: 14),
                                                          textColor: UIColor.customDarkGray,
                                                          numberOfLines: 1,
                                                          alignment: .left)

    private let totalLabel = UILabel.makeLabel(text: "Totals",
                                                          font: UIFont.InterRegular(ofSize: 14),
                                                          textColor: UIColor.customDarkGray,
                                                          numberOfLines: 1,
                                                          alignment: .left)

    private let priceLabel = UILabel.makeLabel(text: "$ 2499,97",
                                                          font: UIFont.InterMedium(ofSize: 14),
                                                          textColor: UIColor.customDarkGray,
                                                          numberOfLines: 1,
                                                          alignment: .left)

    private let selectButton = UIButton.makeButton(text: "Select payment method",
                                                           buttonColor: ButtonColor.green,
                                                           titleColor: .white,
                                                           titleSize: 16,
                                                           width: 308,
                                                           height: 50)

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CartPresenter(viewController: self)
        presenter.getData()
        configureTableView()
        setViews()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        CartVC.addBorder(y: 0, view: footerView)
        view.backgroundColor = .white
        title = "Your Cart"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Buy"),
                                                            style: .plain, target: self,
                                                            action: #selector(selectButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor.black
     }


    // MARK: Private Methods
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableCell.self, forCellReuseIdentifier: CartTableCell.identifier)
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }

    func reloadTableView(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
             }
    }

    static func addBorder(y: CGFloat, view: UIView) {
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: 1.0)
        borderLayer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(borderLayer)
    }

    // MARK: Selector Methods
    @objc func selectButtonPressed() {}
}


extension CartVC {
    func setViews() {
        [tableView, footerView].forEach{view.addSubview($0)}
        [orderLabel, totalLabel, priceLabel, selectButton].forEach{footerView.addSubview($0)}
    }
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -1),

            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 160),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            orderLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 15),
            orderLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 23),

            totalLabel.topAnchor.constraint(equalTo: orderLabel.bottomAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 23),

            priceLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -23),

            selectButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            selectButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)

        ])

    }
}
extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.identifier) as! CartTableCell
        let product = presenter.getItem(at: indexPath.row)
        cell.set(info: product)
//        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        return headerView
    }


}
