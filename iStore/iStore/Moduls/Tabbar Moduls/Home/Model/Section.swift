//
//  Section.swift
//  iStore
//
//  Created by Kate Kashko on 17.04.2024.
//

import Foundation

enum Section {
    case searchField([ListItem])
    case categories([ListItem])
    case products([ListItem])
    
    var items: [ListItem] {
        switch self {
        case    .searchField(let items),
                .categories(let items),
                .products(let items):
            return items
        }
    }
    
    var count: Int {
        return items.count
    }
    
    var title: String {
        switch self {
        case .searchField(_):
            return NSLocalizedString("Delivery address", comment: "")
        case .categories(_):
            return ""
        case .products(_):
            return NSLocalizedString("Products", comment: "")
        }
    }
}
