//
//  PhotoDetailViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import UIKit

final class PhotoDetailViewController: BaseViewController<PhotoDetailRootView> {
    
    private let input = Observable<PhotoDetailViewModel.Input>(.shouldLoadPhotoDetail)
    private let viewModel: PhotoDetailViewModel
    private var monitorId: Int?
    
    init(photo: PhotoCellModel) {
        self.viewModel = PhotoDetailViewModel(photo: photo)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBarAppearence(appearenceType: .opaque)
        self.addNetworkMonitor()
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: self.input)
            .bind { [weak self] output in
                
                guard let self else { return }
                
                switch output {
                case .photoDetail(let data):
                    contentView.updateUI(photoDetail: data)
                
                case .networkError(let message):
                    showNetworkErrorAlert(message: message) { _ in
                        self.contentView.hideToastActivity()
                    }
                }
            }
    }
    
    deinit {
        print("Photo Detail Deinit")
        guard let monitorId else { return }
        
        NetworkManger.shared.stopNetworkMonitoring(monitorId: monitorId)
    }
    
    private func addNetworkMonitor() {
        let id = NetworkManger.shared.doMonitoringNetwork { [weak self] in
            self?.input.value = .shouldLoadPhotoDetail
        }
        self.monitorId = id
    }
}

//MARK: - User Action Handling
extension PhotoDetailViewController: PhotoDetailRootViewDelegate {
    func likeButtonTapped(image: UIImage) {
        self.input.value = .likeButtonTapped(image: image)
    }
}
