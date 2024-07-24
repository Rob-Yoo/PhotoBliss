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
        case hidden
    }
    
    func configureNavBarAppearence(appearenceType: NavBarAppearence) {
        let appearence = UINavigationBarAppearance()
        
        switch appearenceType {
        case .opaque:
            appearence.configureWithOpaqueBackground()
        case .transparent:
            appearence.configureWithTransparentBackground()
        case .hidden:
            self.navigationController?.navigationBar.isHidden = true
            return
        }
        
        self.navigationController?.navigationBar.standardAppearance = appearence
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
