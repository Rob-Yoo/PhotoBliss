//
//  NewProfileSettingViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

final class NewProfileSettingViewController: BaseViewController<ProfileSettingRootView> {
    
    private let viewModel = ProfileSettingViewModel()
    private let input = Observable<ProfileSettingViewModel.Input>(.viewDidLoad)
    
    override init(contentView: ProfileSettingRootView) {
        super.init(contentView: contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                switch output {
                case .nicknameValidationStatus(let status):
                    let bgColor: UIColor = (status == .ok) ? .mainTheme : .disabled
                    let isEnabled = (status == .ok)

                    self?.updateNicknameTextField(status: status)
                    self?.contentView.updateCompleteButton(bgColor: bgColor, isEnabled: isEnabled)

                case .isValid(let isValid):
                    break

                case .profileImageNumber(let number):
                    self?.contentView.updateEditableProfileImageView(imageNumber: number)

                case .transition(let profileImageNumber):
                    self?.moveToProfileImageSettingView(imageNumber: profileImageNumber)

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
        self.input.value = .nickname(text)
    }
    
    func saveUserProfile() {
//        self.viewModel.inputSaveButtonTapped.value = ()
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
            self?.input.value = .profileImageNumber(number)
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
