//
//  TextButton.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

final class TextButton: BaseButton {
    
    init(type: TextButtonType) {
        super.init(frame: .zero)
        self.setTitle(type.title, for: .normal)
    }
    
    override func configureButton() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .bold15
        self.backgroundColor = .mainTheme
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}

extension TextButton {
    enum TextButtonType {
        case start
        case complete
        
        var title: String {
            switch self {
            case .start:
                return Literal.ButtonTitle.start
            case .complete:
                return Literal.ButtonTitle.complete
            }
        }
    }
}
