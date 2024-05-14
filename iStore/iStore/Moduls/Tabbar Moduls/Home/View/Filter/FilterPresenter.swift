//
//  FilterPresenter.swift
//  iStore
//
//  Created by Kate Kashko on 9.05.2024.
//

import Foundation

protocol FilterPresenterProtocol {
    func cancelButtonTapped()
    func saveButtonTapped()
    func sortByButtonTappet(option: SortingOption)
}

protocol FilterPresenterDelegate: AnyObject {
    func transferData(_ data: String)
    func updateSortingCriteria(option: SortingOption)
}

enum SortingOption {
    case title, priceLow, priceHigh
}

final class FilterPresenter: FilterPresenterProtocol {

    weak var view: FilterVCDelegate?
    weak var delegate: FilterPresenterDelegate?
    
    private var selectedSortOption: SortingOption = .title
    
    init(view: FilterVCDelegate) {
        self.view = view
    }
    
    func cancelButtonTapped() {
        view?.didRequestDismissal()
        print("Presenter cancel button tappet")
    }
    
    func saveButtonTapped() {
        delegate?.updateSortingCriteria(option: selectedSortOption)
        view?.didRequestDismissal()
        print("Presenter save button tappet")
    }
    
    func sortByButtonTappet(option: SortingOption) {
        selectedSortOption = option
        print("Presenter sort by button tapped")
    }
}
