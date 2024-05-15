import UIKit

protocol CartVCProtocol: AnyObject {
    func reloadTableView()
    func updateCellInfo(at index: IndexPath, with data: ChosenItem)
    func updateTotalPrice(with amount: Double)
    func deleteCell(at index: IndexPath)
    // добавить сюда все функции
}

/*
 что нужно ещё править:
 1. срабатывает чекмарка, если тыкать на +/-
 2. лейбл каунта срабатывает с запозданием на одну итерацию
 3. внимательно проверить (и дополнить) логику нажатия +/- в сочетании с не/активной чекмаркой
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

    // MARK: Private Methods
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
        guard let stackView = sender.superview as? UIStackView,
              let contentView = stackView.superview,
              let cell = contentView.superview as? CartTableCell,
              let tableView = cell.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter?.tappedPlusButton(at: indexPath)
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
    }

    // это второе действие для чекмарки
    @objc func checkmarkAction(sender: UIButton) {
        guard let contentView = sender.superview,
              let cell = contentView.superview as? CartTableCell,
              let tableView = cell.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        if let cell = self.tableView.cellForRow(at: indexPath) as? CartTableCell {
            if cell.checkmarkButton.isSelected {
                presenter?.addToTotals(at: indexPath.row)
                cell.chosenItem?.isSelected = true // потестить, нужно ли это вообще
            } else {
                presenter?.unselectCell(at: indexPath.row)
                cell.chosenItem?.isSelected = false // потестить, нужно ли это вообще
            }
        }
    }
}

    // MARK: Work with prices

extension CartVC: CartVCProtocol {

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateTotalPrice(with amount: Double) {
        print(amount)
        totalPriceLabel.text = String(format: "$ %.2f", amount)
    }

    func updateCellInfo(at index: IndexPath, with data: ChosenItem) {
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: index) as? CartTableCell {
                //TO_ASK: и всё же тут не успевает обновиться инфа
                cell.countLabel.text = String(data.numberOfItemsToBuy)
                self.tableView.reloadRows(at: [index], with: .automatic)
            }
        }
    }

    #warning("багует, если удалить ячейку между выделенных айтемов")
    func deleteCell(at index: IndexPath) {
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: index) as? CartTableCell {
                //TO_ASK: и всё же тут не успевает обновиться инфа
                self.tableView.deleteRows(at: [index], with: .automatic)
                self.tableView.reloadRows(at: [index], with: .automatic)
            }
        }
    }
}

    // MARK: Setup tableview

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.identifier) as! CartTableCell
        let product = presenter.getItem(at: indexPath.row)
        cell.set(with: product)
        setButtonsTargets(of: cell)

        /// select item in cart
        // dead code?
        cell.checkmarkAction = { [weak self] isSelected in
            // и тут тоже можно управлять поведением чекмарки
            guard let self = self else { return }
            if isSelected {
                cell.totalPriceAction = { price in
                    self.presenter?.addToTotals(at: indexPath.row)
                    // обновить данные таблицы, перерисовать, и не вызывать функцию updateTotalPrice
                    self.updateTotalPrice(with: self.presenter?.totalPrice ?? 0.00)
                }
            } else {
                cell.totalPriceAction = { [weak self] priceToRemove in
                    guard let self = self else { return }
                    self.presenter?.unselectCell(at: indexPath.row)
                    // обновить данные таблицы, перерисовать, и не вызывать функцию updateTotalPrice
                    self.updateTotalPrice(with: self.presenter?.totalPrice ?? 0.00)
                }
            }
        }
//                    if let index = self.presenter?.selectedItems.items.price.firstIndex(of: priceToRemove) {
//                        self.presenter?.removeFromTotals(at: index)
//                        self.updateTotalPrice(with: self.presenter?.totalPrice ?? 0.00)
//                    } else {
                        #warning("по-хорошему надо исправить этот костыль, начиная с удаления функции removeByAmount")
                        /*
                         описание бага: при добавлении товаров по одному посредством клика на "+", в массив залетают значения по одному [100, 100, 100], а в момент снятия чекмарки команда selectedPrices.firstIndex(of: priceToRemove) ищет значение 300 по общей сумме айтемов данного типа и не находит его в массиве

                         вариант решения: создать промежуточный массив для отслеживания изменения состояния ячейки (кол-ва товаров одной категории) и вставлять его в функции удаления/добавления?
                         */

//                        let item = self.presenter?.items[indexPath.row]
//                        let priceToRemove = (item?.price ?? 0.00) * (Double(cell.countLabel.text ?? "0") ?? 0)
//                        self.presenter?.removeFromTotalsByAmount(of: priceToRemove)
//                        self.updateTotalPrice(with: self.presenter?.totalPrice ?? 0.00)
//                    }
//                }
//            }
//        }

        /// delete item from cart
        // эта логика как минимум работала
//        cell.presenter?.deleteButtonAction = { [weak self] in
//            print("item to delete:", indexPath.row)
//            let item = self?.presenter?.items[indexPath.row]
//            let priceToRemove = (item?.price ?? 0.00) * (Double(cell.countLabel.text ?? "0") ?? 0)
//
//            self?.presenter.deleteItem(at: indexPath, tableView: tableView, price: priceToRemove)
//            self?.updateTotalPrice(with: self?.presenter?.totalPrice ?? 0.00)
//        }

//        if indexPath.row == 0 {
//            cell.backgroundColor = .systemCyan
//        } else if indexPath.row == 1 {
//            cell.backgroundColor = .systemGray
//        } else if indexPath.row == 2 {
//            cell.backgroundColor = .systemPink
//        } else if indexPath.row == 3 {
//            cell.backgroundColor = .systemTeal
//        }

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
