//
//  ViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/15/24.
//

import Foundation
import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    var nickname: String?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TVING ID 로그인"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(to: .medium, size: 23)
        
        return label
    }()
    private lazy var idTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray2])
        textField.font = .pretendard(to: .semiBold, size: 15)
        textField.backgroundColor = .gray4
        textField.textColor = .gray2
        textField.layer.cornerRadius = 3
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray2])
        textField.font = .pretendard(to: .semiBold, size: 15)
        textField.backgroundColor = .gray4
        textField.textColor = .gray2
        textField.layer.cornerRadius = 3
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("로그인하기", for: .normal)
        button.setTitleColor(.gray2, for: .normal)
        button.titleLabel?.font = .pretendard(to: .semiBold, size: 14)
        button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray4.cgColor
        button.layer.cornerRadius = 3
        button.isEnabled = false
        return button
    }()
    private lazy var findIdButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.setTitle("아이디 찾기", for: .normal)
        button.setTitleColor(.gray4, for: .normal)
        button.titleLabel?.font = .pretendard(to: .semiBold, size: 14)
        button.addTarget(self, action: #selector(findIdButtonDidTap), for: .touchUpInside)
        return button
    }()
    private let bulkHeadView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray4
        
        return view
    }()
    private lazy var findPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.gray2, for: .normal)
        button.titleLabel?.font = .pretendard(to: .semiBold, size: 14)
        button.addTarget(self, action: #selector(findPasswordButtonDidTap), for: .touchUpInside)
        return button
    }()

    private let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 계정이 없으신가요?"
        label.textColor = .gray3
        label.textAlignment = .center
        label.font = .pretendard(to: .semiBold, size: 14)
        
        return label
    }()
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        let title = "닉네임 만들러가기"
        let attributedString = NSAttributedString(string: title, attributes: [
                .font: UIFont.pretendard(to: .regular, size: 14),
                .foregroundColor: UIColor.gray2,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ])
            button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(createAccountButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setLayout()
    }

    // MARK: - SetLayout
    private func setLayout() {
        [titleLabel, idTextField, passwordTextField, loginButton, findIdButton, bulkHeadView, findPasswordButton, noAccountLabel, createAccountButton].forEach {
            self.view.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(90)
        }
        idTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(31)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextField.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        bulkHeadView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(36)
            $0.height.equalTo(12)
            $0.width.equalTo(1)
        }
        findIdButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().multipliedBy(0.7)
            $0.centerY.equalTo(bulkHeadView.snp.centerY)
            $0.height.equalTo(22)
        }
        findPasswordButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().multipliedBy(1.3)
            $0.centerY.equalTo(bulkHeadView.snp.centerY)
            $0.height.equalTo(22)
        }
        noAccountLabel.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(findIdButton.snp.bottom).offset(28)
        }
        createAccountButton.snp.makeConstraints {
            $0.centerY.equalTo(noAccountLabel.snp.centerY)
            $0.leading.equalTo(noAccountLabel.snp.trailing).offset(17)
            $0.height.equalTo(22)
            $0.width.equalTo(128)
        }
    }
    
    // MARK: - Action
    private func updateLoginButtonState() {
        let idIsNotEmpty = !(idTextField.text?.isEmpty ?? true)
        let passwordIsNotEmpty = !(passwordTextField.text?.isEmpty ?? true)
        let isEnabled = idIsNotEmpty && passwordIsNotEmpty
        
        loginButton.isEnabled = isEnabled
        if isEnabled {
            loginButton.backgroundColor = .red1
            loginButton.layer.borderColor = .none
            loginButton.setTitleColor(.white, for: .normal)
        } else {
            loginButton.backgroundColor = .clear
            loginButton.layer.borderColor = UIColor.gray4.cgColor
            loginButton.layer.borderWidth = 1.0
            loginButton.setTitleColor(.gray4, for: .normal)
        }
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateLoginButtonState()
    }
    @objc private func loginButtonDidTap() {
        if isValidEmail(idTextField.text) {
            pushToWelcomeVC()
        } else {
            showEmailAlert()
        }
    }
    private func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showEmailAlert() {
        let alert = UIAlertController(title: "이메일 오류", message: "유효한 이메일 형태로 입력해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func createAccountButtonDidTap() {
        let createAccountVC = CreateAccountViewController()
        createAccountVC.modalPresentationStyle = .custom
        createAccountVC.transitioningDelegate = self
        createAccountVC.saveNickName = { [weak self] receivedNickname in
            self?.nickname = receivedNickname
        }
        
        self.present(createAccountVC, animated: true)
    }
    @objc private func findIdButtonDidTap() {
        
    }
    @objc private func findPasswordButtonDidTap() {
        
    }

    private func pushToWelcomeVC() {
        let welcomeViewController = WelcomeViewController()
        
        if let nickname = nickname {
            welcomeViewController.setLabelText(id: nickname)
        } else {
            welcomeViewController.setLabelText(id: idTextField.text)
        }
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray4.cgColor
        textField.layer.borderWidth = 1
        
        if textField == idTextField {
            addToggleIdButton(to: textField)
        }
        if textField == passwordTextField {
            addTogglePasswordButton(to: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.rightView = nil
        textField.rightViewMode = .never
    }
    
    private func addToggleIdButton(to textField: UITextField) {
        let clearButton = UIButton(type: .custom)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.setImage(UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = .gray2
        clearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 20))
        containerView.addSubview(clearButton)
        
        textField.rightView = containerView
        textField.rightViewMode = .always
    }
    
    private func addTogglePasswordButton(to textField: UITextField) {
        let eyeButton = UIButton(type: .custom)
        eyeButton.frame = CGRect(x: 36, y: 0, width: 20, height: 20)
        eyeButton.setImage(UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .selected)
        eyeButton.tintColor = .gray2
        eyeButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        eyeButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
        
        let clearButton = UIButton(type: .custom)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.setImage(UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = .gray2
        clearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 78, height: 20))
        containerView.addSubview(eyeButton)
        containerView.addSubview(clearButton)
        
        textField.rightView = containerView
        textField.rightViewMode = .always
    }
    
    @objc private func passwordVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let containerView = sender.superview,
           let textField = containerView.superview as? UITextField {
            textField.isSecureTextEntry = !sender.isSelected
        }
    }
    @objc private func clearTextField(_ sender: UIButton) {
        if let containerView = sender.superview,
           let textField = containerView.superview as? UITextField {
            textField.text = ""
        }
    }
}


 
//MARK: - UIViewControllerTransitioningDelegate
extension LoginViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return ModalPresentationController(presentedViewController: presented, presenting: presenting)
        }
}
