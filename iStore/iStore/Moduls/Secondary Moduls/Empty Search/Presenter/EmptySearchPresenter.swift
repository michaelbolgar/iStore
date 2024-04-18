//
//  EmptySearchPresenter.swift
//  iStore
//

import UIKit

protocol EmptySearchPresenterProtocol: AnyObject {
    func viewDidLoad()
    var productCount: Int { get }
    func getWord(at index: Int) -> LastSearchData
}
class EmptySearchPresenter: EmptySearchPresenterProtocol {
    weak var view: EmptySearchVC?
    var words: [LastSearchData] = []

    init(view: EmptySearchVC? = nil) {
        self.view = view
    }

    var productCount: Int {
        return words.count
    }

    func getWord(at index: Int) -> LastSearchData {
        return words[index]
    }
    func viewDidLoad() {
        words = [LastSearchData(enteredWord: "Iphone 12 pro max"),
                 LastSearchData(enteredWord: "Iphone 12 pro max"),
                 LastSearchData(enteredWord: "Iphone 12 pro max")
        ]
    }
}
