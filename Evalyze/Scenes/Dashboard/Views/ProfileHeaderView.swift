//
//  ProfileView.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

final class ProfileHeaderView: UIView {
    // MARK: UI Properties
    private let stack: UIStackView = UIStackView()
    private let titleLabel: UILabel = UILabel()
    private let nameLabel: UILabel = UILabel()
    private let groupLabel: UILabel = UILabel()
    
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
        configureStack()
    }
    
    private func configureTitleLabel() {
        titleLabel.setCustomFont(.sansBold, size: 18)
        titleLabel.textColor = .mainTextColor
    }
    
    private func configureNameLabel() {
        nameLabel.setCustomFont(.sansBold, size: 24)
        nameLabel.textColor = .mainTextColor
        
    }
    
    private func configureGroupView() {
        groupLabel.setCustomFont(.sansThin, size: 12)
        groupLabel.textColor = .secondaryTextColor
    }
    
    private func configureStack() {
        stack.axis = .vertical
        stack.spacing = 8 // Уменьшил отступы между лейблами
        stack.alignment = .leading
        for label in [titleLabel, nameLabel, groupLabel] {
            stack.addArrangedSubview(label)
        }
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.pin(to: self, 16) // 16pt padding from all sides
        
    }
}
