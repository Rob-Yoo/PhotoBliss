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
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var starCountView = StarCountView()
    
    private lazy var likeButton = LikeButton(isCircle: true)
    
    override func configureView() {
        self.contentView.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(imageView)
    }
    
    func configureCell(cellType: CellType, data model : PhotoCellModel) {
        self.configureAdditionalViews(cellType: cellType)
        
        self.imageView.kf.setImage(with: URL(string: model.smallPhotoImageUrl))
        
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
        // ImageView만 있을 경우에만, 즉 맨 처음 셀을 그릴 때에만 호출
        guard self.contentView.subviews.count == 1 else { return }
    
        imageView.snp.makeConstraints {
            if (cellType == .topicTrend) {
                $0.verticalEdges.equalToSuperview().inset(5)
                $0.horizontalEdges.equalToSuperview()
            } else {
                $0.edges.equalToSuperview()
            }
        }
        
        switch cellType {
        case .topicTrend:
            self.imageView.layer.cornerRadius = 17
            self.contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
            self.contentView.layer.shadowOpacity = 0.4
            self.contentView.layer.shadowRadius = 2
            self.contentView.layer.masksToBounds = false
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
