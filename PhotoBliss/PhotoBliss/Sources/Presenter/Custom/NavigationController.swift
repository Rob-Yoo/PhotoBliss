//
//  NavigationController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

final class NavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.configureNavigationBarAppearence()
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
    
    private func configureNavigationBarAppearence() {
        let appearence = UINavigationBarAppearance()

        appearence.configureWithOpaqueBackground()
        appearence.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationBar.standardAppearance = appearence
        self.navigationBar.scrollEdgeAppearance = appearence
        self.navigationBar.tintColor = .black
    }
}

