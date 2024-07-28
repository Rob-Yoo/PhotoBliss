//
//  ProfileSettingType.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/29/24.
//

import Foundation

enum ProfileSettingType {
    case New
    case Editing
    
    var navigationTitle: String {
        switch self {
        case .New:
            return Literal.NavigationTitle.newProfile
        case .Editing:
            return Literal.NavigationTitle.editProfile
        }
    }
}
