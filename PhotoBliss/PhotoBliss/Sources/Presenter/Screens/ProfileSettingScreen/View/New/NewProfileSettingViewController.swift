//
//  NewProfileSettingViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

final class NewProfileSettingViewController: BaseViewController<ProfileSettingView> {
    
    private let viewModel: ProfileSettingViewModel
    
    init(contentView: ProfileSettingView, viewModel: ProfileSettingViewModel) {
        self.viewModel = viewModel
        super.init(contentView: contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationAppearence(appearenceType: .opaque)
        self.configureNavBarLeftBarButtonItem()
        self.viewModel.input.value = .viewDidLoad
    }
    
    private func configureNavBarLeftBarButtonItem() {
        let backButton = UIBarButtonItem(image: .leftArrow, style: .plain, target: self, action: #selector(prevButtonTapped))

        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    override func addUserAction() {
        let profileImageViewTapGR = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        
        self.contentView.editableProfileImageView.addGestureRecognizer(profileImageViewTapGR)
        self.contentView.nicknameTextFieldView.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
        self.contentView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        self.addKeyboardDismissAction()
    }
    
    override func bindViewModel() {
        self.viewModel.transform()
            .bind { [weak self] output in
                switch output {
                case .nickname(let nickname):
                    self?.contentView.nicknameTextFieldView.nicknameTextField.text = nickname
                case .nicknameValidationStatus(let status):
                    self?.updateNicknameTextFieldView(status: status)
                    self?.updateCompleteButton(status: status)
                case .isValid(let isValid):
                    break
                case .profileImageNumber(let number):
                    self?.updateEditableProfileImageView(imageNumber: number)
                }
            }
    }

}

//MARK: - User Action Handling
extension NewProfileSettingViewController {
    @objc private func prevButtonTapped() {
        self.dismiss(animated: false)
    }
    
    @objc private func profileImageViewTapped() {
    }
    
    @objc private func nicknameTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.viewModel.input.value = .nickname(text)
    }
    
    @objc private func completeButtonTapped() {
//        self.viewModel.inputSaveButtonTapped.value = ()
    }
}

//MARK: - Update Views
extension NewProfileSettingViewController {
    private func updateNicknameTextFieldView(status: NicknameValidationStatus) {
        let nicknameTextFieldView = self.contentView.nicknameTextFieldView

        nicknameTextFieldView.update(status: status)
    }
    
    private func updateCompleteButton(status: NicknameValidationStatus) {
        let bgColor: UIColor = (status == .ok) ? .mainTheme : .disabled
        let isEnabled = (status == .ok)
        
        self.contentView.completeButton.backgroundColor = bgColor
        self.contentView.completeButton.isEnabled = isEnabled
    }
    
    private func updateEditableProfileImageView(imageNumber: Int) {
        let profileImage = UIImage.profileImages[imageNumber]
        let profileImageView = self.contentView.editableProfileImageView.profileImageView
        
        profileImageView.update(image: profileImage)
    }
}
