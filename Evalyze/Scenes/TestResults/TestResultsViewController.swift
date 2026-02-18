//
//  TestResultsViewController.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

final class TestResultsViewController: UIViewController, TestResultsViewProtocol {
    var presenter: TestResultsPresenterProtocol?
    
    private let tableView: UITableView = UITableView()
    private let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private var questionResults: [QuestionResult] = []
    private var expandedCells: Set<Int> = []
    private var isTeacherMode: Bool = false
    private var studentResult: StudentTestResult?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("🔧 TestResultsViewController init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("📱 TestResultsViewController viewDidLoad")
        setupUI()
        presenter?.viewDidLoad()
    }
    
    func showTestResults(_ results: [QuestionResult]) {
        questionResults = results
        
        if let interactor = presenter?.interactor as? TestResultsInteractor {
            isTeacherMode = interactor.getCurrentUserRole() == .teacher
        }
        
        tableView.reloadData()
    }
    
    func setStudentResult(_ studentResult: StudentTestResult) {
        self.studentResult = studentResult
        updateNavigationTitle()
    }
    
    private func updateNavigationTitle() {
        if let studentResult = studentResult {
            title = "\(studentResult.student.fullName) - Результаты"
        } else {
            title = "Результаты теста"
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Проверяем что контроллер добавлен в иерархию перед показом алерта
        if view.window != nil {
            present(alert, animated: true)
        } else {
            // Если контроллер еще не добавлен, показываем алерт с задержкой
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(alert, animated: true)
            }
        }
    }
    
    func showLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .blackApp
        setupNavigationBar()
        setupTableView()
        setupLoadingView()
    }
    
    private func setupNavigationBar() {
        updateNavigationTitle()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(QuestionResultTableViewCell.self, forCellReuseIdentifier: QuestionResultTableViewCell.identifier)
        
        // Настройка автоматической высоты ячеек
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupLoadingView() {
        loadingView.color = .mainTextApp
        loadingView.hidesWhenStopped = true
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.pinCenterX(to: view)
        loadingView.pinCenterY(to: view)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TestResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionResultTableViewCell.identifier, for: indexPath) as? QuestionResultTableViewCell else {
            return UITableViewCell()
        }
        
        let result = questionResults[indexPath.row]
        let isExpanded = expandedCells.contains(indexPath.row)
        
        cell.delegate = self
        cell.configure(with: result, isExpanded: isExpanded, isTeacherMode: isTeacherMode)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TestResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - QuestionResultTableViewCellDelegate
extension TestResultsViewController: QuestionResultTableViewCellDelegate {
    func didTapExpandButton(for cell: QuestionResultTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if expandedCells.contains(indexPath.row) {
            expandedCells.remove(indexPath.row)
        } else {
            expandedCells.insert(indexPath.row)
        }
        
        // Анимированное обновление высоты ячейки
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func didUpdateScore(for questionId: Int, score: Int) {
        presenter?.didUpdateScore(for: questionId, score: score)
    }
}
