//
//  LoginView.swift
//  Evalyze
//
//  Created by Артём on 22.09.2025.
//

import UIKit

final class LoginView: UIView {
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextApp
        label.textAlignment = .left
        return label
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGrayApp
        field.layer.cornerRadius = 10
        field.textColor = .mainTextApp
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .none
        
        field.keyboardType = .emailAddress
        field.textContentType = .emailAddress
        field.returnKeyType = .next
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "example@email.com",
            attributes: [.foregroundColor: UIColor.secondaryTextApp]
        )
        return field
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextApp
        label.textAlignment = .left
        return label
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGrayApp
        field.layer.cornerRadius = 10
        field.textColor = .mainTextApp
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .none
        
        field.isSecureTextEntry = true
        field.textContentType = .password
        field.returnKeyType = .done
        field.keyboardType = .asciiCapable
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [.foregroundColor: UIColor.secondaryTextApp]
        )
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.grayApp, for: .normal)
        button.titleLabel?.font = UIFont.custom(.sansBold, size: 18)
        button.layer.cornerRadius = 10
        button.backgroundColor = .mainTextApp
        return button
    }()
    
    var onLoginTapped: ((String, String) -> Void)?
    var onEmailChanged: ((String) -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private final func configureUI() {
        self.isUserInteractionEnabled = true
        configureEmailLabel()
        configureEmailField()
        configurePasswordLabel()
        configurePasswordField()
        configureLoginButton()
    }
    
    private final func configureEmailLabel() {
        self.addSubview(emailLabel)
        
        emailLabel.pinTop(to: self)
        emailLabel.pinLeft(to: self.leadingAnchor, 5)
    }
    
    private final func configureEmailField() {
        self.addSubview(emailField)
        
        emailField.pinTop(to: emailLabel.bottomAnchor, 5)
        emailField.pinHorizontal(to: self)
        emailField.setHeight(40)
        
        emailField.delegate = self
    }
    
    private final func configurePasswordLabel() {
        self.addSubview(passwordLabel)
        
        passwordLabel.pinTop(to: emailField.bottomAnchor, 15)
        passwordLabel.pinLeft(to: self.leadingAnchor, 5)
    }
    
    private final func configurePasswordField() {
        self.addSubview(passwordField)
        
        passwordField.pinTop(to: passwordLabel.bottomAnchor, 5)
        passwordField.pinHorizontal(to: self)
        passwordField.setHeight(40)
        
        passwordField.delegate = self
    }
    
    private final func configureLoginButton() {
        self.addSubview(loginButton)
        
        loginButton.pinTop(to: passwordField.bottomAnchor, 40)
        loginButton.pinHorizontal(to: self)
        loginButton.setHeight(50)
        loginButton.pinBottom(to: self, 20)
        
        loginButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.08, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.loginButton.alpha = 0.9
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.loginButton.transform = .identity
            self.loginButton.alpha = 1.0
        }
    }
    
    @objc final func loginButtonTapped() {
    let email = emailField.text ?? ""
    let password = passwordField.text ?? ""
    onLoginTapped?(email, password)
    print("log in")
}
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return false
    }
}
