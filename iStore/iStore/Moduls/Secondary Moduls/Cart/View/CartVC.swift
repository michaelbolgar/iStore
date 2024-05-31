import UIKit

protocol CartVCProtocol: AnyObject {
    func reloadTableRows(at index: IndexPath)
    func updateCellInfo(at index: IndexPath, with data: ChosenItem)
    func updateTotalLabel(with amount: Double)
    func deleteCell(at index: IndexPath)
}

/*
 что нужно ещё править:
 1. криво работает анимация при удалении
 2. прожимается ячейка, появляется анимация
 */

final class CartVC: UIViewController {

    // MARK: Properties

    var presenter: CartPresenter!

    // MARK: UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableCell.self, forCellReuseIdentifier: CartTableCell.identifier)
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CartHeaderView.self, forHeaderFooterViewReuseIdentifier: CartHeaderView.identifier)
        return tableView
    }()

    #warning("заменить на настоящий футер")
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

    private let totalPriceLabel = UILabel.makeLabel(text: "$ 0,00",
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
        presenter.setData()
        setViews()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar(title: "Your Cart")
        #warning("не работает при первом запуске, без открытия DetailsVC")
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: Setting table functions

    private func setButtonsTargets(of cell: CartTableCell) {
        cell.plusButton.addTarget(self, action: #selector(plusButtonAction(sender:)), for: .touchUpInside)
        cell.minusButton.addTarget(self, action: #selector(minusButtonAction(sender:)), for: .touchUpInside)
        cell.checkmarkButton.addTarget(self, action: #selector(checkmarkAction(sender:)), for: .touchUpInside)
        cell.basketButton.addTarget(self, action: #selector(deleteButtonAction(sender:)), for: .touchUpInside)
    }

    // MARK: Selector Methods
    @objc func selectPaymentButtonAction() {
        let paymentVC = PaymentVC()
        paymentVC.modalPresentationStyle = .fullScreen
        present(paymentVC, animated: true, completion: nil)
    }

    // TO_ASK: как sender спасает от ошибки -[UIButton length]: unrecognized selector sent to instance ?
    @objc func deleteButtonAction(sender: UIButton) {
        guard let stackView = sender.superview as? UIStackView,
              let contentView = stackView.superview,
              let cell = contentView.superview as? CartTableCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter?.deleteItem(at: indexPath, tableView: tableView)
    }

    @objc func plusButtonAction(sender: UIButton) {
        // TO_ASK: реально так сложно надо стучаться к этой кнопке?

        //вариант 2 -- приоритетный
//        let test = sender.superview?.superview?.subviews as? CartTableCell
        // написать рекурсивную функцию, которая будет искать ячейку и возвращать её, когда найдёт

        //вариант 3 -- через модели

        guard let stackView = sender.superview as? UIStackView,
//              sender.tag -- вариант 1
              let contentView = stackView.superview,
              let cell = contentView.superview as? CartTableCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter?.tappedPlusButton(at: indexPath)
        updateTotalLabel(with: presenter?.totalPrice ?? 0.00)
    }

    @objc func minusButtonAction(sender: UIButton) {
        guard let stackView = sender.superview as? UIStackView,
              let contentView = stackView.superview,
              let cell = contentView.superview as? CartTableCell,
              let tableView = cell.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter?.tappedMinusButton(at: indexPath)
        updateTotalLabel(with: presenter?.totalPrice ?? 0.00)
    }

    @objc func checkmarkAction(sender: UIButton) {
        guard let contentView = sender.superview,
              let cell = contentView.superview as? CartTableCell,
              let tableView = cell.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        if self.tableView.cellForRow(at: indexPath) is CartTableCell {
            presenter?.tappedCheckmarkButton(at: indexPath)
            updateTotalLabel(with: presenter?.totalPrice ?? 0.00)
        }
    }
}

    // MARK: Work with table

extension CartVC: CartVCProtocol {

    // это всё не нужно делать приватным?
    func reloadTableRows(at index: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [index], with: .none)
        }
    }

    func updateTotalLabel(with amount: Double) {
        totalPriceLabel.text = String(format: "$ %.2f", amount)
    }

    func updateCellInfo(at index: IndexPath, with data: ChosenItem) {
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: index) as? CartTableCell {
                cell.set(with: data)
                self.tableView.reloadRows(at: [index], with: .none)
            }
        }
    }

    func deleteCell(at index: IndexPath) {
        DispatchQueue.main.async {
            if self.tableView.cellForRow(at: index) is CartTableCell {
                self.tableView.deleteRows(at: [index], with: .automatic)
                self.tableView.reloadRows(at: [index], with: .none)
            }
        }
    }
}

    // MARK: Setup tableview

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    /// quantity of cells in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount
    }

    /// setting of cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.identifier) as! CartTableCell
        let product = presenter.getItem(at: indexPath.row)
        cell.set(with: product)
        setButtonsTargets(of: cell)
        return cell
    }

    /// setting of header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartHeaderView.identifier) as! CartHeaderView
        return headerView
    }

    /// tap on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter?.tappedCheckmarkButton(at: indexPath)
    }
}

    // MARK: Layout

private extension CartVC {

    func setViews() {
        [tableView, footerView].forEach{view.addSubview($0)}
        [orderLabel, totalLabel, totalPriceLabel, selectPaymentButton].forEach{footerView.addSubview($0)}
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

            totalPriceLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -23),

            selectPaymentButton.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 15),
            selectPaymentButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
        ])
    }
}
