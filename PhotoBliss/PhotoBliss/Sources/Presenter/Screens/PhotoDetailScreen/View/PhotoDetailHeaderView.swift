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
    
    private let detailInfoLabelView = DetailInfoLabelView()
    
    let likeButton = LikeButton(isCircle: true)
    
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
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.verticalEdges.equalToSuperview().inset(15)
        }
    }
    
    func update(photoDetail: PhotoDetailModel) {
        let imageUrl = URL(string: photoDetail.photographerImageUrl)
        
        self.photographerImageView.kf.setImage(with: imageUrl)
        self.detailInfoLabelView.update(photoDetail: photoDetail)
        self.likeButton.update(isLike: photoDetail.isLike)
    }
}

private final class DetailInfoLabelView: BaseView {
    private let photographerNameLabel = UILabel().then {
        $0.font = .regular15
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let publishedDateLabel = UILabel().then {
        $0.font = .bold13
        $0.textColor = .black
        $0.textAlignment = .center
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
            $0.leading.equalToSuperview()
        }
        
        publishedDateLabel.snp.makeConstraints {
            $0.top.equalTo(photographerNameLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
    }
    
    func update(photoDetail: PhotoDetailModel) {
        self.photographerNameLabel.text = photoDetail.photographerName
        self.publishedDateLabel.text = photoDetail.publishedDate + " 게시됨"
    }
}
