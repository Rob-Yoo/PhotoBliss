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
        case nicknameDidChange(_ nickname: String)
        case profileImageDidChange(_ number: Int)
        case profileImageViewTapped
        case mbtiButtonTapped(_ idx: Int)
        case saveButtonTapped
    }
    
    enum Output {
        case savedUserNickname(_ nickname: String)
        case nicknameValidationStatus(_ status: NicknameValidationStatus)
        case didPassAllValidation(_ value: Bool)
        case editableProfileImageNumber(_ number: Int)
        case mbtiSelectedArray(_ array: [Bool])
        case willDeliverProfileImageNumber(_ imageNumber: Int)
        case shouldChangeWindowScene
    }
    
    private var mbtiSelectedArray = [Bool]()
    private var userNickname = ""
    private var nicknameValidStatus: NicknameValidationStatus = .empty
    private var didPassAllValidation = false
    private var profileImageNumber: Int?

    private let output = Observable<Output>()
    private let repository = ProfileRepository()
    
    func transform(input: Observable<Input>) -> Observable<Output> {
        input.bind { [weak self] event in
            
            guard let self else { return }
            
            switch event {
            case .viewDidLoad:
                loadUserProfile()
                
            case .nicknameDidChange(let nickname):
                userNickname = nickname
                checkNicknameValidationStatus(nickname: nickname)
                checkAllValidation()
                
            case .mbtiButtonTapped(let idx):
                mbtiSettingHandler(idx: idx)
                checkAllValidation()
                
            case .profileImageDidChange(let number):
                profileImageNumber = number
                output.value = .editableProfileImageNumber(number)
                
            case .profileImageViewTapped:
                guard let profileImageNumber else { return }
                output.value = .willDeliverProfileImageNumber( profileImageNumber)
                
            case .saveButtonTapped:
                saveProfile()
            }
        }
        
        return output
    }
}

//MARK: - Publish Output
extension ProfileSettingViewModel {
    private func loadUserProfile() {
        let userNickname = repository.loadNickname()
        let userProfileImageNumber = repository.loadProfileImageNumber()
        let userMbtiSelectedArray = repository.loadMbti()
        
        self.userNickname = userNickname
        self.profileImageNumber = userProfileImageNumber
        self.mbtiSelectedArray = userMbtiSelectedArray
        
        self.output.value = .savedUserNickname(userNickname)
        self.checkNicknameValidationStatus(nickname: userNickname)
        self.output.value = .editableProfileImageNumber(userProfileImageNumber)
        self.output.value = .mbtiSelectedArray(userMbtiSelectedArray)
        self.checkAllValidation()
    }
    
    private func checkNicknameValidationStatus(nickname: String) {
        let status = validateNickname(nickname: nickname)
        
        self.nicknameValidStatus = status
        self.output.value = .nicknameValidationStatus(status)
    }
    
    private func mbtiSettingHandler(idx: Int) {
        let oppositeIdx = (idx >= 4) ? idx - 4 : idx + 4
        let isOppositeTapped = mbtiSelectedArray[oppositeIdx]
        
        if (isOppositeTapped) {
            self.mbtiSelectedArray[oppositeIdx].toggle()
        }
        
        self.mbtiSelectedArray[idx].toggle()
        self.output.value = .mbtiSelectedArray(mbtiSelectedArray)
    }
    
    private func saveProfile() {
        guard didPassAllValidation, let profileImageNumber else { return }
        let isUser = repository.isUser

        self.repository.saveUserProfile(nickname: userNickname, profileImageNumber: profileImageNumber, mbtiBoolArray: mbtiSelectedArray)
        if (!isUser) { self.output.value = .shouldChangeWindowScene }
    }
    
    private func checkAllValidation() {
        let isAllMbtiSelected = mbtiSelectedArray.filter({ $0 }).count == 4
        let isValid = (nicknameValidStatus == .ok && isAllMbtiSelected)
        
        self.didPassAllValidation = isValid
        self.output.value = .didPassAllValidation(isValid)
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

extension ProfileSettingViewModel {
    enum NicknameValidationStatus {
        case ok
        case empty
        case countError
        case characterError
        case numberError
        case whitespaceError
        
        var statusText: String {
            switch self {
            case .ok:
                return Literal.NicknameStatus.ok
            case .countError:
                return Literal.NicknameStatus.countError
            case .characterError:
                return Literal.NicknameStatus.characterError
            case .numberError:
                return Literal.NicknameStatus.numError
            case .whitespaceError:
                return Literal.NicknameStatus.whitespaceError
            case .empty:
                return ""
            }
        }
    }
}
