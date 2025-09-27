//
//  ProfileViewController.swift
//  Evalyze
//
//  Created by Артём on 27.09.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayApp
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setCustomFont(.sansBold, size: 24)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Профиль"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avatarImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.setCustomFont(.sansBold, size: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "👤"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        label.pinCenterX(to: view)
        label.pinCenterY(to: view)
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setCustomFont(.sansBold, size: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Загрузка..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.setCustomFont(.sansRegular, size: 16)
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.text = "Загрузка..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.custom(.sansBold, size: 18)
        button.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var loadingIndicator: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .blackApp
        configureScrollView()
        configureContainerView()
        configureTitleLabel()
        configureAvatarImageView()
        configureNameLabel()
        configureEmailLabel()
        configureLogoutButton()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pin(to: view.safeAreaLayoutGuide)
        contentView.pin(to: scrollView)
        contentView.pinWidth(to: scrollView)
    }
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.pinTop(to: contentView.topAnchor, 20)
        containerView.pinHorizontal(to: contentView, 20)
        containerView.pinBottom(to: contentView.bottomAnchor, 20)
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.pinTop(to: containerView.topAnchor, 24)
        titleLabel.pinHorizontal(to: containerView, 20)
    }
    
    private func configureAvatarImageView() {
        containerView.addSubview(avatarImageView)
        avatarImageView.pinTop(to: titleLabel.bottomAnchor, 32)
        avatarImageView.pinCenterX(to: containerView)
        avatarImageView.setWidth(80)
        avatarImageView.setHeight(80)
    }
    
    private func configureNameLabel() {
        containerView.addSubview(nameLabel)
        nameLabel.pinTop(to: avatarImageView.bottomAnchor, 20)
        nameLabel.pinHorizontal(to: containerView, 20)
    }
    
    private func configureEmailLabel() {
        containerView.addSubview(emailLabel)
        emailLabel.pinTop(to: nameLabel.bottomAnchor, 8)
        emailLabel.pinHorizontal(to: containerView, 20)
    }
    
    private func configureLogoutButton() {
        containerView.addSubview(logoutButton)
        logoutButton.pinTop(to: emailLabel.bottomAnchor, 40)
        logoutButton.pinHorizontal(to: containerView, 20)
        logoutButton.setHeight(50)
        logoutButton.pinBottom(to: containerView.bottomAnchor, 24)
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // Добавляем анимации для кнопки
        logoutButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        logoutButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        presenter?.didTapLogout()
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.08, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.logoutButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.logoutButton.alpha = 0.9
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.logoutButton.transform = .identity
            self.logoutButton.alpha = 1.0
        }
    }
}

// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func displayUserInfo(name: String, email: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = name
            self.emailLabel.text = email
            
            // Устанавливаем первую букву имени как аватар
            if let firstLetter = name.first {
                if let avatarLabel = self.avatarImageView.subviews.first as? UILabel {
                    avatarLabel.text = String(firstLetter).uppercased()
                }
            }
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            if self.loadingIndicator == nil {
                self.loadingIndicator = UIActivityIndicatorView(style: .large)
                self.loadingIndicator?.color = .white
                self.loadingIndicator?.translatesAutoresizingMaskIntoConstraints = false
                
                self.view.addSubview(self.loadingIndicator!)
                self.loadingIndicator?.pinCenterX(to: self.view)
                self.loadingIndicator?.pinCenterY(to: self.view)
            }
            
            self.loadingIndicator?.startAnimating()
            self.containerView.alpha = 0.5
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
            self.loadingIndicator?.removeFromSuperview()
            self.loadingIndicator = nil
            self.containerView.alpha = 1.0
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showLogoutConfirmation() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Выход из аккаунта",
                message: "Вы уверены, что хотите выйти из аккаунта?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { [weak self] _ in
                self?.presenter?.didCancelLogout()
            })
            
            alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                self?.presenter?.didConfirmLogout()
            })
            
            self.present(alert, animated: true)
        }
    }
}
