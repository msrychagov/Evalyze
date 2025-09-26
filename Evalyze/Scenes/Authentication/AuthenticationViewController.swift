//
//  AuthenticationViewController.swift
//  Evalyze
//
//  Created by Артём on 20.09.2025.
//

import Foundation
import UIKit

final class AuthenticationViewController: UIViewController {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayApp
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setCustomFont(.sansBold, size: 20)
        label.textAlignment = .center
<<<<<<< HEAD
        label.textColor = .mainTextColor
=======
        label.textColor = .mainTextApp
>>>>>>> dev
        label.text = "Система тестирования"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setCustomFont(.sansRegular, size: 16)
<<<<<<< HEAD
        label.textColor = .secondaryTextColor
=======
        label.textColor = .secondaryTextApp
>>>>>>> dev
        label.numberOfLines = 3
        label.textAlignment = .center
        label.text = "Войдите в систему для доступа к тестированию"
        return label
    }()
    
    private let authenticationSwitch: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Вход", "Регистрация"])
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .lightGrayApp
        segmentedControl.selectedSegmentTintColor = .white
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.blackApp,
            .font: UIFont.custom(.sansRegular, size: 14)
        ], for: .selected)
        
        segmentedControl.setTitleTextAttributes([
<<<<<<< HEAD
            .foregroundColor: UIColor.secondaryTextColor,
=======
            .foregroundColor: UIColor.secondaryTextApp,
>>>>>>> dev
            .font: UIFont.custom(.sansRegular, size: 14)
        ], for: .normal)
        
        return segmentedControl
    }()
    
    private var currentBottomConstraint: NSLayoutConstraint?
    private lazy var loginView = LoginView()
    private lazy var registrationView = RegistrationView()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupKeyboardDismiss()
    }
    
    private final func configureUI() {
        view.backgroundColor = .blackApp
        configureContainerView()
        configureTitleLabel()
        configureDescriptionLabel()
        configureAuthenticationSwitch()
        configureLoginView()
        configureRegistrationView()
        
        if authenticationSwitch.selectedSegmentIndex == 0 {
            switchToLogin()
        } else {
            switchToRegistration()
        }
    }
    
    private final func configureContainerView() {
        view.addSubview(containerView)
        containerView.setHeight(mode: .grOE, 400)
        containerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        containerView.pinHorizontal(to: view.safeAreaLayoutGuide, 20)
    }
    
    private final func configureHeader() {
        configureTitleLabel()
        configureDescriptionLabel()
        configureAuthenticationSwitch()
    }
    
    private final func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.pinHorizontal(to: containerView, 20)
        titleLabel.pinTop(to: containerView.topAnchor, 20)
    }
    
    private final func configureDescriptionLabel() {
        containerView.addSubview(descriptionLabel)
        descriptionLabel.pinHorizontal(to: containerView, 20)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 10)
    }
    
    private final func configureAuthenticationSwitch() {
        containerView.addSubview(authenticationSwitch)
        authenticationSwitch.pinHorizontal(to: containerView, 20)
        authenticationSwitch.pinTop(to: descriptionLabel.bottomAnchor, 20)
        
        authenticationSwitch.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private final func configureLoginView() {
        containerView.addSubview(loginView)
        loginView.pinHorizontal(to: containerView, 20)
        loginView.pinTop(to: authenticationSwitch.bottomAnchor, 20)
    }
    
    private final func configureRegistrationView() {
        containerView.addSubview(registrationView)
        registrationView.pinHorizontal(to: containerView, 20)
        registrationView.pinTop(to: authenticationSwitch.bottomAnchor, 20)
    }
    
    private final func switchToLogin() {
        UIView.animate(withDuration: 0.2, animations: {
                self.registrationView.alpha = 0
                self.registrationView.transform = CGAffineTransform(translationX: -50, y: 0)
            }) { _ in
                self.registrationView.isHidden = true
                self.registrationView.transform = .identity
            }
            
            loginView.alpha = 0
            loginView.transform = CGAffineTransform(translationX: 50, y: 0)
            loginView.isHidden = false
            
            currentBottomConstraint?.isActive = false
            currentBottomConstraint = loginView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            currentBottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: []) {
                self.loginView.alpha = 1
                self.loginView.transform = .identity
                self.view.layoutIfNeeded()
            }
    }
    
    private final func switchToRegistration() {
        UIView.animate(withDuration: 0.2, animations: {
                self.loginView.alpha = 0
                self.loginView.transform = CGAffineTransform(translationX: 50, y: 0)
            }) { _ in
                self.loginView.isHidden = true
                self.loginView.transform = .identity
            }
            
            registrationView.alpha = 0
            registrationView.transform = CGAffineTransform(translationX: -50, y: 0)
            registrationView.isHidden = false
            
            currentBottomConstraint?.isActive = false
            currentBottomConstraint = registrationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            currentBottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: []) {
                self.registrationView.alpha = 1
                self.registrationView.transform = .identity
                self.view.layoutIfNeeded()
            }
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private final func segmentChanged() {
    if authenticationSwitch.selectedSegmentIndex == 0 {
        switchToLogin()
    } else {
        switchToRegistration()
    }
}
}
