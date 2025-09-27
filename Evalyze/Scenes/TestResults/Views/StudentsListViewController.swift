//
//  StudentsListViewController.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

protocol StudentsListViewControllerDelegate: AnyObject {
    func didSelectStudent(_ studentResult: StudentTestResult)
}

final class StudentsListViewController: UIViewController {
    // MARK: UI Properties
    private let tableView: UITableView = UITableView()
    private let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private let emptyStateLabel: UILabel = UILabel()
    
    // MARK: Properties
    private var studentResults: [StudentTestResult] = []
    private let test: Test
    weak var delegate: StudentsListViewControllerDelegate?
    
    // MARK: Initialization
    init(test: Test) {
        self.test = test
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
        loadStudentResults()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .blackApp
        setupNavigationBar()
        setupTableView()
        setupLoadingView()
        setupEmptyStateLabel()
    }
    
    private func setupNavigationBar() {
        title = "Студенты"
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
        tableView.register(StudentResultTableViewCell.self, forCellReuseIdentifier: StudentResultTableViewCell.identifier)
        
        // Настройка автоматической высоты ячеек
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pin(to: view)
    }
    
    private func setupLoadingView() {
        loadingView.color = .mainTextApp
        loadingView.hidesWhenStopped = true
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.pinCenterX(to: view)
        loadingView.pinCenterY(to: view)
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.text = "Нет студентов, прошедших тест"
        emptyStateLabel.setCustomFont(.sansRegular, size: 16)
        emptyStateLabel.textColor = .secondaryTextApp
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.pinCenterX(to: view)
        emptyStateLabel.pinCenterY(to: view)
    }
    
    private func loadStudentResults() {
        // TODO: Implement Firebase integration for student results
        print("❌ Student results not implemented for Firebase yet")
        self.studentResults = []
        self.emptyStateLabel.isHidden = false
        self.tableView.reloadData()
    }
    
    private func showLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    private func hideLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension StudentsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentResultTableViewCell.identifier, for: indexPath) as? StudentResultTableViewCell else {
            return UITableViewCell()
        }
        
        let studentResult = studentResults[indexPath.row]
        cell.configure(with: studentResult)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StudentsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let studentResult = studentResults[indexPath.row]
        delegate?.didSelectStudent(studentResult)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
