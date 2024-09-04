//
//  PhotoRandomCollectionViewCell.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 8/12/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

protocol PhotoRandomCollectionViewCellDelegate: AnyObject {
    func likeButtonTapped(idx: Int, selectedImage: UIImage?, wasLike: Bool)
}

final class PhotoRandomCollectionViewCell: BaseCollectionViewCell {
    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }
    
    private lazy var countView = UIView().then {
        $0.backgroundColor = .gray.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 12
        $0.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private let countLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .regular13
    }
    
    private lazy var photoInfoView = PhotoDetailHeaderView().then {
        $0.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        $0.backgroundColor = .clear
        $0.detailInfoLabelView.photographerNameLabel.textColor = .white
        $0.detailInfoLabelView.publishedDateLabel.textColor = .white
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override func configureHierarchy() {
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(countView)
        self.contentView.layer.addSublayer(gradientLayer)
        self.contentView.addSubview(photoInfoView)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(1.0).cgColor]
        gradientLayer.locations = [0.6, 1.0]
        gradientLayer.frame = contentView.bounds
    }
    
    override func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(55)
            make.height.equalTo(34)
        }
        
        photoInfoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(60)
        }
    }
    
    func updateUI(number: Int, photo: PhotoCellModel) {
        self.photoImageView.kf.setImage(with: URL(string: photo.rawPhotoImageUrl))
        self.countLabel.text = "\(number) / 10"
        self.photoInfoView.updatePhotographerInfoView(photo: photo)
        self.photoInfoView.updateLikeButton(photo: photo)
    }
    
    @objc private func likeButtonTapped() {
        guard let collectionView = superview as? UICollectionView, let indexPath = collectionView.indexPath(for: self) else { return }

        guard let delegate = collectionView.delegate as? PhotoRandomCollectionViewCellDelegate else {
            print("PhotoRandomCollectionViewCellDelegate를 채택하지 않았습니다")
            return
        }
        
        let wasLike = self.photoInfoView.likeButton.isLike
        
        if let selectedImage = self.photoImageView.image {
            self.photoInfoView.likeButton.isLike.toggle()
        }
        
        delegate.likeButtonTapped(idx: indexPath.item, selectedImage: photoImageView.image, wasLike: wasLike)
    }
}
