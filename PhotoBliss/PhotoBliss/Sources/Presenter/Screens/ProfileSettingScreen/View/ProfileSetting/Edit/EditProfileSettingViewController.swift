//
//  EditProfileSettingViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/29/24.
//

import UIKit

final class EditProfileSettingViewController: BaseViewController<ProfileSettingRootView> {
    
    private let viewModel = ProfileSettingViewModel()
    private let input = Observable<ProfileSettingViewModel.Input>()
    
    private lazy var saveBarButton = UIBarButtonItem(title: Literal.ButtonTitle.save, style: .plain, target: self, action: #selector(saveButtonTapped))
    
    override init(contentView: ProfileSettingRootView) {
        super.init(contentView: contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.input.value = .viewDidLoad
        self.navigationItem.rightBarButtonItem = saveBarButton
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.configureNavBarAppearence(appearenceType: .opaque)
    }
    
    override func addUserAction() {
        self.contentView.delegate = self
        self.addKeyboardDismissAction()
    }
    
    override func bindViewModel() {
        self.viewModel.transform(input: input)
            .bind { [weak self] output in
                
                guard let self else { return }
                
                switch output {

                case .savedUserNickname(let nickname):
                    contentView.updateNicknameTextField(text: nickname)
                
                case .nicknameValidationStatus(let status):
                    updateNicknameTextField(status: status)

                case .editableProfileImageNumber(let number):
                    contentView.updateEditableProfileImageView(imageNumber: number)

                case .mbtiSelectedArray(let array):
                    contentView.updateMbtiSelectionView(mbtiSelectedArray: array)
                    
                case .willDeliverProfileImageNumber(let profileImageNumber):
                    moveToProfileImageSettingView(imageNumber: profileImageNumber)
                    
                case .didPassAllValidation(let value):
                    updateSaveBarButton(isValid: value)

                default:
                    return
                }
            }
    }
}

//MARK: - User Action Handling
extension EditProfileSettingViewController: ProfileSettingRootViewDelegate {
    @objc private func saveButtonTapped() {
        self.input.value = .saveButtonTapped
        self.navigationController?.popViewController(animated: true)
    }
    
    func profileImageViewTapped() {
        self.input.value = .profileImageViewTapped
    }
    
    func nicknameTextFieldDidChange(text: String) {
        self.input.value = .nicknameDidChange(text)
    }
    
    func mbtiButtonTapped(idx: Int) {
        self.input.value = .mbtiButtonTapped(idx)
    }
    
    func deleteAccountButtonTapped() {
        self.showDeleteAccountAlert { [weak self] _ in
            self?.input.value = .accountShouldDelete
            NavigationManager.changeWindowScene(didDeleteAccount: true)
        }
    }
}

//MARK: - Update Views
extension EditProfileSettingViewController {
    private func updateNicknameTextField(status: ProfileSettingViewModel.NicknameValidationStatus) {
        let statusColor: UIColor = (status == .ok) ? .mainTheme : .warning
        let lineColor: UIColor = (status == .empty) ? .lightGray : .black
        
        self.contentView.updateNicknameTextFieldView(lineColor: lineColor, text: status.statusText, textColor: statusColor)
    }
    
    private func moveToProfileImageSettingView(imageNumber: Int) {
        let nextVC = ProfileImageSettingViewController(contentView: ProfileImageSettingRootView(type: .Editing), profileImageNumber: imageNumber)
        
        nextVC.deliverProfileImageNumber = { [weak self] number in
            self?.input.value = .profileImageDidChange(number)
        }
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func updateSaveBarButton(isValid: Bool) {
        let textColor: UIColor = isValid ? .black : .disabled
        let isEnabled = isValid
        
        self.saveBarButton.setTitleTextAttributes([.foregroundColor: textColor, .font: UIFont.bold16], for: .normal)
        self.saveBarButton.isEnabled = isEnabled
    }
}
