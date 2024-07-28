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
            
            self.setImage(image, for: .normal)
        }
    }

    private var likeImage: (selected: UIImage, unselected: UIImage) {
        if (isCircle) {
            return (selected: .likeCircle, unselected: .likeCircleInactive)
        } else {
            return (selected: .activeLike, unselected: .inactiveLike)
        }
    }
    
    init(isCircle: Bool) {
        self.isCircle = isCircle
        super.init(frame: .zero)
    }
}
