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
        $0.tintColor = .white
    }
    
    private let countLabel = UILabel().then {
        $0.font = .medium14
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    override func configureView() {
        self.backgroundColor = .gray.withAlphaComponent(0.7)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        self.addSubview(star)
        self.addSubview(countLabel)
    }
    
    override func configureLayout() {
        star.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(15)
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(star.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
    }
    
    func update(count: Int) {
        self.countLabel.text = count.formatted()
        self.snp.updateConstraints { make in
            make.width.equalTo(countLabel.intrinsicContentSize.width + 32)
        }
    }
}
