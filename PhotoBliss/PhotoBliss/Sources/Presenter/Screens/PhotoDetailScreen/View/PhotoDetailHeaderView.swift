//
//  PhotoDetailHeaderView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class PhotoDetailHeaderView: BaseView {
    private let photographerImageView = ProfileImageView().then {
        $0.layer.borderWidth = 0
        $0.alpha = 1
        $0.image = .person
        $0.backgroundColor = .lightGray
        $0.tintColor = .white
    }
    
    let detailInfoLabelView = DetailInfoLabelView()
    
    let likeButton = LikeButton(isCircle: false)
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(photographerImageView)
        self.addSubview(detailInfoLabelView)
        self.addSubview(likeButton)
    }
    
    override func configureLayout() {
        photographerImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(15)
            $0.width.equalTo(photographerImageView.snp.height)
        }
        
        detailInfoLabelView.snp.makeConstraints {
            $0.leading.equalTo(photographerImageView.snp.trailing).offset(10)
            $0.verticalEdges.equalToSuperview().inset(11)
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    func updatePhotographerInfoView(photoDetail: PhotoDetailModel) {
        let imageUrl = URL(string: photoDetail.photo.photographerImageUrl)
        
        self.photographerImageView.kf.setImage(with: imageUrl)
        self.detailInfoLabelView.update(photoDetail: photoDetail)
    }
    
    func updatePhotographerInfoView(photo: PhotoCellModel) {
        let imageUrl = URL(string: photo.photographerImageUrl)
        
        self.photographerImageView.kf.setImage(with: imageUrl)
        self.detailInfoLabelView.update(photo: photo)
    }
    
    func updateLikeButton(photoDetail: PhotoDetailModel) {
        self.likeButton.isLike = photoDetail.photo.isLike
    }
    
    func updateLikeButton(photo: PhotoCellModel) {
        self.likeButton.isLike = photo.isLike
    }
}

final class DetailInfoLabelView: BaseView {
    let photographerNameLabel = UILabel().then {
        $0.font = .regular15
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    let publishedDateLabel = UILabel().then {
        $0.font = .bold13
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(photographerNameLabel)
        self.addSubview(publishedDateLabel)
    }
    
    override func configureLayout() {
        photographerNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.horizontalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        publishedDateLabel.snp.makeConstraints {
            $0.top.equalTo(photographerNameLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
    }
    
    func update(photoDetail: PhotoDetailModel) {
        self.photographerNameLabel.text = photoDetail.photo.photographerName
        self.publishedDateLabel.text = photoDetail.photo.publishedDate + " 게시됨"
    }
    
    func update(photo: PhotoCellModel) {
        self.photographerNameLabel.text = photo.photographerName
        self.publishedDateLabel.text = photo.publishedDate + " 게시됨"
    }
}
