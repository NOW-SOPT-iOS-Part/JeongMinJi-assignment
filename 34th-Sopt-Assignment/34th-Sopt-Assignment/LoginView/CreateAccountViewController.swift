//
//  CreateAccountViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/16/24.
//

import UIKit
import SnapKit

class CreateAccountViewController: UIViewController {
    // MARK: - Properties
    var saveNickName: ((String) -> Void)?
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .pretendard(to: .medium, size: 23)
        
        return label
    }()
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.font = .pretendard(to: .semiBold, size: 14)
        textField.backgroundColor = .gray2
        textField.textColor = .black
        textField.layer.cornerRadius = 3
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray2
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(to: .semiBold, size: 14)
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        button.layer.cornerRadius = 7
        button.isEnabled = false
        return button
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayout()
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        [nickNameLabel, nickNameTextField, saveButton].forEach {
            self.view.addSubview($0)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20.81)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: - Actions
    @objc private func saveButtonDidTap() {
        if let nickname = nickNameTextField.text, isValidNickName(nickname) {
            saveNickName?(nickname)
            self.dismiss(animated: true, completion: nil)
        } else {
            showNickNameAlert()
        }
    }
    private func isValidNickName(_ nickname: String?) -> Bool {
        guard let nickname = nickname else { return false }
        let koreanNameRegEx = "^[가-힣ㄱ-ㅎㅏ-ㅣ]+$"
        let koreanNamePred = NSPredicate(format: "SELF MATCHES %@", koreanNameRegEx)
        return koreanNamePred.evaluate(with: nickname)
    }
    private func showNickNameAlert() {
        let alert = UIAlertController(title: "닉네임 오류", message: "한글로만 이루어진 닉네임을 입력해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func updateSaveButtonState() {
        let isEnabled = !(nickNameTextField.text?.isEmpty ?? true)
        
        saveButton.isEnabled = isEnabled
        if isEnabled {
            saveButton.backgroundColor = .red1
        } else {
            saveButton.backgroundColor = .gray2
        }
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
}
