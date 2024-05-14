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
    let button: UIButton
    let title: String
    let handler: (() -> Void)
}

protocol FilterVCDelegate: AnyObject {
    func didUpdateSortOption(option: SortingOption)
    func didRequestDismissal()
}

class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: FilterPresenterProtocol!
    weak var delegate: FilterVCDelegate?
    
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
    }
    
    // MARK: - Methods
    
    func configure() {
        self.models = sortOption.enumerated().map { index, title in
            let button = UIButton()
            button.setupAsRadioButton()
            return FilterOption(button: button, title: title) { [weak self] in
                self?.selectedSortOption = index
                //                self?.tableView.reloadData()
                self?.updateRadioButtons()
            }
        }
    }
    
    private func updateRadioButtons() {
        for (index, model) in models.enumerated() {
            model.button.isSelected = index == selectedSortOption
        }
        tableView.reloadData()
    }
    
    @objc private func handleRadioButtonPressed(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            
            let previousIndex = selectedSortOption //
            selectedSortOption = indexPath.row
            //            tableView.reloadSections([indexPath.section], with: .none)
            var indexPaths: [IndexPath] = []
            if let previous = previousIndex {
                indexPaths.append(IndexPath(row: previous, section: indexPath.section))
            }
            indexPaths.append(indexPath)
            tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    
    // MARK: - Tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        FilterSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return models.count
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
            cell.delegate = self
            cell.radioButton.addTarget(self, action: #selector(handleRadioButtonPressed(_:)), for: .touchUpInside)
            return cell
            
        case .priceRange:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RangeTextFieldCell.identifier, for: indexPath) as? RangeTextFieldCell else {
                return UITableViewCell()
            }
            return cell
            
        case .buttons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonsCell.identifier, for: indexPath) as? ButtonsCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SortByCell else { return }
        
        let previousIndex = selectedSortOption
        selectedSortOption = indexPath.row
        
        var indexPaths: [IndexPath] = []
        if let previous = previousIndex {
            indexPaths.append(IndexPath(row: previous, section: indexPath.section))
        }
        indexPaths.append(indexPath)
        tableView.reloadRows(at: indexPaths, with: .none)
        cell.delegate?.radioButtonTapped()
    }
}

// MARK: - Extensions
extension UIButton {
    func setupAsRadioButton() {
        self.setImage(UIImage(systemName: "circle"), for: .normal)
        self.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        self.tintColor = .systemBlue
    }
}

extension FilterVC: ButtonCellDelegate {
    func cancelButtonTapped() {
        presenter.cancelButtonTapped()
    }
    
    func saveButtonTapped() {
        presenter.saveButtonTapped()
    }
}
extension FilterVC: SortByCellDelegate {
    //    func radioButtonTapped() {
    //        presenter.sortByButtonTappet(option: SortingOption)
    //
    //    }
    func radioButtonTapped() {
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

extension FilterVC: FilterVCDelegate {
    func didUpdateSortOption(option: SortingOption) {
    }
    
    func didRequestDismissal() {
        self.dismiss(animated: true, completion: nil)
    }
}
