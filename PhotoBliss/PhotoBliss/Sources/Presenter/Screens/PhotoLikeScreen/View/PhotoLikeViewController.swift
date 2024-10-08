//
//  LikeListViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import UIKit

final class PhotoLikeViewController: BaseViewController<PhotoLikeRootView> {
    
    private let input = Observable<PhotoLikeViewModel.Input>()
    private let viewModel = PhotoLikeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarAppearence(appearenceType: .opaque)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.input.value = .viewIsAppearing
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: self.input)
            .bind { [weak self] output in
                guard let self else { return }

                switch output {
                case .photoLikeList(let likeList):
                    contentView.showPhotoLikeList(likeList: likeList)
                    
                case .isEmptyList:
                    contentView.showEmptyResult()
                    
                case .orderByDidChange:
                    contentView.updateOrderByButton()
                    
                case .resetOrderByButton:
                    contentView.resetOrderByButton()
                }
            }
    }
}

//MARK: - User Action Handling
extension PhotoLikeViewController: PhotoLikeRootViewDelegate {
    func photoCellTapped(photo: PhotoCellModel) {
        let nextVC = PhotoDetailViewController(photo: photo)
        
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func likeButtonTapped(photo: PhotoCellModel) {
        self.input.value = .likeButtonTapped(photo: photo)
    }
    
    func orderByButtonTapped() {
        self.input.value = .orderByButtonTapped
    }
}
