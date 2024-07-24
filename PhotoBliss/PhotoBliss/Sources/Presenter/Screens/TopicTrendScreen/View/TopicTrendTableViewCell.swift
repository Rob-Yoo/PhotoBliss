//
//  TopicTrendTableViewCell.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import SnapKit
import Then

final class TopicTrendTableViewCell: BaseTableViewCell {
    private let topicTitleLabel = UILabel().then {
        $0.font = .bold20
        $0.textColor = .black
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .clear
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        return layout
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
    
    override func draw(_ rect: CGRect) {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let width = (self.collectionView.frame.width - 20) / 1.85
        let height = self.collectionView.frame.height
        
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(topicTitleLabel)
        self.contentView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        topicTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topicTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configureCell(topic: String) {
        self.topicTitleLabel.text = topic
    }
}
