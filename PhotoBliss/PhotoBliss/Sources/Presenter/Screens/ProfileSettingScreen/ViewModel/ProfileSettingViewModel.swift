//
//  ProfileSettingViewModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import Foundation

final class ProfileSettingViewModel {
    
    enum Input {
        case viewDidLoad
        case nickname(_ nickname: String)
        case profileImageNumber(_ number: Int)
        case profileImageViewTapped
        case saveButtonTapped
    }
    
    enum Output {
        case nickname(_ nickname: String)
        case nicknameValidationStatus(_ status: NicknameValidationStatus)
        case isValid(_ status: Bool)
        case profileImageNumber(_ number: Int)
        case transition(imageNumber: Int)
    }
    
    private let output = Observable<Output>()
    
    private var profileImageNumber = -1
    private let repository = ProfileRepository()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.loadUserProfile()
            case .nickname(let nickname):
                self?.checkNicknameValidationStatus(nickname: nickname)
            case .profileImageNumber(let number):
                self?.changeProfileImage(number: number)
            case .profileImageViewTapped:
                self?.passThroughProfileImageNumber()
            case .saveButtonTapped:
                break
            }
        }
        
        return output
    }
}

extension ProfileSettingViewModel {
    private func loadUserProfile() {
        let userNickname = self.repository.loadNickname()
        let userProfileImageNumber = self.repository.loadProfileImageNumber()
        
        self.output.value = .nickname(userNickname)
        self.checkNicknameValidationStatus(nickname: userNickname)
        self.output.value = .profileImageNumber(userProfileImageNumber)
        self.profileImageNumber = userProfileImageNumber
    }
    
    private func checkNicknameValidationStatus(nickname: String) {
        let isValid = self.validateNickname(nickname: nickname)
        
        self.output.value = .nicknameValidationStatus(isValid)
    }
    
    private func saveProfile() {
    }
    
    private func changeProfileImage(number: Int) {
        self.output.value = .profileImageNumber(number)
        self.profileImageNumber = number
    }
    
    private func passThroughProfileImageNumber() {
        guard (profileImageNumber != -1) else { return }
        self.output.value = .transition(imageNumber: self.profileImageNumber)
    }
}

//MARK: - 닉네임 유효성 검사 로직
extension ProfileSettingViewModel {
    private func validateNickname(nickname: String) -> NicknameValidationStatus {
        if (nickname.isEmpty) { return .empty }
        if (isCountError(nickname)) { return .countError }
        if (isCharacterError(nickname)) { return .characterError }
        if (isNumberError(nickname)) { return .numberError }
        if (isWhitespaceError(nickname)) { return .whitespaceError }
        
        return .ok
    }

    private func isCountError(_ nickname: String) -> Bool {
        if (nickname.count < 2 || nickname.count >= 10) { return true }
        return false
    }
    
    private func isCharacterError(_ nickname: String) -> Bool {
        let forbiddenCharacters = ["@", "#", "$", "%"]
        let forbidden = nickname.filter { forbiddenCharacters.contains(String($0)) }
        
        return forbidden.isEmpty ? false : true
    }
    
    private func isNumberError(_ nickname: String) -> Bool {
        let forbidden = nickname.filter { $0.isNumber }
        
        return forbidden.isEmpty ? false : true
    }
    
    private func isWhitespaceError(_ nickname: String) -> Bool {
        let filteredWhitespace = nickname.trimmingCharacters(in: .whitespaces)
        
        guard nickname == filteredWhitespace else { return true }
        guard nickname.filter({ $0.isWhitespace }).count <= 1 else { return true }
        
        return false
    }
}
