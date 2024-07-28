//
//  ProfileSettingRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit
import SnapKit
import Then

typealias MbtiInfo = (title: String, selected: Bool)

protocol ProfileSettingRootViewDelegate: AnyObject {
    func profileImageViewTapped()
    func nicknameTextFieldDidChange(text: String)
    func saveUserProfile()
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
    
    private var mbti: [MbtiInfo] = [
        (title: "E", selected: true),
        (title: "S", selected: true),
        (title: "T", selected: false),
        (title: "J", selected: true),
        (title: "I", selected: false),
        (title: "N", selected: false),
        (title: "F", selected: true),
        (title: "P", selected: false)
    ]
    
    weak var delegate: ProfileSettingRootViewDelegate?
    
    init(type: ProfileSettingType) {
        self.navigationTitle = type.navigationTitle
        super.init(frame: .zero)
        self.configureSubviews(type: type)
    }
    
    override func configureView() {
        self.backgroundColor = .systemBackground
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
}

//MARK: - User Action Receiving
extension ProfileSettingRootView {
    @objc private func profileImageViewTapped() {
        delegate?.profileImageViewTapped()
    }
    
    @objc private func nicknameTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }

        delegate?.nicknameTextFieldDidChange(text: text)
    }
    
    @objc private func completeButtonTapped() {
        delegate?.saveUserProfile()
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

//MARK: - CollectionView Setting
extension ProfileSettingRootView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mbti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mbtiInfo = mbti[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MbtiCollectionViewCell.reusableIdentifier, for: indexPath) as? MbtiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(mbtiInfo: mbtiInfo)
        return cell
    }
}

