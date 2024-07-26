//
//  UIImage+Extension.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

extension UIImage {
    static let profileImages: [UIImage] = [.profile0, .profile1, .profile2, .profile3, .profile4, .profile5, .profile6, .profile7, .profile8, .profile9, .profile10, .profile11]
    
    static let star = UIImage(systemName: "star.fill")
    static let camera = UIImage(systemName: "camera.fill")
    static let leftArrow = UIImage(systemName: "chevron.left")
    static let person = UIImage(systemName: "person.fill")
    
    func resizeImage(size: CGSize) -> UIImage {
      let originalSize = self.size
      let ratio: CGFloat = {
          return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                            1 / (size.height / originalSize.height)
      }()

      return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
    }
}
