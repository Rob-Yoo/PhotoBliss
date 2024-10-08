//
//  CamerImageView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

final class CameraImageView: UIImageView {
    
    init() {
        super.init(image: nil)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    private func configure() {
        let image = UIImage(systemName: "camera.fill")
        
        self.image = image
        self.contentMode = .center
        self.tintColor = .white
        self.backgroundColor = .mainTheme
    }
}
