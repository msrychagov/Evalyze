//
//  TestFinishViewController.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

final class TestFinishViewController: UIViewController {
    private let result: TestResult

    init(result: TestResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Результат теста"
        l.font = UIFont.custom(.sansBold, size: 22)
        l.textColor = .mainTextApp
        return l
    }()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        return v
    }()
    
    private let scoreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.custom(.sansBold, size: 24)
        l.textColor = .blueAccent
        l.textAlignment = .center
        return l
    }()
    
    private let feedbackLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.custom(.sansRegular, size: 16)
        l.textColor = .mainTextApp
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    private let answersTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.custom(.sansRegular, size: 15)
        tv.textColor = .mainTextApp
        tv.backgroundColor = .lightGrayApp
        tv.layer.cornerRadius = 10
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return tv
    }()
    
    private let backToMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться в главное меню", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        // Добавим тень для лучшей видимости
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        button.addTarget(self, action: #selector(backToMenuButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayResults()
    }
    
    private func setupUI() {
        view.backgroundColor = .blackApp
        
        view.addSubview(scrollView)
        view.addSubview(backToMenuButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(feedbackLabel)
        contentView.addSubview(answersTextView)

        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        // Constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        backToMenuButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        answersTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backToMenuButton.topAnchor, constant: -20),
            
            // Back to menu button
            backToMenuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backToMenuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backToMenuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backToMenuButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Score label
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Feedback label
            feedbackLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            feedbackLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            feedbackLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Answers text view
            answersTextView.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 20),
            answersTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            answersTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            answersTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            answersTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    private func displayResults() {
        // Отображаем общую оценку
        if let overallScore = result.overallScore {
            scoreLabel.text = "Оценка: \(String(format: "%.1f", overallScore))/10"
        } else {
            scoreLabel.text = "Тест завершен"
        }
        
        // Отображаем обратную связь
        if let feedback = result.feedback {
            feedbackLabel.text = feedback
        } else {
            feedbackLabel.text = "Спасибо за прохождение теста!"
        }
        
        // Отображаем ответы с оценками
        var lines = [String]()
        
        if let questionScores = result.questionScores {
            // Если есть оценки от DeepSeek, показываем их
            for questionScore in questionScores.sorted(by: { $0.questionId < $1.questionId }) {
                let answer = result.answers[questionScore.questionId] ?? "(не дан ответ)"
                lines.append("Вопрос \(questionScore.questionId) - \(String(format: "%.1f", questionScore.score))/10")
                lines.append("Ответ: \(answer)")
                if !questionScore.feedback.isEmpty {
                    lines.append("Комментарий: \(questionScore.feedback)")
                }
                lines.append("")
            }
        } else {
            // Fallback - показываем только ответы
            for (id, answer) in result.answers.sorted(by: { $0.key < $1.key }) {
                lines.append("Вопрос \(id):\n\(answer.isEmpty ? "(не дан ответ)" : answer)")
            }
        }
        
        answersTextView.text = lines.joined(separator: "\n")
    }
    
    @objc private func backToMenuButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
