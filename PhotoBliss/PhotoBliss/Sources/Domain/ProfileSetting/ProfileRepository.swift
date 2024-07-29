//
//  ProfileRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import Foundation
import UIKit.UIImage

final class ProfileRepository {
    func loadNickname() -> String {
        return UserDefaultsStorage.nickname ?? ""
    }
    
    func loadProfileImageNumber() -> Int {
        guard let imageNumber = UserDefaultsStorage.profileImageNumber else {
            let randomNumber = Int.random(in: 0..<UIImage.profileImages.count)
            
            return randomNumber
        }
        
        return Int(imageNumber)!
    }
    
    func saveUserProfile(nickname: String, profileImageNumber: Int) {
        let isUser = UserDefaultsStorage.isUser

        if (isUser == false) {
            UserDefaultsStorage.isUser = true
        }
        
        UserDefaultsStorage.nickname = nickname
        UserDefaultsStorage.profileImageNumber = String(profileImageNumber)
    }
}
