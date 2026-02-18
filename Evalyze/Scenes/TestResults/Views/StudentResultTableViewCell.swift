//
//  StudentResultTableViewCell.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

final class StudentResultTableViewCell: UITableViewCell {
    static let identifier = "StudentResultTableViewCell"
    
    // MARK: UI Properties
    private let containerView: UIView = UIView()
    private let nameLabel: UILabel = UILabel()
    private let scoreLabel: UILabel = UILabel()
    private let gradeLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
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
    func configure(with studentResult: StudentTestResult) {
        nameLabel.text = studentResult.student.fullName
        scoreLabel.text = "\(studentResult.score)/\(studentResult.maxScore)"
        gradeLabel.text = studentResult.grade
        gradeLabel.textColor = getGradeColor(for: studentResult.score)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateLabel.text = "Завершен: \(formatter.string(from: studentResult.completedAt))"
    }
    
    // MARK: Private Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainerView()
        setupNameLabel()
        setupScoreLabel()
        setupGradeLabel()
        setupDateLabel()
        setupChevronImageView()
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
    
    private func setupNameLabel() {
        nameLabel.setCustomFont(.sansSemiBold, size: 16)
        nameLabel.textColor = .mainTextApp
        nameLabel.numberOfLines = 1
        
        containerView.addSubview(nameLabel)
    }
    
    private func setupScoreLabel() {
        scoreLabel.setCustomFont(.sansBold, size: 18)
        scoreLabel.textColor = .mainTextApp
        scoreLabel.textAlignment = .right
        
        containerView.addSubview(scoreLabel)
    }
    
    private func setupGradeLabel() {
        gradeLabel.setCustomFont(.sansRegular, size: 14)
        gradeLabel.textAlignment = .right
        
        containerView.addSubview(gradeLabel)
    }
    
    private func setupDateLabel() {
        dateLabel.setCustomFont(.sansRegular, size: 12)
        dateLabel.textColor = .secondaryTextApp
        dateLabel.numberOfLines = 1
        
        containerView.addSubview(dateLabel)
    }
    
    private func setupChevronImageView() {
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .secondaryTextApp
        chevronImageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Name label
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: scoreLabel.leadingAnchor, constant: -8),
            
            // Score label
            scoreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            // Grade label
            gradeLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),
            gradeLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            // Date label
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            // Chevron image view
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func getGradeColor(for score: Int) -> UIColor {
        switch score {
        case 8...10:
            return .greenAccent
        case 6...7:
            return .yellowAccent
        case 4...5:
            return .orangeAccent
        default:
            return .redAccent
        }
    }
}
