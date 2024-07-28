//
//  PhotoDetailViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import UIKit

final class PhotoDetailViewController: BaseViewController<PhotoDetailRootView> {
    
    private let input = Observable<PhotoDetailViewModel.Input>(.shouldLoadPhotoDetail)
    private let viewModel: PhotoDetailViewModel
    
    init(photo: PhotoCellModel) {
        self.viewModel = PhotoDetailViewModel(photo: photo)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBarAppearence(appearenceType: .opaque)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NetworkManger.shared.doMornitoringNetwork { [weak self] in
            self?.input.value = .shouldLoadPhotoDetail
        }
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: self.input)
            .bind { [weak self] event in
                switch event {
                case .photoDetail(let data):
                    self?.contentView.updateUI(photoDetail: data)
                case .networkError(let message):
                    self?.showAlert(message: message)
                }
            }
    }
}

//MARK: - User Action Handling
extension PhotoDetailViewController: PhotoDetailRootViewDelegate {
    func likeButtonTapped(image: UIImage) {
        self.input.value = .likeButtonTapped(image: image)
    }
}
