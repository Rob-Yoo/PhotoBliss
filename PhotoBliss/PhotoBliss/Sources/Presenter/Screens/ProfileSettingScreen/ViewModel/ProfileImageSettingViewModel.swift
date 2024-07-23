//
//  ProfileImageSettingViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import Foundation

final class ProfileImageSettingViewModel {
    
    enum Input {
        case profileImageNumber(_ number: Int)
    }
    
    enum Output {
        case profileImageNumber(_ number: Int)
    }
    
    private let output = Observable<Output>()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            switch event {
            case .profileImageNumber(let number):
                self?.output.value = .profileImageNumber(number)
            }
        }
        
        return output
    }
}
