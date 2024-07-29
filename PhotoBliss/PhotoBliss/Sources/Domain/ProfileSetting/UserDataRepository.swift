//
//  UserDataRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import Foundation
import RealmSwift
import UIKit.UIImage

final class UserDataRepository {

    private let likeRepository = PhotoLikeRepository()

    var isUser: Bool {
        return UserDefaultsStorage.isUser
    }
    
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
    
    func loadMbti() -> [Bool] {
        let mbtiNumberArray = UserDefaultsStorage.mbtiNumberArray
        var mbtiBoolArray = Array(repeating: false, count: 8)
        
        if (mbtiNumberArray.isEmpty) {
            return mbtiBoolArray
        } else {
            for number in mbtiNumberArray {
                mbtiBoolArray[number] = true
            }
            
            return mbtiBoolArray
        }
    }
    
    func saveUserProfile(nickname: String, profileImageNumber: Int, mbtiBoolArray: [Bool]) {
        let isUser = UserDefaultsStorage.isUser
        var mbitNumberArray = [Int]()

        if (isUser == false) {
            UserDefaultsStorage.isUser = true
        }
        
        for (idx, value) in mbtiBoolArray.enumerated() where value {
            mbitNumberArray.append(idx)
        }
        
        UserDefaultsStorage.nickname = nickname
        UserDefaultsStorage.profileImageNumber = String(profileImageNumber)
        UserDefaultsStorage.mbtiNumberArray = mbitNumberArray
    }
    
    func deleteAllUserData() {
        let likeList = likeRepository.fetchPhotoLikeList()
        
        likeList.forEach { likeRepository.removePhotoLike(photo: $0) }
        UserDefaultsStorage.removeAll()
    }
}
