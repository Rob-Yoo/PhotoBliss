//
//  PhotoDetailViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import UIKit

final class PhotoDetailViewController: BaseViewController<PhotoDetailRootView> {
    
    private let photo: PhotoCellModel
    
    init(photo: PhotoCellModel) {
        self.photo = photo
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBarAppearence(appearenceType: .opaque)
        let dummyData = PhotoDetailModel(photographerImageUrl: photo.photographerImageUrl, photographerName: photo.photographerName, publishedDate: photo.publishedDate, photoImageUrl: photo.rawPhotoImageUrl, width: photo.width, height: photo.height, viewCount: 98934938, downloadCount: 688418, isLike: false)
        self.contentView.updateUI(data: dummyData)
    }
}
