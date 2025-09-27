//
//  QuestionResultTableViewCell.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

protocol QuestionResultTableViewCellDelegate: AnyObject {
    func didTapExpandButton(for cell: QuestionResultTableViewCell)
    func didUpdateScore(for questionId: Int, score: Int)
}

final class QuestionResultTableViewCell: UITableViewCell {
    static let identifier = "QuestionResultTableViewCell"
    
    weak var delegate: QuestionResultTableViewCellDelegate?
    
    // MARK: UI Properties
    private let containerView: UIView = UIView()
    private let questionLabel: UILabel = UILabel()
    private let studentAnswerLabel: UILabel = UILabel()
    private let scoreLabel: UILabel = UILabel()
    private let expandButton: UIButton = UIButton(type: .system)
    private let scoreStepper: UIStepper = UIStepper()
    private let scoreStackView: UIStackView = UIStackView()
    
    // MARK: Properties
    private var questionResult: QuestionResult?
    private var isExpanded: Bool = false
    private var isTeacherMode: Bool = false
    
    // MARK: Constraints
    private var studentAnswerHeightConstraint: NSLayoutConstraint?
    private var scoreStackHeightConstraint: NSLayoutConstraint?
    
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
    func configure(with result: QuestionResult, isExpanded: Bool = false, isTeacherMode: Bool = false) {
        self.questionResult = result
        self.isExpanded = isExpanded
        self.isTeacherMode = isTeacherMode
        
        questionLabel.text = result.question.prompt
        studentAnswerLabel.text = "Ответ: \(result.studentAnswer)"
        scoreLabel.text = "\(result.score)/\(result.maxScore)"
        
        // Настройка цвета в зависимости от оценки
        scoreLabel.textColor = getScoreColor(for: result.score)
        
        // Настройка stepper для учителя
        if isTeacherMode {
            scoreStepper.value = Double(result.score)
            scoreStepper.maximumValue = Double(result.maxScore)
            scoreStepper.isHidden = false
        } else {
            scoreStepper.isHidden = true
        }
        
        updateExpandedState()
        
        // Принудительно обновляем layout
        layoutIfNeeded()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainerView()
        setupExpandButton() // Создаем кнопку сначала, так как на неё ссылаются другие элементы
        setupQuestionLabel()
        setupStudentAnswerLabel()
        setupScoreStackView()
        setupTapGesture()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .cardBackgroundApp
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.borderApp.cgColor
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pin(to: contentView, 8)
        containerView.pinLeft(to: contentView, 16)
        containerView.pinRight(to: contentView, 16)
    }
    
    private func setupQuestionLabel() {
        questionLabel.setCustomFont(.sansBold, size: 16)
        questionLabel.textColor = .mainTextApp
        questionLabel.numberOfLines = 0
        
        containerView.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.pinTop(to: containerView, 12)
        questionLabel.pinLeft(to: containerView, 16)
        questionLabel.pinRight(to: expandButton.leadingAnchor, -8)
    }
    
    private func setupExpandButton() {
        expandButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        expandButton.tintColor = .secondaryTextApp
        expandButton.isUserInteractionEnabled = false // Отключаем взаимодействие с кнопкой
        
        containerView.addSubview(expandButton)
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.pinTop(to: containerView, 12)
        expandButton.pinRight(to: containerView, 16)
        expandButton.setWidth(24)
        expandButton.setHeight(24)
    }
    
    private func setupStudentAnswerLabel() {
        studentAnswerLabel.setCustomFont(.sansRegular, size: 14)
        studentAnswerLabel.textColor = .secondaryTextApp
        studentAnswerLabel.numberOfLines = 0
        
        containerView.addSubview(studentAnswerLabel)
        studentAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        studentAnswerLabel.pinTop(to: questionLabel.bottomAnchor, 8)
        studentAnswerLabel.pinLeft(to: containerView, 16)
        studentAnswerLabel.pinRight(to: containerView, 16)
        
        // Создаем констрейнт высоты для анимации
        studentAnswerHeightConstraint = studentAnswerLabel.heightAnchor.constraint(equalToConstant: 0)
        studentAnswerHeightConstraint?.isActive = true
    }
    
    
    private func setupScoreStackView() {
        scoreStackView.axis = .horizontal
        scoreStackView.spacing = 8
        scoreStackView.alignment = .center
        
        scoreLabel.setCustomFont(.sansBold, size: 14)
        scoreLabel.textAlignment = .right
        
        scoreStepper.addTarget(self, action: #selector(scoreStepperChanged), for: .valueChanged)
        
        scoreStackView.addArrangedSubview(scoreLabel)
        scoreStackView.addArrangedSubview(scoreStepper)
        
        containerView.addSubview(scoreStackView)
        scoreStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreStackView.pinTop(to: studentAnswerLabel.bottomAnchor, 8)
        scoreStackView.pinLeft(to: containerView, 16)
        scoreStackView.pinRight(to: containerView, 16)
        scoreStackView.pinBottom(to: containerView, 12)
        
        // Создаем констрейнт высоты для анимации
        scoreStackHeightConstraint = scoreStackView.heightAnchor.constraint(equalToConstant: 0)
        scoreStackHeightConstraint?.isActive = true
    }
    
    private func updateExpandedState() {
        // Анимируем изменение высоты элементов
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if self.isExpanded {
                // Разворачиваем - убираем ограничение высоты
                self.studentAnswerHeightConstraint?.isActive = false
                self.scoreStackHeightConstraint?.isActive = false
                
                // Показываем элементы
                self.studentAnswerLabel.isHidden = false
                self.scoreStackView.isHidden = false
            } else {
                // Сворачиваем - устанавливаем высоту в 0
                self.studentAnswerHeightConstraint?.isActive = true
                self.scoreStackHeightConstraint?.isActive = true
                
                // Скрываем элементы
                self.studentAnswerLabel.isHidden = true
                self.scoreStackView.isHidden = true
            }
            
            // Поворачиваем стрелочку
            let rotationAngle: CGFloat = self.isExpanded ? .pi / 2 : 0
            self.expandButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            // Принудительно обновляем layout
            self.layoutIfNeeded()
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
        isExpanded.toggle()
        updateExpandedState()
        delegate?.didTapExpandButton(for: self)
    }
    
    @objc private func scoreStepperChanged() {
        guard let result = questionResult else { return }
        let newScore = Int(scoreStepper.value)
        scoreLabel.text = "\(newScore)/\(result.maxScore)"
        scoreLabel.textColor = getScoreColor(for: newScore)
        delegate?.didUpdateScore(for: result.question.id, score: newScore)
    }
    
    private func getScoreColor(for score: Int) -> UIColor {
        switch score {
        case 0...3:
            return .redAccent      // Красный для оценок 0-3
        case 4...5:
            return .orangeAccent   // Оранжевый для оценок 4-5
        case 6...7:
            return .yellowAccent   // Желтый для оценок 6-7
        case 8...10:
            return .greenAccent    // Зеленый для оценок 8-10
        default:
            return .secondaryTextApp
        }
    }
}
