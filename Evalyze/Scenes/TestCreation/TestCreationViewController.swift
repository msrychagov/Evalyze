//
//  TestCreationViewController.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import UIKit

final class TestCreationViewController: UIViewController, TestCreationViewProtocol {
    var presenter: TestCreationPresenterProtocol?
    
    // MARK: UI Properties
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let titleTextField: UITextField = UITextField()
    private let descriptionTextView: UITextView = UITextView()
    private let groupButton: UIButton = UIButton(type: .system)
    private let questionsButton: UIButton = UIButton(type: .system)
    private let durationLabel: UILabel = UILabel()
    private let durationSlider: UISlider = UISlider()
    private let dueDateLabel: UILabel = UILabel()
    private let dueDatePicker: UIDatePicker = UIDatePicker()
    private let createButton: UIButton = UIButton(type: .system)
    private let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: Properties
    private var testModel = TestCreationModel()
    private var selectedQuestions: [Question] = []
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: TestCreationViewProtocol
    func showGroups(_ groups: [String]) {
        // Groups will be shown in dropdown
    }
    
    func showQuestions(_ questions: [Question]) {
        // Questions will be shown in selection screen
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Успех", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.presenter?.router?.dismissToDashboard(from: self)
        })
        present(alert, animated: true)
    }
    
    func showLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
        createButton.isEnabled = false
    }
    
    func hideLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
        createButton.isEnabled = true
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .blackApp
        setupNavigationBar()
        setupScrollView()
        setupTitleField()
        setupDescriptionView()
        setupGroupButton()
        setupQuestionsButton()
        setupDurationControls()
        setupDueDateControls()
        setupCreateButton()
        setupLoadingView()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        title = "Создание теста"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
    }
    
    private func setupTitleField() {
        titleTextField.placeholder = "Название теста"
        titleTextField.backgroundColor = .cardBackgroundApp
        titleTextField.textColor = .mainTextApp
        titleTextField.font = UIFont.systemFont(ofSize: 16)
        titleTextField.layer.cornerRadius = 8
        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        titleTextField.leftViewMode = .always
        titleTextField.addTarget(self, action: #selector(titleChanged), for: .editingChanged)
        
        contentView.addSubview(titleTextField)
    }
    
    private func setupDescriptionView() {
        descriptionTextView.backgroundColor = .cardBackgroundApp
        descriptionTextView.textColor = .mainTextApp
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        descriptionTextView.delegate = self
        descriptionTextView.text = "Описание теста"
        descriptionTextView.textColor = .secondaryTextApp
        
        contentView.addSubview(descriptionTextView)
    }
    
    private func setupGroupButton() {
        groupButton.setTitle("Выберите группу", for: .normal)
        groupButton.setTitleColor(.mainTextApp, for: .normal)
        groupButton.backgroundColor = .cardBackgroundApp
        groupButton.layer.cornerRadius = 8
        groupButton.contentHorizontalAlignment = .left
        groupButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        groupButton.addTarget(self, action: #selector(groupButtonTapped), for: .touchUpInside)
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        chevronImageView.tintColor = .secondaryTextApp
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        groupButton.addSubview(chevronImageView)
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: groupButton.trailingAnchor, constant: -12),
            chevronImageView.centerYAnchor.constraint(equalTo: groupButton.centerYAnchor)
        ])
        
        contentView.addSubview(groupButton)
    }
    
    private func setupQuestionsButton() {
        questionsButton.setTitle("Выберите вопросы (0)", for: .normal)
        questionsButton.setTitleColor(.mainTextApp, for: .normal)
        questionsButton.backgroundColor = .cardBackgroundApp
        questionsButton.layer.cornerRadius = 8
        questionsButton.contentHorizontalAlignment = .left
        questionsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        questionsButton.addTarget(self, action: #selector(questionsButtonTapped), for: .touchUpInside)
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .secondaryTextApp
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        questionsButton.addSubview(chevronImageView)
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: questionsButton.trailingAnchor, constant: -12),
            chevronImageView.centerYAnchor.constraint(equalTo: questionsButton.centerYAnchor)
        ])
        
        contentView.addSubview(questionsButton)
    }
    
    private func setupDurationControls() {
        durationLabel.text = "Длительность: 60 минут"
        durationLabel.setCustomFont(.sansRegular, size: 16)
        durationLabel.textColor = .mainTextApp
        
        durationSlider.minimumValue = 15
        durationSlider.maximumValue = 180
        durationSlider.value = 60
        durationSlider.addTarget(self, action: #selector(durationChanged), for: .valueChanged)
        
        contentView.addSubview(durationLabel)
        contentView.addSubview(durationSlider)
    }
    
    private func setupDueDateControls() {
        dueDateLabel.text = "Начало"
        dueDateLabel.setCustomFont(.sansRegular, size: 16)
        dueDateLabel.textColor = .mainTextApp
        
        dueDatePicker.datePickerMode = .dateAndTime
        dueDatePicker.minimumDate = Date()
        dueDatePicker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
        
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(dueDatePicker)
    }
    
    private func setupCreateButton() {
        createButton.setTitle("Создать тест", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = .blueAccent
        createButton.layer.cornerRadius = 12
        createButton.titleLabel?.setCustomFont(.sansSemiBold, size: 18)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(createButton)
    }
    
    private func setupLoadingView() {
        loadingView.color = .mainTextApp
        loadingView.hidesWhenStopped = true
        
        view.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        groupButton.translatesAutoresizingMaskIntoConstraints = false
        questionsButton.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationSlider.translatesAutoresizingMaskIntoConstraints = false
        dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
        dueDatePicker.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title field
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Description view
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Group button
            groupButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            groupButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            groupButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            groupButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Questions button
            questionsButton.topAnchor.constraint(equalTo: groupButton.bottomAnchor, constant: 16),
            questionsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            questionsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Duration label
            durationLabel.topAnchor.constraint(equalTo: questionsButton.bottomAnchor, constant: 24),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Duration slider
            durationSlider.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 8),
            durationSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            durationSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Due date label
            dueDateLabel.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 24),
            dueDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dueDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Due date picker
            dueDatePicker.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 8),
            dueDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dueDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Create button
            createButton.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 32),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            // Loading view
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func titleChanged() {
        testModel.title = titleTextField.text ?? ""
        presenter?.didUpdateTitle(testModel.title)
    }
    
    @objc private func groupButtonTapped() {
        let alert = UIAlertController(title: "Выберите группу", message: nil, preferredStyle: .actionSheet)
        
        for group in TestCreationModel.mockGroups {
            alert.addAction(UIAlertAction(title: group, style: .default) { _ in
                self.testModel.selectedGroup = group
                self.groupButton.setTitle(group, for: .normal)
                self.presenter?.didSelectGroup(group)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func questionsButtonTapped() {
        presenter?.didTapSelectQuestions()
    }
    
    @objc private func durationChanged() {
        let minutes = Int(durationSlider.value)
        testModel.duration = TimeInterval(minutes * 60)
        durationLabel.text = "Длительность: \(minutes) минут"
        presenter?.didUpdateDuration(testModel.duration)
    }
    
    @objc private func dueDateChanged() {
        testModel.startDate = dueDatePicker.date
        presenter?.didUpdateDueDate(testModel.startDate)
    }
    
    @objc private func createButtonTapped() {
        if testModel.isValid {
            presenter?.didTapCreateTest()
        } else {
            showError("Заполните все обязательные поля")
        }
    }
}

// MARK: - UITextViewDelegate
extension TestCreationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryTextApp {
            textView.text = ""
            textView.textColor = .mainTextApp
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Описание теста"
            textView.textColor = .secondaryTextApp
        } else {
            testModel.description = textView.text
            presenter?.didUpdateDescription(testModel.description)
        }
    }
    
    func updateQuestionsButton() {
        let count = testModel.selectedQuestions.count
        questionsButton.setTitle("Выберите вопросы (\(count))", for: .normal)
    }
}
