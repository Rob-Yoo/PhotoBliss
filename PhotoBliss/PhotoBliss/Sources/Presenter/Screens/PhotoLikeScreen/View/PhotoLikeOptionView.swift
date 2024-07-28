//
//  PhotoLikeOptionView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/28/24.
//

import UIKit
import SnapKit
import Then

final class PhotoLikeOptionView: BaseView {
    
    let orderByButton = OrderByButton(type: .like)
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(orderByButton)
    }
    
    override func configureLayout() {
        orderByButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-5)
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(orderByButton.snp.height).multipliedBy(2.5)
        }
    }
}
