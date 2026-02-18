//
//  QuestionSelectionViewController.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import UIKit

final class QuestionSelectionViewController: UIViewController {
    // MARK: UI Properties
    private let tableView: UITableView = UITableView()
    private let doneButton: UIButton = UIButton(type: .system)
    private let selectAllButton: UIButton = UIButton(type: .system)
    
    // MARK: Properties
    private var questions: [Question] = []
    private var selectedQuestions: Set<Int> = []
    private var completion: (([Question]) -> Void)?
    
    // MARK: Initialization
    init(questions: [Question], selectedQuestions: [Question], completion: @escaping ([Question]) -> Void) {
        self.questions = questions
        self.selectedQuestions = Set(selectedQuestions.map { $0.intId })
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .blackApp
        setupNavigationBar()
        setupTableView()
        setupButtons()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        title = "Выбор вопросов"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.leftBarButtonItem = nil
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(QuestionSelectionTableViewCell.self, forCellReuseIdentifier: QuestionSelectionTableViewCell.identifier)
        
        // Настройка автоматической высоты ячеек
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        view.addSubview(tableView)
    }
    
    private func setupButtons() {
        // Select All button
        selectAllButton.setTitle("Выбрать все", for: .normal)
        selectAllButton.setTitleColor(.blueAccent, for: .normal)
        selectAllButton.titleLabel?.setCustomFont(.sansRegular, size: 16)
        selectAllButton.addTarget(self, action: #selector(selectAllButtonTapped), for: .touchUpInside)
        
        // Done button
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .blueAccent
        doneButton.layer.cornerRadius = 12
        doneButton.titleLabel?.setCustomFont(.sansSemiBold, size: 18)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        view.addSubview(selectAllButton)
        view.addSubview(doneButton)
        
        updateButtons()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        selectAllButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Table view
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: selectAllButton.topAnchor, constant: -16),
            
            // Select all button
            selectAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectAllButton.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -8),
            
            // Done button
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateButtons() {
        let selectedCount = selectedQuestions.count
        let totalCount = questions.count
        
        selectAllButton.setTitle(selectedCount == totalCount ? "Снять все" : "Выбрать все", for: .normal)
        doneButton.setTitle("Готово (\(selectedCount))", for: .normal)
        doneButton.isEnabled = selectedCount > 0
        doneButton.alpha = selectedCount > 0 ? 1.0 : 0.5
    }
    
    // MARK: Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func selectAllButtonTapped() {
        if selectedQuestions.count == questions.count {
            // Deselect all
            selectedQuestions.removeAll()
        } else {
            // Select all
            selectedQuestions = Set(questions.map { $0.intId })
        }
        tableView.reloadData()
        updateButtons()
    }
    
    @objc private func doneButtonTapped() {
        let selectedQuestionsArray = questions.filter { selectedQuestions.contains($0.intId) }
        completion?(selectedQuestionsArray)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension QuestionSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionSelectionTableViewCell.identifier, for: indexPath) as? QuestionSelectionTableViewCell else {
            return UITableViewCell()
        }
        
        let question = questions[indexPath.row]
        let isSelected = selectedQuestions.contains(question.intId)
        
        cell.configure(with: question, isSelected: isSelected)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension QuestionSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let question = questions[indexPath.row]
        if selectedQuestions.contains(question.intId) {
            selectedQuestions.remove(question.intId)
        } else {
            selectedQuestions.insert(question.intId)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
        updateButtons()
    }
}

// MARK: - QuestionSelectionTableViewCellDelegate
extension QuestionSelectionViewController: QuestionSelectionTableViewCellDelegate {
    func didToggleSelection(for question: Question) {
        if selectedQuestions.contains(question.intId) {
            selectedQuestions.remove(question.intId)
        } else {
            selectedQuestions.insert(question.intId)
        }
        
        if let index = questions.firstIndex(where: { $0.intId == question.intId }) {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
        updateButtons()
    }
}
