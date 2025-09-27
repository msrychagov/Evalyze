//
//  AuthenticationViewController.swift
//  Evalyze
//
//  Created by Артём on 20.09.2025.
//

import Foundation
import UIKit

final class AuthenticationViewController: UIViewController {
    // MARK: - VIPER Properties
    var presenter: AuthenticationPresenterProtocol?
    
    // MARK: - Private Properties
    private var loadingIndicator: UIActivityIndicatorView?
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
        label.textColor = .mainTextApp
        label.text = "Система тестирования"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .secondaryTextApp
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
            .foregroundColor: UIColor.secondaryTextApp,
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
        setupViewCallbacks()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Configure Methods
    
    private final func configureUI() {
        view.backgroundColor = .blackApp
        configureContainerView()
        configureTitleLabel()
        configureDescriptionLabel()
        configureAuthenticationSwitch()
        configureLoginView()
        configureRegistrationView()
    }
    
    private final func configureContainerView() {
        view.addSubview(containerView)
        containerView.setHeight(mode: .grOE, 400)
        containerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        containerView.pinHorizontal(to: view.safeAreaLayoutGuide, 20)
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
    
    
    private final func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupViewCallbacks() {
        loginView.onLoginTapped = { [weak self] email, password in
            self?.presenter?.didTapLogin(email: email, password: password)
        }
        
        registrationView.onRegistrationTapped = { [weak self] name, email, password, role, groups in
            self?.presenter?.didTapRegistration(name: name, email: email, password: password, role: role, groups: groups)
        }
        
        registrationView.onGroupSelected = { [weak self] groupName in
            self?.presenter?.didSelectGroup(groupName)
        }
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.color = .white
        
        if let indicator = loadingIndicator {
            view.addSubview(indicator)
            indicator.pinCenter(to: view)
        }
    }
    
    @objc private final func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private final func segmentChanged() {
        presenter?.didTapSegmentedControl(selectedIndex: authenticationSwitch.selectedSegmentIndex)
    }
}

// MARK: - AuthenticationViewProtocol
extension AuthenticationViewController: AuthenticationViewProtocol {
    func showLoading() {
        if loadingIndicator == nil {
            setupLoadingIndicator()
        }
        
        DispatchQueue.main.async {
            self.loadingIndicator?.startAnimating()
            self.authenticationSwitch.isEnabled = false
            self.loginView.isUserInteractionEnabled = false
            self.registrationView.isUserInteractionEnabled = false
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
            self.authenticationSwitch.isEnabled = true
            self.loginView.isUserInteractionEnabled = true
            self.registrationView.isUserInteractionEnabled = true
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showSuccess(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Успех", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func switchToLogin() {
        DispatchQueue.main.async {
            self.authenticationSwitch.selectedSegmentIndex = 0
            self.switchToLoginAnimated()
        }
    }
    
    func switchToRegistration() {
        DispatchQueue.main.async {
            self.authenticationSwitch.selectedSegmentIndex = 1
            self.switchToRegistrationAnimated()
        }
    }
    
    func updateAvailableGroups(_ groups: [Group]) {
        DispatchQueue.main.async {
            self.registrationView.updateAvailableGroups(groups)
        }
    }
    
    // MARK: - Private Animation Methods
    private func switchToLoginAnimated() {
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
    
    private func switchToRegistrationAnimated() {
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
}
