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
    func searchButtonTapped(searchText: String)
    func doPagination(currentPhotoList: [PhotoCellModel])
}

final class PhotoSearchRootView: BaseView, RootViewProtocol {
    
    private var photoList = [PhotoCellModel]()
    
    let navigationTitle = Literal.NavigationTitle.search
    
    private lazy var searchBar = UISearchBar().then {
        $0.placeholder = Literal.Placeholder.search
        $0.searchBarStyle = .minimal
        $0.delegate = self
    }
    
    private let line = UIView().then {
        $0.backgroundColor = .disabled
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.prefetchDataSource = self
        $0.keyboardDismissMode = .onDrag
    }
    
    weak var delegate: PhotoSearchRootViewDelegate?
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 2) / 2
        let height = width * 1.4

        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        return layout
    }
    
    override func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    override func configureHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(line)
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        
        line.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func updateUI(data: [PhotoCellModel]) {
        self.photoList = data
        self.collectionView.reloadData()
        self.hideToastActivity()
    }
    
    func scrollUpToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    }
}

extension PhotoSearchRootView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
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
                delegate?.doPagination(currentPhotoList: photoList)
            }
        }
    }
}

extension PhotoSearchRootView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        delegate?.searchButtonTapped(searchText: searchText)
    }
}
