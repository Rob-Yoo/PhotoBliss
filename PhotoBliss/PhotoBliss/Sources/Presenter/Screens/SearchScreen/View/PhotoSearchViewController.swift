//
//  PhotoSearchViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import UIKit

final class PhotoSearchViewController: BaseViewController<PhotoSearchRootView> {
    private let input = Observable<PhotoSearchViewModel.Input>()
    private let viewModel = PhotoSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarAppearence(appearenceType: .transparent)
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.tranform(input: self.input)
            .bind { [weak self] event in
                switch event {
                case .photoList(let photoList):
                    self?.contentView.updateUI(data: photoList)
                case .networkError(let message):
                    self?.showAlert(message: message)
                case .shouldScrollUp(let signal):
                    if (signal) {
                        self?.contentView.scrollUpToTop()
                    }
                }
            }
    }
}

//MARK: - User Action Handling
extension PhotoSearchViewController: PhotoSearchRootViewDelegate {
    func searchButtonTapped(searchText: String) {
        self.contentView.endEditing(true)
        self.input.value = .searchButtonTapped(searchText)
    }
    
    func doPagination(currentPhotoList: [PhotoCellModel]) {
        self.input.value = .doPagination(currentPhotoList)
    }
    
    func photoCellTapped(photo: PhotoCellModel) {
        let nextVC = PhotoDetailViewController(photo: photo)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
