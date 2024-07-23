//
//  UIViewController+Extension.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import UIKit

extension UIViewController {
    
    enum NavBarAppearence {
        case opaque
        case transparent
    }
    
    func configureNavigationAppearence(appearenceType: NavBarAppearence) {
        let appearence = UINavigationBarAppearance()
        
        switch appearenceType {
        case .opaque:
            appearence.configureWithOpaqueBackground()
        case .transparent:
            appearence.configureWithTransparentBackground()
        }
        
        self.navigationController?.navigationBar.standardAppearance = appearence
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
    }
}
