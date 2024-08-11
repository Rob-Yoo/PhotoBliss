//
//  EmptyResultView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import UIKit
import SnapKit
import Then

final class EmptyResultView: BaseView {
    private let titleLabel = UILabel().then {
        $0.font = .black20
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
    }
    
    func update(emptyText: String) {
        self.titleLabel.text = emptyText
    }
}
