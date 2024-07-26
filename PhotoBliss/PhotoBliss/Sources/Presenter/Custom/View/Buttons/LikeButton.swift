//
//  LikeButton.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit

final class LikeButton: UIButton {
    
    private let isCircle: Bool
    
    private var likeImage: (selected: UIImage, unselected: UIImage) {
        if (isCircle) {
            return (selected: .likeCircle, unselected: .likeCircleInactive)
        } else {
            return (selected: .like, unselected: .likeInactive)
        }
    }
    
    init(isCircle: Bool) {
        self.isCircle = isCircle
        super.init(frame: .zero)
        self.backgroundColor = .lightGray // TODO: - 바꿔야함
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(isLike: Bool) {
        let like = self.likeImage
        let image = isLike ? like.selected : like.unselected
        
        self.setImage(image, for: .normal)
    }
}
