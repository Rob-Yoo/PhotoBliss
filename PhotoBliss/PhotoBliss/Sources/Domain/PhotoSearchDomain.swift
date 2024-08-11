//
//  PhotoSearchDomain.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import Foundation

enum PhotoSearchDomain {
    
    enum FetchType {
        case searchText(_ text: String)
        case page
        case color(_ color: Color)
        case orderBy(_ orderBy: OrderBy)
    }
    
    enum OrderBy: String {
        case relevant
        case latest
    }
    
    enum Color: String {
        case black, yellow, red, purple, green, blue
    }
    
}
