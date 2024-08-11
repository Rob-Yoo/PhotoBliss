//
//  ColorOptionCollectionViewCell.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 8/11/24.
//

import UIKit
import SnapKit
import Then

final class ColorOptionCollectionViewCell: BaseCollectionViewCell {
    
    private let colorView = ColorView()
    private let colorLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .medium14
    }
    
    override func configureView() {
        self.contentView.layer.borderColor = UIColor.unselected.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 17
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(colorView)
        self.contentView.addSubview(colorLabel)
    }
    
    override func configureLayout() {
        colorView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(5)
            make.width.equalTo(colorView.snp.height)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    func configureCell(color: UIColor, colorName: String) {
        self.colorView.backgroundColor = color
        self.colorLabel.text = colorName
    }
}

private final class ColorView: BaseView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
