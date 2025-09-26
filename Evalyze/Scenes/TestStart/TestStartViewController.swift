//
//  TestStartViewController.swift
//  Evalyze
//
//  Created by Малова Олеся on 25.09.2025.
//

import UIKit

protocol TestStartDisplayLogic: AnyObject {
    func displayStart(_ viewModel: TestStartModel.Start.ViewModel)
    func displayTests(_ viewModel: TestStartModel.LoadTests.ViewModel)
    func displayStudents(_ viewModel: TestStartModel.LoadStudents.ViewModel)
    func displaySelectedTest(_ viewModel: TestStartModel.SelectTest.ViewModel)
    func displayUpdatedStudents(_ viewModel: TestStartModel.ToggleStudent.ViewModel)
    func displayTestStarted(_ viewModel: TestStartModel.StartTest.ViewModel)
}

final class TestStartViewController: UIViewController, TestStartDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        static let title = "Запуск теста"
        static let startButtonTitle = "Запустить тест"
        static let testCellIdentifier = "TestCell"
        static let studentCellIdentifier = "StudentCell"
    }
    
    // MARK: - Fields
    private let router: TestStartRoutingLogic
    private let interactor: TestStartBusinessLogic
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TestCell.self, forCellReuseIdentifier: Constants.testCellIdentifier)
        table.register(StudentCell.self, forCellReuseIdentifier: Constants.studentCellIdentifier)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.blackApp
        table.separatorStyle = .singleLine
        table.sectionIndexColor = UIColor.grayApp
        table.tintColor = UIColor.mainTextColor
        return table
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.startButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.lightGrayApp
        button.setTitleColor(UIColor.mainTextColor, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private var tests: [TestDisplay] = []
    private var students: [StudentDisplay] = []
    private var isStartButtonEnabled = false
    
    // MARK: - LifeCycle
    init(
        router: TestStartRoutingLogic,
        interactor: TestStartBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        interactor.loadStart(TestStartModel.Start.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        title = Constants.title
        view.backgroundColor = UIColor.grayApp
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        view.addSubview(startButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -16),
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    // MARK: - Actions
    @objc
    private func startButtonTapped() {
        interactor.loadStartTest(TestStartModel.StartTest.Request())
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: TestStartModel.Start.ViewModel) {
        tests = viewModel.tests
        students = viewModel.students
        isStartButtonEnabled = viewModel.isStartButtonEnabled
        updateStartButton()
        tableView.reloadData()
        
        if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func displayTests(_ viewModel: TestStartModel.LoadTests.ViewModel) {
        tests = viewModel.tests
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        
        if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func displayStudents(_ viewModel: TestStartModel.LoadStudents.ViewModel) {
        students = viewModel.students
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        
        if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func displaySelectedTest(_ viewModel: TestStartModel.SelectTest.ViewModel) {
        students = viewModel.students
        isStartButtonEnabled = viewModel.isStartButtonEnabled
        updateStartButton()
        tableView.reloadData()
        
        if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func displayUpdatedStudents(_ viewModel: TestStartModel.ToggleStudent.ViewModel) {
        students = viewModel.students
        isStartButtonEnabled = viewModel.isStartButtonEnabled
        updateStartButton()
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        
        if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    func displayTestStarted(_ viewModel: TestStartModel.StartTest.ViewModel) {
        if viewModel.success {
            router.routeToTestInfo()
        } else if let errorMessage = viewModel.errorMessage {
            showErrorAlert(message: errorMessage)
        }
    }
    
    private func updateStartButton() {
        startButton.isEnabled = isStartButtonEnabled
        startButton.alpha = isStartButtonEnabled ? 1.0 : 0.5
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TestStartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Тест" : "Выберите студентов"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? tests.count : students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.testCellIdentifier, for: indexPath) as! TestCell
            cell.configure(with: tests[indexPath.row])
            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.studentCellIdentifier, for: indexPath) as! StudentCell
            cell.configure(with: students[indexPath.row])
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let testId = tests[indexPath.row].id
            interactor.loadSelectTest(TestStartModel.SelectTest.Request(testId: testId))
        } else {
            let studentId = students[indexPath.row].id
            interactor.loadToggleStudent(TestStartModel.ToggleStudent.Request(studentId: studentId))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
