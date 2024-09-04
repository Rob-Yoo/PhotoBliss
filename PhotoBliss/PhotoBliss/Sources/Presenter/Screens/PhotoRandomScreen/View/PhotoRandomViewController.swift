//
//  PhotoRandomViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 8/12/24.
//

import UIKit

final class PhotoRandomViewController: BaseViewController<PhotoRandomRootView> {
    
    private let input = Observable<PhotoRandomViewModel.Input>(.viewDidLoad)
    private let viewModel = PhotoRandomViewModel()
    private var photoList = [PhotoCellModel]() {
        didSet {
            contentView.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBarAppearence(appearenceType: .hidden)
    }
    
    override func addUserAction() {
        self.contentView.collectionView.delegate = self
        self.contentView.collectionView.dataSource = self
    }
    
    override func bindViewModel() {
        viewModel.transform(input: input).bind { [weak self] output in
            guard let self else { return }
            
            switch output {
            case .photoList(let list):
                photoList = list
                print(photoList)
            case .networkError(let message):
                showNetworkErrorAlert(message: message) { _ in
                    self.contentView.hideToastActivity()
                }
            }
        }
    }
}

extension PhotoRandomViewController: UICollectionViewDelegate, UICollectionViewDataSource, PhotoRandomCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photoList[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoRandomCollectionViewCell.reusableIdentifier, for: indexPath) as? PhotoRandomCollectionViewCell else { return UICollectionViewCell() }
        
        cell.updateUI(number: indexPath.item + 1, photo: photo)
        return cell
    }
    
    func likeButtonTapped(idx: Int, selectedImage: UIImage?, wasLike: Bool) {
        guard let selectedImage else { return }
        
        self.input.value = .likeButtonTapped(photo: photoList[idx], image: selectedImage)
        self.photoList[idx].isLike.toggle()
    }
    
}
