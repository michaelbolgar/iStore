//
//  FilterVC.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit

enum FilterSection: Int, CaseIterable {
    case sortBy
    case priceRange
    case buttons

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

struct FilterOption {
    let button: UIButton
    let title: String
    let handler: (() -> Void)
}

class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
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
        guard let index = models.firstIndex(where: { $0.button === sender }) else { return }
        selectedSortOption = index
        updateRadioButtons()
    }
    
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
        switch FilterSection(rawValue: indexPath.section)! {
            
        case .sortBy:
            let model = models[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByCell.identifier, for: indexPath) as? SortByCell else {
                return UITableViewCell()
            }
            cell.configure(with: model, isSelected: indexPath.row == selectedSortOption)
                    model.button.addTarget(self, action: #selector(handleRadioButtonPressed(_:)), for: .touchUpInside)
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
            return cell
        }
    }
}

extension UIButton {
    func setupAsRadioButton() {
        self.setImage(UIImage(systemName: "circle"), for: .normal)
        self.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        self.addTarget(self, action: #selector(toggleRadioButton), for: .touchUpInside)
        self.tintColor = .systemBlue
    }
    
    @objc private func toggleRadioButton() {
        self.isSelected = !self.isSelected
    }
}

