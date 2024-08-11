//
//  PhotoSearchOptionView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/28/24.
//

import UIKit
import SnapKit
import Then

final class PhotoSearchOptionView: BaseView {
    
    lazy var colorOptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(ColorOptionCollectionViewCell.self, forCellWithReuseIdentifier: ColorOptionCollectionViewCell.reusableIdentifier)
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
    }
    let orderByButton = OrderByButton(type: .search)
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(colorOptionCollectionView)
        self.addSubview(orderByButton)
    }
    
    override func configureLayout() {
        
        colorOptionCollectionView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(orderByButton.snp.leading).offset(10)
        }
        
        orderByButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(10)
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(orderByButton.snp.height).multipliedBy(2.2)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 20)
        layout.minimumLineSpacing = 10
        return layout
    }
    
    override func draw(_ rect: CGRect) {
        guard let layout = self.colorOptionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let width = (self.frame.width - 40) / 4
        let height = self.frame.height
        
        layout.itemSize = CGSize(width: width, height: height)
    }
}

extension PhotoSearchOptionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoSearchViewModel.Color.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = PhotoSearchViewModel.Color.allCases[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorOptionCollectionViewCell.reusableIdentifier, for: indexPath) as? ColorOptionCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(color: color.color, colorName: color.title)
        return cell
    }
    
    
}
