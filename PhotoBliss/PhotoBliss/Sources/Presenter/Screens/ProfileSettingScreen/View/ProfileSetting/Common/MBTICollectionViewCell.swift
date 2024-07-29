//
//  MbtiCollectionViewCell.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/28/24.
//

import UIKit
import SnapKit
import Then

protocol MBTICollectionViewCellDelegate: AnyObject {
    func mbtiButtonTapped(idx: Int)
}

final class MBTICollectionViewCell: BaseCollectionViewCell {
    
    private lazy var mbtiElementButton = MBTIElementButton().then {
        $0.addTarget(self, action: #selector(mbtiButtonTapped), for: .touchUpInside)
    }
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(mbtiElementButton)
    }
    
    override func configureLayout() {
        mbtiElementButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(isTapped: Bool, indexPath: IndexPath) {
        let mbtiElement = MBTI.allCases[indexPath.item].rawValue

        self.mbtiElementButton.setTitle(mbtiElement, for: .normal)
        self.mbtiElementButton.isTapped = isTapped
    }
    
    @objc private func mbtiButtonTapped() {
        guard let collectionView = superview as? UICollectionView, let indexPath = collectionView.indexPath(for: self) else { return }

        guard let delegate = collectionView.delegate as? MBTICollectionViewCellDelegate else {
            print("MbtiCollectionViewCellDelegate를 채택하지 않았습니다")
            return
        }
        
        delegate.mbtiButtonTapped(idx: indexPath.item)
    }
}

extension MBTICollectionViewCell {
    enum MBTI: String, CaseIterable {
        case E, S, T, J, I, N, F, P
    }
}
