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
        self.input.value = .viewDidLoad
        self.configureNavBarAppearence(appearenceType: .opaque)
        self.configureNavBarLeftBarButtonItem()
    }
    
    private func configureNavBarLeftBarButtonItem() {
        let backButton = UIBarButtonItem(image: .leftArrow, style: .plain, target: self, action: #selector(prevButtonTapped))

        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black
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

                case .nicknameValidationStatus(let status):
                    updateNicknameTextField(status: status)

                case .editableProfileImageNumber(let number):
                    contentView.updateEditableProfileImageView(imageNumber: number)

                case .mbtiSelectedArray(let array):
                    contentView.updateMbtiSelectionView(mbtiSelectedArray: array)
                    
                case .willDeliverProfileImageNumber(let profileImageNumber):
                    moveToProfileImageSettingView(imageNumber: profileImageNumber)
                    
                case .didPassAllValidation(let value):
                    updateCompleteButton(isValid: value)
                
                case .shouldChangeWindowScene:
                    NavigationManager.changeWindowScene(didDeleteAccount: false)

                default:
                    return
                }
            }
    }

}

//MARK: - User Action Handling
extension NewProfileSettingViewController: ProfileSettingRootViewDelegate {
    @objc private func prevButtonTapped() {
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
    
    func saveUserProfile() {
        self.input.value = .saveButtonTapped
    }
}

//MARK: - Update Views
extension NewProfileSettingViewController {
    private func updateNicknameTextField(status: ProfileSettingViewModel.NicknameValidationStatus) {
        let statusColor: UIColor = (status == .ok) ? .mainTheme : .warning
        let lineColor: UIColor = (status == .empty) ? .lightGray : .black
        
        self.contentView.updateNicknameTextFieldView(lineColor: lineColor, text: status.statusText, textColor: statusColor)
    }
    
    private func moveToProfileImageSettingView(imageNumber: Int) {
        let nextVC = ProfileImageSettingViewController(contentView: ProfileImageSettingRootView(type: .New), profileImageNumber: imageNumber)
        
        nextVC.deliverProfileImageNumber = { [weak self] number in
            self?.input.value = .profileImageDidChange(number)
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func updateCompleteButton(isValid: Bool) {
        let bgColor: UIColor = isValid ? .mainTheme : .disabled
        let isEnabled = isValid
        
        self.contentView.updateCompleteButton(bgColor: bgColor, isEnabled: isEnabled)
    }
}
