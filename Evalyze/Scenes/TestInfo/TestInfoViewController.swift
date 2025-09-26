//
//  TestInfoViewController.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

protocol TestInfoDisplayLogic: AnyObject {
    func displayTestInfo(_ viewModel: TestInfoModel.Load.ViewModel)
    func displayUpdatedInfo(_ viewModel: TestInfoModel.Update.ViewModel)
    func displayTestClosed(_ viewModel: TestInfoModel.CloseTest.ViewModel)
}

final class TestInfoViewController: UIViewController, TestInfoDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        static let title = "Тестирование"
        static let closeButtonTitle = "Завершить тест"
        static let studentCellIdentifier = "StudentStatusCell"
        static let updateInterval: TimeInterval = 5.0
    }
    
    // MARK: - Fields
    private let router: TestInfoRoutingLogic
    private let interactor: TestInfoBusinessLogic
    private var timer: Timer?
    
    private lazy var headerView: TestHeaderView = {
        let view = TestHeaderView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(StudentStatusCell.self, forCellReuseIdentifier: Constants.studentCellIdentifier)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        table.backgroundColor = .blackApp
        table.separatorColor = .lightGrayApp
        table.rowHeight = 110
        return table
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.closeButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemRed
        button.setTitleColor(.mainTextColor, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var students: [StudentStatusDisplay] = []
    
    // MARK: - LifeCycle
    init(
        router: TestInfoRoutingLogic,
        interactor: TestInfoBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        
        // Скрываем кнопку назад
        navigationItem.hidesBackButton = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        title = Constants.title
        view.backgroundColor = .blackApp
        
        // Настраиваем navigation bar
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .mainTextColor
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .grayApp
        appearance.titleTextAttributes = [.foregroundColor: UIColor.mainTextColor]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Скрываем кнопку назад
        navigationItem.setHidesBackButton(true, animated: false)
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(closeButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -16),
            
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private func loadData() {
        // Show loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .mainTextColor
        activityIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        interactor.loadTestInfo(TestInfoModel.Load.Request())
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Constants.updateInterval, repeats: true) { [weak self] _ in
            self?.interactor.loadUpdate(TestInfoModel.Update.Request())
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        let alert = UIAlertController(
            title: "Завершить тестирование",
            message: "Вы уверены, что хотите завершить тестирование досрочно?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Завершить", style: .destructive) { [weak self] _ in
            self?.interactor.loadCloseTest(TestInfoModel.CloseTest.Request())
        })
        
        // Настраиваем цвета алерта под темную тему
        if let view = alert.view.subviews.first?.subviews.first?.subviews.first {
            view.backgroundColor = .grayApp
            view.layer.cornerRadius = 12
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - DisplayLogic
    func displayTestInfo(_ viewModel: TestInfoModel.Load.ViewModel) {
        navigationItem.rightBarButtonItem = nil // Hide loading indicator
        
        students = viewModel.students
        headerView.configure(
            title: viewModel.testTitle,
            timeRemaining: viewModel.timeRemaining,
            totalStudents: viewModel.totalStudents,
            joinedStudents: viewModel.joinedStudents,
            progress: viewModel.progress
        )
        tableView.reloadData()
        
        if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func displayUpdatedInfo(_ viewModel: TestInfoModel.Update.ViewModel) {
        students = viewModel.students
        headerView.updateInfo(
            timeRemaining: viewModel.timeRemaining,
            joinedStudents: viewModel.joinedStudents,
            progress: viewModel.progress
        )
        tableView.reloadData()
        
        if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func displayTestClosed(_ viewModel: TestInfoModel.CloseTest.ViewModel) {
        if viewModel.success {
            timer?.invalidate()
            router.routeToTestClosed()
        } else if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let view = alert.view.subviews.first?.subviews.first?.subviews.first {
            view.backgroundColor = .grayApp
            view.layer.cornerRadius = 12
        }
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TestInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.studentCellIdentifier, for: indexPath) as! StudentStatusCell
        cell.configure(with: students[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Статус студентов"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .secondaryTextColor
            header.backgroundView?.backgroundColor = .blackApp
        }
    }
}

extension TestInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .grayApp
        cell.contentView.backgroundColor = .grayApp
        
        cell.transform = CGAffineTransform(translationX: 0, y: 20)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), options: [.curveEaseInOut]) {
            cell.transform = .identity
            cell.alpha = 1
        }
    }
}
