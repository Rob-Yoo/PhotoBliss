//
//  NicknameValidationStatus.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

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
