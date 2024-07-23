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
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.nickname.rawValue) else {
            return ""
        }
        
        return nickname
    }
    
    func loadProfileImageNumber() -> Int {
        guard let imageNumber = UserDefaults.standard.string(forKey: UserDefaultsKey.profileImageNumber.rawValue) else {
            let randomNumber = Int.random(in: 0..<UIImage.profileImages.count)
            
            return randomNumber
        }
        
        return Int(imageNumber)!
    }
    
    func saveUserProfile(nickname: String, profileImageNumber: Int) {
        let isUser = UserDefaults.standard.bool(forKey: UserDefaultsKey.isUser.rawValue)

        if (isUser == false) {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isUser.rawValue)
        }
        UserDefaults.standard.setValue(profileImageNumber, forKey: UserDefaultsKey.profileImageNumber.rawValue)
        UserDefaults.standard.setValue(nickname, forKey: UserDefaultsKey.nickname.rawValue)
    }
}
