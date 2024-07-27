//
//  LikeListViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import UIKit

final class PhotoLikeViewController: BaseViewController<PhotoLikeRootView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarAppearence(appearenceType: .opaque)
    }
}
