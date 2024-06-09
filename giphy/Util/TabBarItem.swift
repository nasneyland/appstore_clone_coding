//
//  TabBarItem.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation

enum TabBarItem: CaseIterable {
    
    case home, search
    
    var title: String?  {
        switch self {
        case .home: return "홈"
        case .search: return "검색"
        }
    }
    
    var image: String?  {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        }
    }
}

