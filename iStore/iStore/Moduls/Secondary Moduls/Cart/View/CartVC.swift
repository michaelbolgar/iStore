import UIKit

protocol CartVCProtocol: AnyObject {
    func reloadTableView(at indexPath: IndexPath)
}

final class CartVC: UIViewController, CartVCProtocol {
    var presenter: CartPresenter!
    var selectedPrices: [Double] = []
    var totalPrice = 0.0

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

    private let priceLabel = UILabel.makeLabel(text: "$ 0,00",
                                                          font: UIFont.InterMedium(ofSize: 14),
                                                          textColor: UIColor.customDarkGray,
                                                          numberOfLines: 1,
                                                          alignment: .left)

    private let selectPaymentButton = UIButton.makeButton(text: "Select payment method",
                                                           buttonColor: ButtonColor.green,
                                                           titleColor: .white,
                                                           titleSize: 16,
                                                           width: 308,
                                                           height: 50,
                                                           cornerRadius: 6)

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter = CartPresenter(viewController: self)
        presenter.getData()
        configureTableView()
        setViews()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar(title: "Your Cart")
        #warning("не работает при первом запуске, без открытия DetailsVC")
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: Private Methods

    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableCell.self, forCellReuseIdentifier: CartTableCell.identifier)
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CartHeaderView.self, forHeaderFooterViewReuseIdentifier: CartHeaderView.identifier)
    }

    func reloadTableView(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Selector Methods
    @objc func selectPaymentButtonAction() {
        let paymentVC = PaymentVC()
        #warning("после установления мода automatic перестало перекидывать на сайт девраша")
        paymentVC.modalPresentationStyle = .fullScreen
        present(paymentVC, animated: true, completion: nil)
    }
}

    // MARK: Setup table

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.identifier) as! CartTableCell
        let product = presenter.getItem(at: indexPath.row)
        cell.set(info: product)

        cell.checkmarkAction = { [weak self] isSelected in
            guard let self = self else { return }
            if isSelected {
                cell.totalPriceAction = { price in
                    self.selectedPrices.append(price)
                    self.totalPrice = self.selectedPrices.reduce(0, +)
                    self.priceLabel.text = String(format: "$ %.2f", self.totalPrice)
                }
            }else {
                cell.totalPriceAction = { [weak self] priceToRemove in
                    guard let self = self else { return }
                    if let index = self.selectedPrices.firstIndex(of: priceToRemove) {
                        self.selectedPrices.remove(at: index)
                        self.totalPrice = self.selectedPrices.reduce(0, +)
                        self.priceLabel.text = "$\(self.totalPrice)"
                    }
                }

            }
        }
        cell.presenter?.deleteButtonAction = { [weak self] in
            self?.presenter.deleteItem(at: indexPath, tableView: tableView)
              }

        return cell
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartHeaderView.identifier) as! CartHeaderView
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell tapped")
    }
}

    // MARK: Layout

extension CartVC {
    func setViews() {
        [tableView, footerView].forEach{view.addSubview($0)}
        [orderLabel, totalLabel, priceLabel, selectPaymentButton].forEach{footerView.addSubview($0)}
    }
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        selectPaymentButton.addTarget(self, action: #selector(selectPaymentButtonAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -1),

            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 160),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),

            orderLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            orderLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 23),

            totalLabel.topAnchor.constraint(equalTo: orderLabel.bottomAnchor, constant: 8),
            totalLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 23),

            priceLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -23),

            selectPaymentButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            selectPaymentButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)

        ])
    }
}
