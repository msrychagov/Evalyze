//
//  TestIntroViewController.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

final class TestIntroViewController: UIViewController, TestViewProtocol {
    var presenter: TestPresenterProtocol?

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.custom(.sansBold, size: 24)
        l.textColor = .mainTextColor
        l.textAlignment = .center
        l.text = "Готовы начать тест?"
        return l
    }()

    private let infoLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.custom(.sansRegular, size: 16)
        l.textColor = .secondaryTextColor
        l.numberOfLines = 0
        return l
    }()

    private let startButton: UIButton = {
        let b = UIButton()
        b.applyPrimaryStyle(title: "Начать тест")
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackApp
        setupLayout()
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        presenter?.viewDidLoad() // загружаем вступительный текст
    }

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, infoLabel, startButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)

        stack.pinCenterY(to: view)
        stack.pinLeft(to: view, 16)
        stack.pinRight(to: view, 16)

        startButton.setHeight(50)
    }

    // MARK: - TestViewProtocol
    func showIntro(with info: String) { infoLabel.text = info }
    func showQuestions(_ questions: [Question]) {}
    func showQuestion(_ question: Question, index: Int, total: Int) {}
    func updateNavigation(canGoPrev: Bool, canGoNext: Bool) {}
    func showSubmitting() {}
    func showSubmitSuccess() {}

    @objc private func startTapped() {
        if let p = presenter as? TestPresenter, let router = p.router as? TestRouter {
            router.presentTest(from: self)
        }
    }
}
