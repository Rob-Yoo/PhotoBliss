//
//  StarCountView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import SnapKit
import Then

final class StarCountView: BaseView {
    private let star = UIImageView().then {
        let config = UIImage.SymbolConfiguration(font: .regular13)
        $0.image = UIImage(systemName: "star.fill", withConfiguration: config)
        $0.tintColor = .systemYellow
    }
    
    private let countLabel = UILabel().then {
        $0.font = .regular13
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    override func configureView() {
        self.backgroundColor = .customDarkGray
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        self.addSubview(star)
        self.addSubview(countLabel)
    }
    
    override func configureLayout() {
        star.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(star).offset(5)
            $0.trailing.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    func update(count: Int) {
        self.countLabel.text = count.formatted()
    }
}
