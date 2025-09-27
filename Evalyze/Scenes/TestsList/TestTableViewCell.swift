//
//  TestTableViewCell.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

final class TestTableViewCell: UITableViewCell {
    static let identifier = "TestTableViewCell"
    
    // MARK: UI Properties
    private let containerView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let statusLabel: UILabel = UILabel()
    private let timeLabel: UILabel = UILabel()
    private let scoreLabel: UILabel = UILabel()
    private let chevronImageView: UIImageView = UIImageView()
    
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
    func configure(with test: Test) {
        titleLabel.text = test.title
        descriptionLabel.text = test.description
        
        switch test.status {
        case .upcoming:
            statusLabel.text = "Предстоящий"
            statusLabel.textColor = .blueAccent
            scoreLabel.isHidden = true
            
            if let dueDate = test.dueDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy HH:mm"
                timeLabel.text = "До: \(formatter.string(from: dueDate))"
            } else {
                timeLabel.text = "Без ограничений по времени"
            }
            timeLabel.textColor = .secondaryTextApp
            
        case .completed:
            statusLabel.text = "Завершен"
            
            if let score = test.score {
                scoreLabel.text = "\(score)/\(test.maxScore)"
                scoreLabel.textColor = getScoreColor(for: score)
                scoreLabel.isHidden = false
                
                // Цвет статуса зависит от оценки
                statusLabel.textColor = getScoreColor(for: score)
            } else {
                scoreLabel.isHidden = true
                statusLabel.textColor = .greenAccent // По умолчанию зеленый
            }
            
            if let completedAt = test.completedAt {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                timeLabel.text = "Завершен: \(formatter.string(from: completedAt))"
            } else {
                timeLabel.text = "Завершен"
            }
            timeLabel.textColor = .secondaryTextApp
        }
        
        let durationMinutes = Int(test.duration / 60)
        let durationText = "\(durationMinutes) мин"
        
        // Add duration info to time label
        if test.status == .upcoming {
            timeLabel.text = "\(timeLabel.text ?? "") • \(durationText)"
        }
    }
    
    // MARK: Private Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainerView()
        setupChevronImageView() // Setup chevron first since other views reference it
        setupTitleLabel()
        setupDescriptionLabel()
        setupStatusLabel()
        setupTimeLabel()
        setupScoreLabel()
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
    
    private func setupTitleLabel() {
        titleLabel.setCustomFont(.sansBold, size: 16)
        titleLabel.textColor = .mainTextApp
        titleLabel.numberOfLines = 1
        
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.pinTop(to: containerView, 12)
        titleLabel.pinLeft(to: containerView, 16)
        titleLabel.pinRight(to: chevronImageView.leadingAnchor, -8)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.setCustomFont(.sansRegular, size: 14)
        descriptionLabel.textColor = .secondaryTextApp
        descriptionLabel.numberOfLines = 2
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 4)
        descriptionLabel.pinLeft(to: containerView, 16)
        descriptionLabel.pinRight(to: chevronImageView.leadingAnchor, 8)
    }
    
    private func setupStatusLabel() {
        statusLabel.setCustomFont(.sansSemiBold, size: 12)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true
        statusLabel.backgroundColor = UIColor.blueAccent.withAlphaComponent(0.1)
        
        containerView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.pinBottom(to: containerView, 12)
        statusLabel.pinLeft(to: containerView, 16)
        statusLabel.setWidth(100)
        statusLabel.setHeight(20)
        
        // Добавляем минимальный отступ от описания
        statusLabel.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 12).isActive = true
    }
    
    private func setupTimeLabel() {
        timeLabel.setCustomFont(.sansRegular, size: 12)
        timeLabel.textColor = .secondaryTextApp
        
        containerView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.pinBottom(to: containerView, 12) // Привязываем к низу контейнера для консистентности
        timeLabel.pinLeft(to: statusLabel.trailingAnchor, 8)
        timeLabel.pinRight(to: chevronImageView.leadingAnchor, -8)
        timeLabel.setHeight(20)
    }
    
    private func setupScoreLabel() {
        scoreLabel.setCustomFont(.sansBold, size: 14)
        scoreLabel.textColor = .greenAccent
        scoreLabel.textAlignment = .right
        scoreLabel.isHidden = true
        
        containerView.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.pinBottom(to: containerView, 12) // Привязываем к низу контейнера для консистентности
        scoreLabel.pinRight(to: chevronImageView.leadingAnchor, -8)
        scoreLabel.setHeight(20)
    }
    
    private func setupChevronImageView() {
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .secondaryTextApp
        chevronImageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(chevronImageView)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.pinCenterY(to: containerView)
        chevronImageView.pinRight(to: containerView, 16)
        chevronImageView.setWidth(12)
        chevronImageView.setHeight(12)
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
