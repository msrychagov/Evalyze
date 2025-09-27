//
//  ProfileView.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func didTapLogoutButton()
}

final class ProfileHeaderView: UIView {
    // MARK: UI Properties
    private let stack: UIStackView = UIStackView()
    private let titleLabel: UILabel = UILabel()
    private let nameLabel: UILabel = UILabel()
    private let groupLabel: UILabel = UILabel()
    private let logoutButton: UIButton = UIButton(type: .system)
    
    // MARK: Delegate
    weak var delegate: ProfileHeaderViewDelegate?
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func configure(viewModel: DashboardModels.UserInfo.ViewModel) {
        titleLabel.text = viewModel.title
        nameLabel.text = viewModel.name
        groupLabel.text = viewModel.group
    }
    
    // MARK: Configure UI
    private func configureUI() {
        backgroundColor = .grayApp
        layer.cornerRadius = 10
        configureTitleLabel()
        configureNameLabel()
        configureGroupView()
        configureLogoutButton()
        configureStack()
    }
    
    private func configureTitleLabel() {
        titleLabel.setCustomFont(.sansBold, size: 18)
        titleLabel.textColor = .mainTextApp
    }
    
    private func configureNameLabel() {
        nameLabel.setCustomFont(.sansBold, size: 24)
        nameLabel.textColor = .mainTextApp
        
    }
    
    private func configureGroupView() {
        groupLabel.setCustomFont(.sansRegular, size: 12)
        groupLabel.textColor = .secondaryTextApp
    }
    
    private func configureLogoutButton() {
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.titleLabel?.setCustomFont(.sansRegular, size: 14)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonTapped() {
        delegate?.didTapLogoutButton()
    }
    
    private func configureStack() {
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        for label in [titleLabel, nameLabel, groupLabel] {
            stack.addArrangedSubview(label)
        }
        
        addSubview(stack)
        addSubview(logoutButton)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack constraints
        stack.pinTop(to: self, 16)
        stack.pinBottom(to: self, 16)
        stack.pinLeft(to: self, 16)
        
        // Logout button constraints  
        logoutButton.pinTop(to: self, 16)
        logoutButton.pinRight(to: self, 16)
        
        // Constraint between stack and button
        stack.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -16).isActive = true
    }
}
