//
//  NicknameTextFieldView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit
import SnapKit
import Then

final class NicknameTextFieldView: BaseView {
    
    lazy var nicknameTextField = UITextField().then {
        $0.placeholder = Literal.Placeholder.nickname
        $0.font = .regular14
        $0.textColor = .black
        $0.borderStyle = .none
        $0.delegate = self
    }
    
    private let line = UIView().then {
        $0.backgroundColor = .unselected
    }
    
    let statusLabel = UILabel().then {
        $0.textColor = .mainTheme
        $0.font = .regular13
    }
    
    override func configureHierarchy() {
        self.addSubview(nicknameTextField)
        self.addSubview(line)
        self.addSubview(statusLabel)
    }
    
    override func configureLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        line.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(line).offset(3)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func update(status: NicknameValidationStatus) {
        let statusColor: UIColor = (status == .ok) ? .black : .mainTheme
        let lineColor: UIColor = (status == .ok) ? .black : .unselected

        self.line.backgroundColor = lineColor
        self.statusLabel.text = status.statusText
        self.statusLabel.textColor = statusColor
    }
    
}

extension NicknameTextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
