import UIKit

protocol CartVCProtocol: AnyObject {
    func reloadTableView(at indexPath: IndexPath)
}

final class CartVC: UIViewController, CartVCProtocol {
    var presenter: CartPresenter!

    // MARK: UI Elements
    private let tableView = UITableView()
    private let deliveryLabel = UILabel.makeLabel(text: "Delivery to", 
                                                  font: UIFont.InterMedium(ofSize: 16),
                                                  textColor: UIColor.customDarkGray,
                                                  numberOfLines: 1,
                                                  alignment: .left)
    private let addressLabel = UILabel.makeLabel(text: "Salatiaga City, Central Java", 
                                                 font: UIFont.InterMedium(ofSize: 16),
                                                 textColor: UIColor.customDarkGray,
                                                 numberOfLines: 1,
                                                 alignment: .left)
    private let arrowImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "ArrowDown")
        return image
    }()
    private let grayLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1)
        return line
    }()
    private let grayLineTwo: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1)
        return line
    }()
    private let grayLineThree: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1)
        return line
    }()
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
        view.backgroundColor = .white
        title = "Your Cart"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Buy"),
                                                            style: .plain, target: self,
                                                            action: #selector(selectButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor.black
        presenter = CartPresenter(viewController: self)
        presenter.viewDidLoad()
        configureTableView()
        setViews()
        setupUI()
    }


    // MARK: Private Methods
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableCell.self, forCellReuseIdentifier: CartTableCell.identifier)
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false

    }
    func reloadTableView(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
             }
    }
    // MARK: Selector Methods
    @objc func selectButtonPressed() {}
}


extension CartVC {
    func setViews() {
        [grayLine, grayLineTwo, grayLineThree, deliveryLabel, addressLabel, arrowImage, tableView, orderLabel, totalLabel, selectButton, priceLabel].forEach{view.addSubview($0)}
    }
    func setupUI() {
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        grayLine.translatesAutoresizingMaskIntoConstraints = false
        grayLineTwo.translatesAutoresizingMaskIntoConstraints = false
        grayLineThree.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            grayLineThree.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            grayLineThree.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayLineThree.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayLineThree.heightAnchor.constraint(equalToConstant: 1),

            deliveryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            deliveryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),

            addressLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            addressLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -10),

            arrowImage.centerYAnchor.constraint(equalTo: deliveryLabel.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
            arrowImage.heightAnchor.constraint(equalToConstant: 17),

            grayLine.heightAnchor.constraint(equalToConstant: 1),
            grayLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayLine.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.topAnchor.constraint(equalTo: grayLine.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: grayLineTwo.topAnchor),

            grayLineTwo.heightAnchor.constraint(equalToConstant: 1),
            grayLineTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayLineTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayLineTwo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),

            orderLabel.topAnchor.constraint(equalTo: grayLineTwo.bottomAnchor, constant: 15),
            orderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),

            totalLabel.topAnchor.constraint(equalTo: orderLabel.bottomAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),

            priceLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),

            selectButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        return cell
    }
}
