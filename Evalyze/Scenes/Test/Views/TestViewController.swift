//
//  TestViewController.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

final class TestViewController: UIViewController, TestViewProtocol, UITextViewDelegate {
    var presenter: TestPresenterProtocol?

    // Верхняя панель
    private let topBar = UIStackView()
    private let progressLabel = UILabel()
    private let questionSelectorScroll = UIScrollView()
    private let questionSelectorStack = UIStackView()

    // Контент
    private let questionTitleLabel = UILabel()
    private let promptLabel = UILabel()
    private let answerTextView = NonSelectableTextView()

    // Кнопки
    private let prevButton = UIButton()
    private let nextButton = UIButton()
    private let finishButton = UIButton()

    // Exam protection
    private var protection: ExamProtectionManager?
    private var didForceFinish = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackApp
        setupUI()

        // Скрываем клавиатуру по свайпу вниз
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)

        protection = ExamProtectionManager(targetView: view, onScreenshot: { [weak self] in
            self?.handleScreenshotDetected()
        })

        navigationItem.title = "Тест"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.custom(.sansBold, size: 20)
        ]
        navigationItem.hidesBackButton = true

        let config = UIImage.SymbolConfiguration(weight: .bold)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: config)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(customBackTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .systemBlue

        presenter?.startTest()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func customBackTapped() {
        let alert = UIAlertController(
            title: "Выйти из теста?",
            message: "Ваши ответы не будут сохранены.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    private func setupUI() {
        // progress label
        progressLabel.font = UIFont.custom(.sansRegular, size: 14)
        progressLabel.textColor = .secondaryTextApp
        progressLabel.textAlignment = .left

        // selector
        questionSelectorStack.axis = .horizontal
        questionSelectorStack.spacing = 8
        questionSelectorStack.alignment = .center
        questionSelectorScroll.showsHorizontalScrollIndicator = false

        questionSelectorScroll.addSubview(questionSelectorStack)
        questionSelectorStack.pin(to: questionSelectorScroll)
        questionSelectorStack.pinHeight(to: questionSelectorScroll.heightAnchor)

        topBar.axis = .vertical
        topBar.spacing = 8
        topBar.addArrangedSubview(progressLabel)
        topBar.addArrangedSubview(questionSelectorScroll)

        // labels
        questionTitleLabel.font = UIFont.custom(.sansBold, size: 18)
        questionTitleLabel.textColor = .mainTextApp
        questionTitleLabel.numberOfLines = 0

        promptLabel.font = UIFont.custom(.sansRegular, size: 16)
        promptLabel.textColor = .secondaryTextApp
        promptLabel.numberOfLines = 0

        // answer
        answerTextView.font = UIFont.custom(.sansRegular, size: 16)
        answerTextView.backgroundColor = .lightGrayApp
        answerTextView.textColor = .mainTextApp
        answerTextView.layer.cornerRadius = 10
        answerTextView.delegate = self
        answerTextView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        answerTextView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        // buttons
        prevButton.applyPrimaryStyle(title: "◀︎ Пред.")
        nextButton.applyPrimaryStyle(title: "След. ▶︎")
        finishButton.applyPrimaryStyle(title: "Завершить")

        prevButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)

        let navStack = UIStackView(arrangedSubviews: [prevButton, nextButton])
        navStack.axis = .horizontal
        navStack.distribution = .fillEqually
        navStack.spacing = 12

        let mainStack = UIStackView(arrangedSubviews: [
            topBar,
            questionTitleLabel,
            promptLabel,
            answerTextView,
            navStack,
            finishButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        view.addSubview(mainStack)

        mainStack.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        mainStack.pinLeft(to: view, 16)
        mainStack.pinRight(to: view, 16)
        mainStack.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16, .lsOE)

        questionSelectorScroll.setHeight(40)
        finishButton.setHeight(50)
    }

    // MARK: - Screenshot handling
    private func handleScreenshotDetected() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.didForceFinish { return }
            self.didForceFinish = true
            if let presented = self.presentedViewController {
                presented.dismiss(animated: false, completion: nil)
            }
            // Принудительное завершение теста при скриншоте
            self.presenter?.forceFinish()
        }
    }

    // MARK: - TestViewProtocol
    func showIntro(with info: String) {}

    func showQuestions(_ questions: [Question]) {
        questionSelectorStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<questions.count {
            let btn = UIButton(type: .system)
            btn.setTitle("\(i+1)", for: .normal)
            btn.titleLabel?.font = UIFont.custom(.sansRegular, size: 14)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .lightGrayApp
            btn.layer.cornerRadius = 6
            btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
            btn.tag = i
            btn.addTarget(self, action: #selector(questionTapped(_:)), for: .touchUpInside)
            questionSelectorStack.addArrangedSubview(btn)
        }
    }

    func showQuestion(_ question: Question, index: Int, total: Int) {
        progressLabel.text = "\(index)/\(total)"
        questionTitleLabel.text = "\(index). \(question.title)"
        promptLabel.text = question.prompt
        answerTextView.text = question.answer ?? ""

        for case let btn as UIButton in questionSelectorStack.arrangedSubviews {
            if btn.tag == index - 1 {
                btn.backgroundColor = .mainTextApp
                btn.setTitleColor(.blackApp, for: .normal)
            } else {
                btn.backgroundColor = .lightGrayApp
                btn.setTitleColor(.white, for: .normal)
            }
        }

        if let activeButton = questionSelectorStack.arrangedSubviews[index - 1] as? UIButton {
            questionSelectorScroll.scrollRectToVisible(activeButton.frame.insetBy(dx: -8, dy: 0), animated: true)
        }
    }

    func updateNavigation(canGoPrev: Bool, canGoNext: Bool) {
        prevButton.isEnabled = canGoPrev
        nextButton.isEnabled = canGoNext
        prevButton.alpha = canGoPrev ? 1.0 : 0.5
        nextButton.alpha = canGoNext ? 1.0 : 0.5
    }

    func showSubmitting() {
        let hud = UIActivityIndicatorView(style: .large)
        hud.center = view.center
        hud.startAnimating()
        hud.tag = 999
        view.addSubview(hud)
    }

    func showSubmitSuccess() {
        (view.viewWithTag(999) as? UIActivityIndicatorView)?.removeFromSuperview()
    }

    // MARK: - Actions
    @objc private func prevTapped() { presenter?.prevTapped() }
    @objc private func nextTapped() { presenter?.nextTapped() }
    @objc private func finishTapped() { presenter?.finishTapped() }
    @objc private func questionTapped(_ sender: UIButton) { presenter?.goToQuestion(index: sender.tag) }

    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        presenter?.answerChanged(textView.text)
    }
}
