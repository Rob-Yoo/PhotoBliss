//
//  OnboardingViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit
import SnapKit
import Then

final class OnboardingViewController: UIViewController {

    private let appTitleLabel = UILabel().then {
        $0.text = "PhotoBliss"
        $0.textColor = .mainTheme
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 50, weight: .ultraLight)
    }
    
    private let appImageView = UIImageView().then {
        $0.image = .polaroid
        $0.contentMode = .scaleAspectFit
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "유진영"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 25, weight: .bold)
    }
    
    private lazy var startButton = TextButton(type: .start).then {
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configureHierarchy()
        self.configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureNavBarAppearence(appearenceType: .transparent)
    }
    
    @objc func startButtonTapped() {
        let nextVC = NewProfileSettingViewController(contentView: ProfileSettingRootView(type: .New))

        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - Configure Subviews
extension OnboardingViewController {
    private func configureHierarchy() {
        self.view.addSubview(appTitleLabel)
        self.view.addSubview(appImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(startButton)
    }
    
    private func configureLayout() {
        
        appImageView.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        appTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(appImageView.snp.top).inset(-45)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(appImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
    }
}

