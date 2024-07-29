//
//  UserDefaultsStorage.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/29/24.
//

import Foundation
import UIKit.UIImage

enum UserDefaultsStorage {
    
    private enum UserDefaultsKey: String, CaseIterable {
        case profileImageNumber
        case nickname
        case isUser
        case mbti
    }
    
    static var nickname: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.nickname.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.nickname.rawValue)
        }
    }
    
    static var profileImageNumber: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.profileImageNumber.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.profileImageNumber.rawValue)
        }
    }
    
    static var isUser: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsKey.isUser.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.isUser.rawValue)
        }
    }
}
