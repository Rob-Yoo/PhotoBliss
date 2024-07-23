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
    
    let input: Observable<Input>
    private let output = Observable<Output>()
    
    init(imageNumber: Int) {
        self.input = Observable<Input>(.profileImageNumber(imageNumber))
    }
    
    func transform() -> Observable<Output> {
        self.input.bind { [weak self] event in
            switch event {
            case .profileImageNumber(let number):
                self?.output.value = .profileImageNumber(number)
            }
        }
        
        return output
    }
}
