//
//  MbtiCollectionViewCell.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/28/24.
//

import UIKit
import SnapKit
import Then

protocol MbtiCollectionViewCellDelegate: AnyObject {
    func mbtiButtonTapped(idx: Int)
}

final class MbtiCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var mbtiButton = MbtiButton().then {
        $0.addTarget(self, action: #selector(mbtiButtonTapped), for: .touchUpInside)
    }
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(mbtiButton)
    }
    
    override func configureLayout() {
        mbtiButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(mbtiInfo: MbtiInfo) {
        self.mbtiButton.setTitle(mbtiInfo.title, for: .normal)
        self.mbtiButton.isTapped = mbtiInfo.selected
    }
    
    @objc private func mbtiButtonTapped() {
        guard let collectionView = superview as? UICollectionView, let indexPath = collectionView.indexPath(for: self) else { return }

        guard let delegate = collectionView.delegate as? MbtiCollectionViewCellDelegate else {
            print("MbtiCollectionViewCellDelegate를 채택하지 않았습니다")
            return
        }
        
        delegate.mbtiButtonTapped(idx: indexPath.item)
    }
}
