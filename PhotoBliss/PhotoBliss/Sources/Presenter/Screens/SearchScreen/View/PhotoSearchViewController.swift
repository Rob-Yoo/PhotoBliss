//
//  PhotoSearchViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import UIKit
import Toast

final class PhotoSearchViewController: BaseViewController<PhotoSearchRootView> {
    private let input = Observable<PhotoSearchViewModel.Input>(.viewDidLoad)
    private let viewModel = PhotoSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarAppearence(appearenceType: .opaque)
        configureSearchController()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.input.value = .shouldUpdatePhotoLike
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.tranform(input: self.input)
            .bind { [weak self] output in
                
                guard let self else { return }
                
                switch output {
                case .outputEmptyStatus(let status):
                    contentView.showEmptyResult(emptyStatus: status)
                    
                case .photoList(let photoList):
                    contentView.showSearchResult(data: photoList)
                    
                case .networkError(let message):
                    showNetworkErrorAlert(message: message) { _ in
                        self.contentView.hideAllToasts()
                    }
                    
                case .shouldScrollUp(let signal):
                    if (signal) {
                        contentView.scrollUpToTop()
                    }

                case .orderByDidChange:
                    contentView.updateOrderByButton()
                }
            }
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = Literal.Placeholder.search
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.automaticallyShowsCancelButton = true

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

//MARK: - User Action Handling
extension PhotoSearchViewController: PhotoSearchRootViewDelegate, UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.input.value = .searchButtonTapped(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.input.value = .inputEmptyStatus(.emptySearchKeyword)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.contentView.hideToast()
        self.input.value = .inputEmptyStatus(.emptySearchKeyword)
    }

    func doPagination() {
        self.input.value = .doPagination
    }
    
    func photoCellTapped(photo: PhotoCellModel) {
        let nextVC = PhotoDetailViewController(photo: photo)
        
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func likeButtonTapped(photo: PhotoCellModel, image: UIImage) {
        self.input.value = .likeButtonTapped(photo: photo, image: image)
    }
    
    func orderByButtonTapped() {
        self.input.value = .orderByButtonTapped
    }
}
