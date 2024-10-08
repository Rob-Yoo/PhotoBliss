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
import Toast

protocol PhotoDetailRootViewDelegate: AnyObject {
    func likeButtonTapped(image: UIImage)
}

final class PhotoDetailRootView: BaseView {
    private lazy var headerView = PhotoDetailHeaderView().then {
        $0.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private let photoView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    private let photoDetailInfoView = PhotoDetailInfoView()
    
    private let photoChartView = PhotoChartView()
    
    weak var delegate: PhotoDetailRootViewDelegate?
    
    override func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        self.addSubview(headerView)
        self.addSubview(photoView)
        self.addSubview(photoDetailInfoView)
        self.addSubview(photoChartView)
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
            $0.height.equalTo(photoView).multipliedBy(0.4)
        }
        
        photoChartView.snp.makeConstraints {
            $0.top.equalTo(photoDetailInfoView.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(photoDetailInfoView)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func updateUI(photoDetail: PhotoDetailModel) {
        let imageUrl = URL(string: photoDetail.photo.rawPhotoImageUrl)
        
        self.makeToastActivity(.center)
        self.photoView.kf.setImage(with: imageUrl) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                if let imageFilePath = photoDetail.photo.savedImageFilePath {
                    self?.photoView.image = UIImage(contentsOfFile: imageFilePath)
                }
            }
            self?.hideToastActivity()
            self?.headerView.updateLikeButton(photoDetail: photoDetail)
        }

        self.headerView.updatePhotographerInfoView(photoDetail: photoDetail)
        self.photoDetailInfoView.update(photoDetail: photoDetail)
        self.photoChartView.updateUI(photo: photoDetail)
    }
    
    @objc private func likeButtonTapped() {
        let wasLike = self.headerView.likeButton.isLike
        
        guard let image = self.photoView.image else {
            if (!wasLike) { self.showInvalidLikeToastMessage() }
            return
        }

        let message = wasLike ? Literal.ToastMessage.deleteLike : Literal.ToastMessage.addLike
        let toastStyle = ToastStyle.shadowToastStyle
        
        self.hideToast()
        self.makeToast(message, duration: 1.0, position: .center, style: toastStyle)
        
        self.headerView.likeButton.isLike.toggle()
        delegate?.likeButtonTapped(image: image)
    }
    
    private func showInvalidLikeToastMessage() {
        let toastStyle = ToastStyle.shadowToastStyle
        
        self.hideToast()
        self.makeToast(Literal.ToastMessage.invalidLike, duration: 1.5, position: .center, style: toastStyle)
    }
}
