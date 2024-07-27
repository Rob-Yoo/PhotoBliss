//
//  PhotoSearchViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import UIKit

final class PhotoSearchViewController: BaseViewController<PhotoSearchRootView> {
    private let input = Observable<PhotoSearchViewModel.Input>(.viewDidLoad)
    private let viewModel = PhotoSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarAppearence(appearenceType: .opaque)
        configureSearchController()
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.tranform(input: self.input)
            .bind { [weak self] event in
                switch event {
                case .outputEmptyStatus(let status):
                    self?.contentView.showEmptyResult(emptyStatus: status)
                case .photoList(let photoList):
                    self?.contentView.showSearchResult(data: photoList)
                case .networkError(let message):
                    self?.showAlert(message: message)
                case .shouldScrollUp(let signal):
                    if (signal) {
                        self?.contentView.scrollUpToTop()
                    }
                }
            }
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = Literal.Placeholder.search
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .prominent
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
        self.input.value = .inputEmptyStatus(.emptySearchKeyword)
    }
    
    func doPagination(currentPhotoList: [PhotoCellModel]) {
        self.input.value = .doPagination(currentPhotoList)
    }
    
    func photoCellTapped(photo: PhotoCellModel) {
        let nextVC = PhotoDetailViewController(photo: photo)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func likeButtonTapped(photo: PhotoCellModel, image: UIImage) {
        self.input.value = .likeButtonTapped(photo: photo, image: image)
    }
}
