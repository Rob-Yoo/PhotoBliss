//
//  TabBarController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import Then

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBarController()
        self.configureTabBar()
    }

    private func configureTabBarController() {
        self.tabBar.backgroundColor = .systemBackground
        
        self.viewControllers = Tab.allCases.map {
            let (image, selectedImage) = $0.itemResource
            
            return NavigationController(rootViewController: $0.viewController).then {
                $0.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
            }
        }
    }
    
    private func configureTabBar() {
        let apearance = UITabBarAppearance()
        
        apearance.configureWithOpaqueBackground()
        self.tabBar.standardAppearance = apearance
        self.tabBar.scrollEdgeAppearance = apearance
        self.tabBar.tintColor = .black
    }

}

extension TabBarController {
    typealias TabItemResource = (image: UIImage, selectedImage: UIImage)
    
    enum Tab: CaseIterable {
        case topic
        case search
        case like
        
        var viewController: UIViewController {
            switch self {
            case .topic:
                return ViewController()
            case .search:
                return ViewController()
            case .like:
                return ViewController()
            }
        }
        
        var itemResource: TabItemResource {
            switch self {
            case .topic:
                return (image: UIImage.tapTrendInactive, selectedImage: UIImage.tabTrend)
            case .search:
                return (image: UIImage.tabSearchInactive, selectedImage: UIImage.tabSearch)
            case .like:
                return (image: UIImage.tabLikeInactive, selectedImage: UIImage.tabLike)
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
}
