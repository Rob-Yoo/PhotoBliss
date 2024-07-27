//
//  LikeListRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import UIKit
import SnapKit
import Then

protocol PhotoLikeRootViewDelegate: AnyObject {
    func photoCellTapped(photo: PhotoCellModel)
    func likeButtonTapped(photo: PhotoCellModel)
}

final class PhotoLikeRootView: BaseView, RootViewProtocol {
    private var likeList = [PhotoCellModel]()
    
    let navigationTitle = Literal.NavigationTitle.likeList
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.keyboardDismissMode = .onDrag
    }
    
    private let emptyResultView = EmptyResultView().then {
        $0.update(emptyText: Literal.LikeList.emptyLikeList)
    }
    
    weak var delegate: PhotoLikeRootViewDelegate?
    
    override func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(emptyResultView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyResultView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func showPhotoLikeList(likeList: [PhotoCellModel]) {
        self.emptyResultView.isHidden = true
        self.likeList = likeList
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
    }
    
    func showEmptyResult() {
        self.collectionView.isHidden = true
        self.emptyResultView.isHidden = false
    }
}

extension PhotoLikeRootView: UICollectionViewDelegate, UICollectionViewDataSource, PhotoCollectionViewCellDelegate {
    
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
        return self.likeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = self.likeList[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(cellType: .like, data: photo)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.likeList[indexPath.item]
        
        delegate?.photoCellTapped(photo: photo)
    }
    
    func likeButtonTapped(idx: Int, selectedImage: UIImage) {
        let photo = self.likeList[idx]
        
        delegate?.likeButtonTapped(photo: photo)
    }
}
