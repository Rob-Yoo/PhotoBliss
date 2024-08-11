//
//  OrderByButton.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/28/24.
//

import UIKit

final class OrderByButton: BaseButton {
    
    private var orderBy: OrderBy
    private let type: OrderByButton.ButtonType
    
    init(type: OrderByButton.ButtonType) {
        self.type = type

        switch type {
        case .search:
            self.orderBy = .relevant
        case .like:
            self.orderBy = .newest
        }

        super.init(frame: .zero)
    }
    
    override func configureButton() {
        self.backgroundColor = .white
        self.setImage(.sort, for: .normal)
        self.setTitle(" " + self.orderBy.title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 15
    }
    
    func toggle() -> OrderBy {
        switch orderBy {
        case .latest:
            self.orderBy = .relevant
        case .relevant:
            self.orderBy = .latest
        case .newest:
            self.orderBy = .oldest
        case .oldest:
            self.orderBy = .newest
        }

        self.setTitle(" " + self.orderBy.title, for: .normal)
        return self.orderBy
    }
    
    func resetOrderBy() {
        switch self.type {
        case .like:
            self.orderBy = .newest
        case .search:
            self.orderBy = .relevant
        }

        self.setTitle(" " + self.orderBy.title, for: .normal)
    }
}

extension OrderByButton {
    enum ButtonType {
        case search
        case like
    }
    
    enum OrderBy {
        case latest
        case relevant
        case newest
        case oldest
        
        var title: String {
            switch self {
            case .latest:
                return "최신순"
            case .relevant:
                return "관련순"
            case .newest:
                return "최신순"
            case .oldest:
                return "과거순"
            }
        }
    }
}
