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
    
    func showNetworkErrorAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func showDeleteAccountAlert(handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다.\n탈퇴 하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive, handler: handler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
