//
//  NewProfileSettingViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

final class NewProfileSettingViewController: BaseViewController<ProfileSettingRootView> {
    
    private let viewModel = ProfileSettingViewModel()
    private let input = Observable<ProfileSettingViewModel.Input>()
    
    override init(contentView: ProfileSettingRootView) {
        super.init(contentView: contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBarAppearence(appearenceType: .opaque)
        self.configureNavBarLeftBarButtonItem()
        self.input.value = .viewDidLoad
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
        self.viewModel.transform(input: input)
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
                case .transition(let profileImageNumber):
                    self?.moveToProfileImageSettingView(imageNumber: profileImageNumber)
                }
            }
    }

}

//MARK: - User Action Handling
extension NewProfileSettingViewController {
    @objc private func prevButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func profileImageViewTapped() {
        self.input.value = .profileImageViewTapped
    }
    
    @objc private func nicknameTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.input.value = .nickname(text)
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
        
        profileImageView.image = profileImage
    }
    
    private func moveToProfileImageSettingView(imageNumber: Int) {
        let nextVC = ProfileImageSettingViewController(contentView: ProfileImageSettingRootView(type: .New), profileImageNumber: imageNumber)
        
        nextVC.deliverProfileImageNumber = { [weak self] number in
            self?.input.value = .profileImageNumber(number)
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
