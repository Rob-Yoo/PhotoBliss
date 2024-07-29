//
//  MbtiSettingView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/29/24.
//

import UIKit
import SnapKit
import Then

final class MbtiSettingView: BaseView {
    
    private let titleLabel = UILabel().then {
        $0.text = "MBTI"
        $0.textColor = .black
        $0.font = .heavy17
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.isScrollEnabled = false
        $0.register(MBTICollectionViewCell.self, forCellWithReuseIdentifier: MBTICollectionViewCell.reusableIdentifier)
    }
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(50)
            $0.verticalEdges.trailing.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        return layout
    }
    
    override func draw(_ rect: CGRect) {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let width = (self.collectionView.frame.width - 15) / 4
        let height = width
        
        layout.itemSize = CGSize(width: width, height: height)
    }
}
