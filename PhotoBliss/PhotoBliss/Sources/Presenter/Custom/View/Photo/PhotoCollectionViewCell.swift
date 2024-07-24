//
//  PhotoCollectionViewCell.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    
    enum CellType {
        case topicTrend
        case searchResult
        case like
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var starCountView = StarCountView()
    
    private lazy var likeButton = LikeButton(isCircle: true)
    
    override func configureView() {
        self.contentView.backgroundColor = .lightGray
    }
    
    override func configureLayout() {
        self.contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(cellType: CellType, data model : PhotoModel) {
        self.configureAdditionalViews(cellType: cellType)
        
        self.imageView.kf.setImage(with: URL(string: model.imageURL))
        
        switch cellType {
        case .topicTrend:
            self.starCountView.update(count: model.starCount)
        case .searchResult:
            self.starCountView.update(count: model.starCount)
            self.likeButton.update(isLike: model.isLike)
        case .like:
            self.likeButton.update(isLike: model.isLike)
        }
    }
}

//MARK: - Configure Subviews
extension PhotoCollectionViewCell {
    private func configureAdditionalViews(cellType: CellType) {
        // ImageView만 있을 경우에만
        guard self.contentView.subviews.count == 1 else { return }
    
        switch cellType {
        case .topicTrend:
            self.contentView.layer.cornerRadius = 17
            self.contentView.clipsToBounds = true
            self.configureStarCountView()
        case .searchResult:
            self.configureStarCountView()
            self.configureLikeButton()
        case .like:
            self.configureLikeButton()
        }
    }
    
    private func configureStarCountView() {
        self.contentView.addSubview(starCountView)
        
        starCountView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(30)
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func configureLikeButton() {
        self.contentView.addSubview(likeButton)
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(30)
        }
    }
}
