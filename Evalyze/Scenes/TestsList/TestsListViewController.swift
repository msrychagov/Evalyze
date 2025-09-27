//
//  TestsListViewController.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

final class TestsListViewController: UIViewController {
    // MARK: UI Properties
    private let tableView: UITableView = UITableView()
    private let emptyStateLabel: UILabel = UILabel()
    
    // MARK: Properties
    private var tests: [Test] = []
    private let testStatus: TestStatus
    
    // MARK: Initialization
    init(testStatus: TestStatus) {
        self.testStatus = testStatus
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
        tests = testStatus == .upcoming ? Test.mockUpcomingTests : Test.mockCompletedTests
        emptyStateLabel.isHidden = !tests.isEmpty
        tableView.reloadData()
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
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TestsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let test = tests[indexPath.row]
        print("Selected test: \(test.title)")
        // TODO: Navigate to test details or start test
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
