//
//  PhotoDetailRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class PhotoDetailRootView: BaseView {
    private let headerView = PhotoDetailHeaderView()
    
    private let photoView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    private let photoDetailInfoView = PhotoDetailInfoView()
    
    override func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        self.addSubview(headerView)
        self.addSubview(photoView)
        self.addSubview(photoDetailInfoView)
    }
    
    override func configureLayout() {
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        photoView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
        }
        
        photoDetailInfoView.snp.makeConstraints {
            $0.top.equalTo(photoView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(photoView).multipliedBy(0.8)
        }
    }
    
    func updateUI(data: PhotoDetailModel) {
        let imageUrl = URL(string: data.photoImageUrl)
        
        self.photoView.kf.setImage(with: imageUrl)
        self.headerView.update(photoDetail: data)
        self.photoDetailInfoView.update(photoDetail: data)
    }
}
