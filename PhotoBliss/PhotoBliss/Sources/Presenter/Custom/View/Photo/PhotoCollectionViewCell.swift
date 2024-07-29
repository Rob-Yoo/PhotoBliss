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

protocol PhotoCollectionViewCellDelegate: AnyObject {
    func likeButtonTapped(idx: Int, selectedImage: UIImage?, wasLike: Bool)
}

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
    
    private lazy var likeButton = LikeButton(isCircle: true).then {
        $0.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(imageView)
    }
    
    func configureCell(cellType: CellType, data model : PhotoCellModel) {
        self.configureAdditionalViews(cellType: cellType)
        
        switch cellType {
        case .topicTrend:
            self.imageView.kf.setImage(with: URL(string: model.smallPhotoImageUrl))
            self.starCountView.update(count: model.starCount)
        case .searchResult:
            self.imageView.kf.setImage(with: URL(string: model.smallPhotoImageUrl))
            self.starCountView.update(count: model.starCount)
            self.likeButton.isLike = model.isLike
        case .like:
            guard let filePath = model.savedImageFilePath else { return }
            self.imageView.image = UIImage(contentsOfFile: filePath)
            self.likeButton.isLike = model.isLike
        }
    }
    
    @objc private func likeButtonTapped() {
        guard let collectionView = superview as? UICollectionView, let indexPath = collectionView.indexPath(for: self) else { return }

        guard let delegate = collectionView.delegate as? PhotoCollectionViewCellDelegate else {
            print("PhotoCollectionViewCellDelegate를 채택하지 않았습니다")
            return
        }
        
        let wasLike = self.likeButton.isLike
        
        if let selectedImage = self.imageView.image {
            self.likeButton.isLike.toggle()
        }
        
        delegate.likeButtonTapped(idx: indexPath.item, selectedImage: imageView.image, wasLike: wasLike)
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
