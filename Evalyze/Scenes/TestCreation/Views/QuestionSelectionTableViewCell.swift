//
//  QuestionSelectionTableViewCell.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import UIKit

protocol QuestionSelectionTableViewCellDelegate: AnyObject {
    func didToggleSelection(for question: Question)
}

final class QuestionSelectionTableViewCell: UITableViewCell {
    static let identifier = "QuestionSelectionTableViewCell"
    
    weak var delegate: QuestionSelectionTableViewCellDelegate?
    
    // MARK: UI Properties
    private let containerView: UIView = UIView()
    private let checkboxButton: UIButton = UIButton(type: .system)
    private let questionLabel: UILabel = UILabel()
    private let questionNumberLabel: UILabel = UILabel()
    
    // MARK: Properties
    private var question: Question?
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func configure(with question: Question, isSelected: Bool) {
        self.question = question
        questionLabel.text = question.prompt
        questionNumberLabel.text = question.title
        updateCheckbox(isSelected: isSelected)
    }
    
    // MARK: Private Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainerView()
        setupCheckboxButton()
        setupQuestionNumberLabel()
        setupQuestionLabel()
        setupConstraints()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .cardBackgroundApp
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        contentView.addSubview(containerView)
    }
    
    private func setupCheckboxButton() {
        checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "checkmark"), for: .selected)
        checkboxButton.layer.cornerRadius = 4
        checkboxButton.layer.borderWidth = 2
        checkboxButton.layer.borderColor = UIColor.blueAccent.cgColor
        checkboxButton.layer.masksToBounds = true // Важно! Чтобы фон не выходил за границы
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        containerView.addSubview(checkboxButton)
    }
    
    private func setupQuestionNumberLabel() {
        questionNumberLabel.setCustomFont(.sansSemiBold, size: 14)
        questionNumberLabel.textColor = .blueAccent
        
        containerView.addSubview(questionNumberLabel)
    }
    
    private func setupQuestionLabel() {
        questionLabel.setCustomFont(.sansRegular, size: 16)
        questionLabel.textColor = .mainTextApp
        questionLabel.numberOfLines = 0
        
        containerView.addSubview(questionLabel)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        questionNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Checkbox button
            checkboxButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Question number label
            questionNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            questionNumberLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            questionNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Question label
            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 4),
            questionLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            questionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateCheckbox(isSelected: Bool) {
        checkboxButton.isSelected = isSelected
        
        if isSelected {
            checkboxButton.backgroundColor = .blueAccent // Синий фон (как у границы)
            checkboxButton.tintColor = .blueAccent // Голубая галочка
        } else {
            checkboxButton.backgroundColor = .clear // Прозрачный фон
            checkboxButton.tintColor = .blueAccent // Синяя обводка квадрата
        }
    }
    
    // MARK: Actions
    @objc private func checkboxTapped() {
        guard let question = question else { return }
        delegate?.didToggleSelection(for: question)
    }
}
