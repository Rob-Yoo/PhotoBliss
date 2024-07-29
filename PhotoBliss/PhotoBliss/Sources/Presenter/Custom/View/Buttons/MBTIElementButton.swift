//
//  MbtiButton.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/28/24.
//

import UIKit

final class MBTIElementButton: BaseButton {
    
    var isTapped = false {
        didSet {
            isTapped ? selectedButton() : unselectedButton()
        }
    }
    
    override func configureButton() {
        self.setTitleColor(.black, for: .normal)
        self.layer.borderColor = UIColor.disabled.cgColor
        self.layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    private func unselectedButton() {
        self.backgroundColor = .white
        self.setTitleColor(.disabled, for: .normal)
    }
    
    private func selectedButton() {
        self.backgroundColor = .mainTheme
        self.setTitleColor(.white, for: .normal)
    }
}
