//
//  NavigationManager.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit

enum NavigationManager {
    static func changeWindowScene(didDeleteAccount: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let navigationController = didDeleteAccount ? NavigationController(rootViewController: OnboardingViewController()) : TabBarController()
        
        sceneDelegate?.window?.rootViewController = navigationController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
