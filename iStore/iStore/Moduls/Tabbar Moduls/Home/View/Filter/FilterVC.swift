//
//  FilterVC.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit
// разделение фильтра по секциям
enum FilterSection: Int, CaseIterable {
    case sortBy, priceRange, buttons
    
    var title: String {
        switch self {
        case .sortBy:
            return "Sort by"
        case .priceRange:
            return "Price range"
        case .buttons:
            return ""
        }
    }
}

// для сортировки
struct FilterOption {
    let title: String
    let handler: (() -> Void)
}

protocol FilterVCDelegate: AnyObject {
    func didUpdateSortOption(option: SortingOption)
    func didRequestDismissal()
}
// MARK: - Class FilterVC

class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var presenter: FilterPresenterProtocol!
    weak var delegate: FilterVCDelegate?
    
    private var minPrice: Double?
    private var maxPrice: Double?
    
    // MARK: - UI
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SortByCell.self, forCellReuseIdentifier: SortByCell.identifier)
        table.register(RangeTextFieldCell.self, forCellReuseIdentifier: RangeTextFieldCell.identifier)
        table.register(ButtonsCell.self, forCellReuseIdentifier: ButtonsCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .white
        return table
    }()
    
    let sortOption = ["Name (A - Z)", "Price (low first)", "Price (high first)"]
    var models  = [FilterOption]()
    var selectedSortOption: Int?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        let contentHeight = calculateContentHeight()
        self.preferredContentSize = CGSize(width: view.bounds.width, height: contentHeight)
    }
    
    // MARK: - Methods
    private func calculateContentHeight() -> CGFloat {
            tableView.layoutIfNeeded()
            return tableView.contentSize.height
        }
    
    func configure() {
        self.models = sortOption.enumerated().map { index, title in
            return FilterOption(title: title) { [weak self] in
                self?.selectedSortOption = index
                self?.updateSortImages()
            }
        }
    }
    
    private func updateSortImages() {
        tableView.reloadData()
    }
    
    // MARK: - Tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        FilterSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FilterSection(rawValue: section)! {
        case .sortBy:
            return models.count
        case .priceRange:
            return 1
        case .buttons:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        FilterSection(rawValue: section)?.title
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellStyle = FilterSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch cellStyle {
            
        case .sortBy:
            let model = models[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByCell.identifier, for: indexPath) as? SortByCell else {
                return UITableViewCell()
            }
            cell.configure(with: model, isSelected: indexPath.row == selectedSortOption)
            return cell
            
        case .priceRange:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RangeTextFieldCell.identifier, for: indexPath) as? RangeTextFieldCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            
        case .buttons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonsCell.identifier, for: indexPath) as? ButtonsCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SortByCell else { return }
        
        let previousIndex = selectedSortOption
        selectedSortOption = indexPath.row
        
        var indexPaths: [IndexPath] = []
        if let previous = previousIndex {
            indexPaths.append(IndexPath(row: previous, section: indexPath.section))
        }
        indexPaths.append(indexPath)
        tableView.reloadRows(at: indexPaths, with: .none)
        
        guard let selectedOptionIndex = selectedSortOption else { return }
        let option = determineSortingOption(from: selectedOptionIndex)
        presenter.sortByButtonTappet(option: option)
        
    }
    
    private func determineSortingOption(from index: Int) -> SortingOption {
        switch index {
        case 0:
            return .title
        case 1:
            return .priceLow
        case 2:
            return .priceHigh
        default:
            fatalError("Unexpected index for sorting option")
        }
    }
}


// MARK: - Extensions

extension FilterVC: ButtonCellDelegate {
    func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
    
    func saveButtonTapped() {
        
        if let minPrice = minPrice, minPrice < 0  {
            showAlert()
        }
        if let maxPrice = maxPrice, maxPrice > 100000 {
            showAlert()
        }
        if let minPrice, let maxPrice {
            if minPrice > maxPrice {
                showAlert()
            }
        }
        
        presenter.saveButtonTapped(minPrice: minPrice, maxPrice: maxPrice, sortOption: selectedSortOption)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Invalid Input", message: "Please ensure the minimum price is not greater than the maximum price.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension FilterVC: RangeTextFieldCellDelegate {
    func inputMinRange(text: String?) {
        if let text {
            minPrice = Double(text)
        }
        debugPrint(minPrice)
    }
    
    func inputMaxRange(text: String?) {
        if let text {
            maxPrice = Double(text)
        }
        debugPrint(maxPrice)
    }
}


extension FilterVC: FilterVCDelegate {
    func didUpdateSortOption(option: SortingOption) {
    }
    
    func didRequestDismissal() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterVC: UIViewControllerTransitioningDelegate {
    internal func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
