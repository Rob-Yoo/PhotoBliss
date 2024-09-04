//
//  PhotoRandomRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 8/12/24.
//

import UIKit
import SnapKit
import Then

final class PhotoRandomRootView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(PhotoRandomCollectionViewCell.self, forCellWithReuseIdentifier: PhotoRandomCollectionViewCell.reusableIdentifier)
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let width = self.collectionView.frame.width
        let height = self.collectionView.frame.height
        
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
