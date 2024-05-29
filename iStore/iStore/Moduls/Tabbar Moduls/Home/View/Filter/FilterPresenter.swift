//
//  FilterPresenter.swift
//  iStore
//
//  Created by Kate Kashko on 9.05.2024.
//

import Foundation
// MARK: - Protocols
protocol FilterPresenterProtocol {
    func cancelButtonTapped()
//    func saveButtonTapped()
    func saveButtonTapped(minPrice: Double?, maxPrice: Double?, sortOption: Int?)
    func sortByButtonTappet(option: SortingOption)
}

protocol FilterPresenterDelegate: AnyObject {
    func transferData(_ data: String)
    func updateSortingCriteria(option: SortingOption)
    func updatePriceRange(minPrice: Double?, maxPrice: Double?)
}

enum SortingOption {
    case title, priceLow, priceHigh
}

// MARK: - Class FilterPresenter
final class FilterPresenter: FilterPresenterProtocol {

    // MARK: - Properties
    weak var view: FilterVCDelegate?
    weak var delegate: FilterPresenterDelegate?
    
    private var selectedSortOption: SortingOption = .title
    
    // MARK: - Init
    init(view: FilterVCDelegate) {
        self.view = view
    }
    
    // MARK: - Methods
    func cancelButtonTapped() {
        view?.didRequestDismissal()
        print("Presenter cancel button tappet")
    }

    func saveButtonTapped(minPrice: Double?, maxPrice: Double?, sortOption: Int?) {
        if let sortOption = sortOption {
            let option = determineSortingOption(from: sortOption)
            selectedSortOption = option
            delegate?.updateSortingCriteria(option: selectedSortOption)
        }

        delegate?.updatePriceRange(minPrice: minPrice, maxPrice: maxPrice)
        view?.didRequestDismissal()
        print("Presenter save button tapped")
    }
    
    func sortByButtonTappet(option: SortingOption) {
        selectedSortOption = option
        print("Presenter sort by button tapped")
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
