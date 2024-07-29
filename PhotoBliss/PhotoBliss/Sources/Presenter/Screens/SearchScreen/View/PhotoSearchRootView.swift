//
//  PhotoSearchRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import UIKit
import SnapKit
import Then
import Toast


protocol PhotoSearchRootViewDelegate: AnyObject {
    func doPagination()
    func photoCellTapped(photo: PhotoCellModel)
    func likeButtonTapped(photo: PhotoCellModel, image: UIImage)
    func orderByButtonTapped()
}

final class PhotoSearchRootView: BaseView, RootViewProtocol {
    
    private var photoList = [PhotoCellModel]()
    
    let navigationTitle = Literal.NavigationTitle.search
    
    private lazy var searchOptionView = PhotoSearchOptionView().then {
        $0.orderByButton.addTarget(self, action: #selector(orderByButtonTapped), for: .touchUpInside)
    }
    
    private let emptyResultView = EmptyResultView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.prefetchDataSource = self
        $0.keyboardDismissMode = .onDrag
    }
    
    weak var delegate: PhotoSearchRootViewDelegate?
    
    override func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        self.addSubview(searchOptionView)
        self.addSubview(collectionView)
        self.addSubview(emptyResultView)
    }
    
    override func configureLayout() {
        
        searchOptionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(35)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchOptionView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyResultView.snp.makeConstraints {
            $0.top.equalTo(searchOptionView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }

    }

    @objc private func orderByButtonTapped() {
        delegate?.orderByButtonTapped()
    }
    
    private func showInvalidLikeToastMessage() {
        let toastStyle = ToastStyle.shadowToastStyle
        
        self.hideToast()
        self.makeToast(Literal.ToastMessage.invalidLike, duration: 1.5, position: .center, style: toastStyle)
    }
}

//MARK: - Update UI
extension PhotoSearchRootView {
    func showSearchResult(data: [PhotoCellModel]) {
        self.emptyResultView.isHidden = true
        self.photoList = data
        self.collectionView.reloadData()
        self.hideToastActivity()
        self.collectionView.isHidden = false
    }

    func showEmptyResult(emptyStatus: PhotoSearchViewModel.EmptyStatus) {
        self.collectionView.isHidden = true
        self.emptyResultView.isHidden = false
        self.emptyResultView.update(emptyText: emptyStatus.labelText)
    }
    
    func scrollUpToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    }
    
    func updateOrderByButton() {
        let orderBy = self.searchOptionView.orderByButton.toggle()
        let message = "정렬 옵션이 " + orderBy.title + "으로 변경됩니다."
        let toastStyle = ToastStyle.shadowToastStyle
        
        self.hideAllToasts()
        self.makeToast(message, duration: 1.5, position: .top ,style: toastStyle)
    }
    
    func reloadPhotoList() {
        if (self.collectionView.isHidden == false) {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - CollectionView Setting
extension PhotoSearchRootView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, PhotoCollectionViewCellDelegate {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 2) / 2
        let height = width * 1.4

        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = self.photoList[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(cellType: .searchResult, data: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if self.photoList.count - 2 == indexPath.item {
                self.makeToastActivity(.center)
                delegate?.doPagination()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.photoList[indexPath.item]
        
        delegate?.photoCellTapped(photo: photo)
    }
    
    func likeButtonTapped(idx: Int, selectedImage: UIImage?, wasLike: Bool) {
        let photo = self.photoList[idx]
        
        guard let selectedImage else {
            if (!wasLike) { self.showInvalidLikeToastMessage() }
            return
        }
        
        let message = wasLike ? Literal.ToastMessage.deleteLike : Literal.ToastMessage.addLike
        let toastStyle = ToastStyle.shadowToastStyle
        
        self.hideToast()
        self.makeToast(message, duration: 1.0, position: .top, style: toastStyle)
        self.photoList[idx].isLike.toggle()
        delegate?.likeButtonTapped(photo: photo, image: selectedImage)
    }
}
