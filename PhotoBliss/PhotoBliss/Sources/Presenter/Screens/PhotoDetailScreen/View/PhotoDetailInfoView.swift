//
//  PhotoDetailInfoView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import UIKit
import SnapKit
import Then

final class PhotoDetailInfoView: BaseView {
    private let titleLabel = UILabel().then {
        $0.text = Literal.PhotoDetail.info
        $0.font = .black20
        $0.textColor = .black
    }
    
    private let infoView = InfoView()
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(infoView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(50)
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    func update(photoDetail: PhotoDetailModel) {
        self.infoView.update(photoDetail: photoDetail)
    }
}

private final class InfoView: BaseView {
    private let sizeTitleLabel = UILabel().then {
        $0.text = Literal.PhotoDetail.size
        $0.font = .heavy15
        $0.textColor = .black
    }
    
    private let viewCountTitleLabel = UILabel().then {
        $0.text = Literal.PhotoDetail.viewCount
        $0.font = .heavy15
        $0.textColor = .black
    }
    
    private let downloadCountTitleLabel = UILabel().then {
        $0.text = Literal.PhotoDetail.downloadCount
        $0.font = .heavy15
        $0.textColor = .black
    }
    
    private let sizeLabel = UILabel().then {
        $0.font = .regular15
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private let viewCountLabel = UILabel().then {
        $0.font = .regular15
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private let downloadCountLabel = UILabel().then {
        $0.font = .regular15
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(sizeTitleLabel)
        self.addSubview(viewCountTitleLabel)
        self.addSubview(downloadCountTitleLabel)
        self.addSubview(sizeLabel)
        self.addSubview(viewCountLabel)
        self.addSubview(downloadCountLabel)
    }
    
    override func configureLayout() {
        let labelVerticalSpacing = 10

        sizeTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        viewCountTitleLabel.snp.makeConstraints {
            $0.top.equalTo(sizeTitleLabel.snp.bottom).offset(labelVerticalSpacing)
            $0.leading.equalToSuperview()
        }
        
        downloadCountTitleLabel.snp.makeConstraints {
            $0.top.equalTo(viewCountTitleLabel.snp.bottom).offset(labelVerticalSpacing)
            $0.leading.equalToSuperview()
        }
        
        sizeLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        viewCountLabel.snp.makeConstraints {
            $0.top.equalTo(sizeLabel.snp.bottom).offset(labelVerticalSpacing)
            $0.trailing.equalToSuperview()
        }
        
        downloadCountLabel.snp.makeConstraints {
            $0.top.equalTo(viewCountLabel.snp.bottom).offset(labelVerticalSpacing)
            $0.trailing.equalToSuperview()
        }
    }
    
    func update(photoDetail: PhotoDetailModel) {
        self.sizeLabel.text = "\(photoDetail.width) x \(photoDetail.height)"
        self.viewCountLabel.text = photoDetail.viewCount.formatted()
        self.downloadCountLabel.text = photoDetail.downloadCount.formatted()
    }
}
