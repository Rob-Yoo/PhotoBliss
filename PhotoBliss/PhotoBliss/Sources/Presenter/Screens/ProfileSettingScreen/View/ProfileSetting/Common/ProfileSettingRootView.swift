//
//  ProfileSettingRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit
import SnapKit
import Then

final class ProfileSettingRootView: BaseView, RootViewProtocol {
    var navigationTitle: String
    
    let editableProfileImageView = CurrentProfileImageView()
    let nicknameTextFieldView = NicknameTextFieldView()
    let mbtiSettingView = MbtiSettingView()
    lazy var completeButton = TextButton(type: .complete)
    
    init(type: ProfileSettingType) {
        self.navigationTitle = type.navigationTitle
        super.init(frame: .zero)
        self.configureSubviews(type: type)
    }
    
    override func configureView() {
        self.backgroundColor = .systemBackground
    }
}

//MARK: - Configure Subviews
extension ProfileSettingRootView {
    private func configureSubviews(type: ProfileSettingType) {
        self.configureEditableProfileImageView()
        self.configureNicknameTextFieldView()
        self.configureMbtiSettingView()
        
        if (type == .New) {
            self.configureCompleteButton()
        }
    }
    
    private func configureEditableProfileImageView() {
        self.addSubview(editableProfileImageView)
        
        editableProfileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(editableProfileImageView.snp.width)
        }
    }
    
    private func configureNicknameTextFieldView() {
        self.addSubview(nicknameTextFieldView)
        
        nicknameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(editableProfileImageView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    private func configureMbtiSettingView() {
        self.addSubview(mbtiSettingView)
        
        mbtiSettingView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(nicknameTextFieldView.snp.height).multipliedBy(1.5)
        }
    }
    
    private func configureCompleteButton() {
        self.addSubview(completeButton)
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
    }
}
