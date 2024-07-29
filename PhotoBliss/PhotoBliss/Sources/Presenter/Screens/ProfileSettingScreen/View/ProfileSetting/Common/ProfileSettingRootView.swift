//
//  ProfileSettingRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit
import SnapKit
import Then

@objc protocol ProfileSettingRootViewDelegate: AnyObject {
    func profileImageViewTapped()
    func nicknameTextFieldDidChange(text: String)
    func mbtiButtonTapped(idx: Int)
    @objc optional func saveUserProfile()
    @objc optional func deleteAccountButtonTapped()
}

final class ProfileSettingRootView: BaseView, RootViewProtocol {
    var navigationTitle: String
    
    private lazy var editableProfileImageView = CurrentProfileImageView().then {
        let profileImageViewTapGR = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        
        $0.addGestureRecognizer(profileImageViewTapGR)
    }
    
    private lazy var nicknameTextFieldView = NicknameTextFieldView().then {
        $0.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
    }
    
    private lazy var mbtiSettingView = MbtiSettingView().then {
        $0.collectionView.delegate = self
        $0.collectionView.dataSource = self
    }

    private lazy var completeButton = TextButton(type: .complete).then {
        $0.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private lazy var deleteAccountButton = UILabel().then {
        let text = Literal.ButtonTitle.deleteAccount
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(deleteAccountButtonTapped))
        
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.mainTheme,
            .font: UIFont.medium15], range: range)
        $0.attributedText = attributedString
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGR)
    }
    
    private var mbtiSelectedArray: [Bool] = []
    
    weak var delegate: ProfileSettingRootViewDelegate?
    
    init(type: ProfileSettingType) {
        self.navigationTitle = type.navigationTitle
        super.init(frame: .zero)
        self.configureSubviews(type: type)
    }
    
    override func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func updateNicknameTextField(text: String) {
        self.nicknameTextFieldView.nicknameTextField.text = text
    }
    
    func updateNicknameTextFieldView(lineColor: UIColor, text: String, textColor: UIColor) {
        self.nicknameTextFieldView.update(lineColor: lineColor, text: text, textColor: textColor)
    }
    
    func updateCompleteButton(bgColor: UIColor, isEnabled: Bool) {
        self.completeButton.backgroundColor = bgColor
        self.completeButton.isEnabled = isEnabled
    }
    
    func updateEditableProfileImageView(imageNumber: Int) {
        let profileImage = UIImage.profileImages[imageNumber]
        self.editableProfileImageView.profileImageView.image = profileImage
    }
    
    func updateMbtiSelectionView(mbtiSelectedArray: [Bool]) {
        self.mbtiSelectedArray = mbtiSelectedArray
        self.mbtiSettingView.collectionView.reloadData()
    }
}

//MARK: - User Action Receiving
extension ProfileSettingRootView: MBTICollectionViewCellDelegate {
    func mbtiButtonTapped(idx: Int) {
        delegate?.mbtiButtonTapped(idx: idx)
    }
    
    @objc private func profileImageViewTapped() {
        delegate?.profileImageViewTapped()
    }
    
    @objc private func nicknameTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }

        delegate?.nicknameTextFieldDidChange(text: text)
    }
    
    @objc private func completeButtonTapped() {
        delegate?.saveUserProfile?()
    }
    
    @objc private func deleteAccountButtonTapped() {
        delegate?.deleteAccountButtonTapped?()
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
        } else {
            self.configureDeleteAccountButton()
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
    
    private func configureDeleteAccountButton() {
        self.addSubview(deleteAccountButton)
        
        deleteAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
}

//MARK: - CollectionView Setting
extension ProfileSettingRootView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mbtiSelectedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isTapped = mbtiSelectedArray[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.reusableIdentifier, for: indexPath) as? MBTICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(isTapped: isTapped, indexPath: indexPath)
        return cell
    }
}

