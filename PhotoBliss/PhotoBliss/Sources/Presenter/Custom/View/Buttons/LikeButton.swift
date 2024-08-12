//
//  LikeButton.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit

final class LikeButton: BaseButton {
    
    private let isCircle: Bool
    
    var isLike: Bool = false {
        didSet {
            let like = self.likeImage
            let image = isLike ? like.selected : like.unselected
            let tintColor = isLike ? UIColor.red : UIColor.white
            
            if (isCircle) {
                self.tintColor = tintColor
            }
            
            self.setImage(image, for: .normal)
        }
    }

    private var likeImage: (selected: UIImage?, unselected: UIImage?) {
        return (selected: UIImage(systemName: "heart.fill"), unselected: UIImage(systemName: "heart"))
    }
    
    init(isCircle: Bool) {
        self.isCircle = isCircle
        super.init(frame: .zero)
    }
    
    override func configureButton() {
        if (isCircle) {
            self.backgroundColor = .gray.withAlphaComponent(0.5)
        } else {
            self.tintColor = .red
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (isCircle) {
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
}
