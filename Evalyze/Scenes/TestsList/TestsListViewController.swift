//
//  TestsListViewController.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

protocol TestsListViewControllerDelegate: AnyObject {
    func didSelectTest(_ test: Test)
}

final class TestsListViewController: UIViewController {
    private let tableView: UITableView = UITableView()
    private let emptyStateLabel: UILabel = UILabel()
    
    private var tests: [Test] = []
    private let testStatus: TestStatus
    private let testService: TestServiceProtocol
    weak var delegate: TestsListViewControllerDelegate?
    init(testStatus: TestStatus, testService: TestServiceProtocol = TestService()) {
        self.testStatus = testStatus
        self.testService = testService
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
        loadTests()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .blackApp
        
        setupTableView()
        setupEmptyStateLabel()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TestTableViewCell.self, forCellReuseIdentifier: TestTableViewCell.identifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pin(to: view)
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.text = testStatus == .upcoming ? "Нет предстоящих тестов" : "Нет завершенных тестов"
        emptyStateLabel.setCustomFont(.sansRegular, size: 16)
        emptyStateLabel.textColor = .secondaryTextApp
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.pinCenterX(to: view)
        emptyStateLabel.pinCenterY(to: view)
    }
    
    private func loadTests() {
        print("📋 Loading tests with status: \(testStatus)")
        
        guard let currentUser = UserManager.shared.getCurrentUser() else {
            print("❌ No current user found")
            self.tests = []
            self.updateUI()
            return
        }
        
        testService.getAllTests { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allTests):
                    print("✅ Loaded \(allTests.count) tests from Firebase")
                    self?.filterAndDisplayTests(allTests, for: currentUser)
                case .failure(let error):
                    print("❌ Failed to load tests: \(error.localizedDescription)")
                    // Показываем пустой список вместо fallback на моки
                    self?.tests = []
                    self?.updateUI()
                }
            }
        }
    }
    
    private func filterAndDisplayTests(_ allTests: [Test], for user: User) {
        print("🔍 Filtering \(allTests.count) tests for \(user.role) with status: \(testStatus)")
        print("👤 Current user ID: \(user.id)")
        
        // Фильтруем по статусу
        let statusFilteredTests = allTests.filter { $0.status == testStatus }
        print("📊 After status filter (\(testStatus)): \(statusFilteredTests.count) tests")
        
        // Фильтруем по роли пользователя
        switch user.role {
        case .student:
            // Студенты видят только тесты для своих групп
            let userGroups = user.groups
            tests = statusFilteredTests.filter { test in
                userGroups.contains(test.targetGroup)
            }
            print("👨‍🎓 Student groups: \(userGroups), showing tests for these groups")
        case .teacher:
            // Преподаватели видят только тесты, которые они создали
            print("👨‍🏫 Filtering tests created by teacher: \(user.id)")
            for test in statusFilteredTests {
                print("   📝 Test '\(test.title)' created by: '\(test.createdBy)' (match: \(test.createdBy == user.id))")
            }
            tests = statusFilteredTests.filter { $0.createdBy == user.id }
        }
        
        print("📝 Final result: \(tests.count) tests for \(user.role)")
        updateUI()
    }
    
    
    private func updateUI() {
        emptyStateLabel.isHidden = !tests.isEmpty
        
        // Анимированное обновление таблицы
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Public Methods
    func refreshTests() {
        print("🔄 TestsListViewController: refreshing tests for status \(testStatus)")
        loadTests()
    }
}

// MARK: - UITableViewDataSource
extension TestsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.identifier, for: indexPath) as? TestTableViewCell else {
            return UITableViewCell()
        }
        
        let test = tests[indexPath.row]
        cell.configure(with: test)
        
        // Анимация появления ячейки
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.5, delay: Double(indexPath.row) * 0.1, options: .curveEaseOut) {
            cell.alpha = 1
            cell.transform = .identity
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TestsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Анимация нажатия на ячейку
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
        
        let test = tests[indexPath.row]
        delegate?.didSelectTest(test)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
