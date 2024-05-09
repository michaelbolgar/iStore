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
    func sortByButtonTappet()
}

final class FilterPresenter: FilterPresenterProtocol {
    weak var view: FilterVCDelegate?
    
    init(view: FilterVCDelegate) {
        self.view = view
    }
    
    func cancelButtonTapped() {
        print("Presenter cancel button tappet")
        
    }
    
    func saveButtonTapped() {
        print("Presenter save button tappet")
    }
    
    func sortByButtonTappet() {
        print("Presenter sort by button tapped")

    }
}
