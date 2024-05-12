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

enum SortingOption {
    case title, priceLow, priceHigh
}

final class FilterPresenter: FilterPresenterProtocol {

    weak var view: FilterVCDelegate?
    weak var delegate: HomePresenter?
    
    private var selectedSortOption: SortingOption = .title
    
    init(view: FilterVCDelegate) {
        self.view = view
    }
    
    
    func cancelButtonTapped() {
        print("Presenter cancel button tappet")
        view?.didRequestDismissal()
    }
    
    func saveButtonTapped() {
        print("Presenter save button tappet")
        delegate?.updateSortingCriteria(option: selectedSortOption)
        view?.didRequestDismissal()
    }
    
    func sortByButtonTappet(option: SortingOption) {
        print("Presenter sort by button tapped")
        selectedSortOption = option
        delegate?.updateSortingCriteria(option: option)
    }
}
