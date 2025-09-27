//
//  DashboardViewController.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 25.09.2025.
//

import UIKit

final class DashboardViewController: UIViewController {
    // MARK: UI Properties
    private let profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    private let worksLabel: UILabel = UILabel()
    private let segmentedControl: CustomSegmentedControl = CustomSegmentedControl()
    private let addButton: UIButton = UIButton(type: .system)
    private let containerView: UIView = UIView()
    
    // MARK: Child View Controllers
    private var currentTestsListViewController: TestsListViewController?
    
    // MARK: Mock User (temporary)
    private let currentUser: User = User(
        id: "mock_user_id",
        name: "Михаил Рычагов",
        email: "mikhail@example.com",
        role: .teacher,
        groups: ["БПИНЖ2383"],
        createdAt: Date()
    )
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackApp
        configureUI()
    }
    
    // MARK: Configure UI
    private func configureUI() {
        configureProfileHeaderView()
        configureWorksLabel()
        configureSegmentedControl()
        if currentUser.isTeacher {
            configureAddButton()
        }
        configureContainerView()
        setupInitialTestsList()
    }
    
    private func configureProfileHeaderView() {
        let title = currentUser.isTeacher ? "Преподаватель" : "Студент"
        let group = currentUser.isStudent ? currentUser.studentGroup ?? "" : currentUser.teacherGroups.first ?? ""
        
        profileHeaderView.configure(viewModel: .init(title: title, name: currentUser.name, group: group))
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.pinHorizontal(to: view, 10)
        profileHeaderView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        profileHeaderView.setHeight(120) // Увеличил высоту
    }
    
    private func configureWorksLabel() {
        worksLabel.text = "Работы"
        worksLabel.setCustomFont(.sansBold, size: 20)
        worksLabel.textColor = .mainTextApp
        worksLabel.textAlignment = .center
        view.addSubview(worksLabel)
        worksLabel.translatesAutoresizingMaskIntoConstraints = false
        worksLabel.pinHorizontal(to: view, 10)
        worksLabel.pinTop(to: profileHeaderView.bottomAnchor, 20)
    }
    
    private func configureSegmentedControl() {
        segmentedControl.delegate = self
        segmentedControl.configure(segments: ["Предстоящие", "Завершенные"], selectedIndex: 0)
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.pinHorizontal(to: view, 10)
        segmentedControl.pinTop(to: worksLabel.bottomAnchor, 12)
        segmentedControl.setHeight(40)
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinHorizontal(to: view)
        containerView.pinTop(to: segmentedControl.bottomAnchor, 16)
        
        if currentUser.isTeacher {
            containerView.pinBottom(to: addButton.topAnchor, 16)
        } else {
            containerView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)
        }
    }
    
    private func configureAddButton() {
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.setCustomFont(.sansBold, size: 24)
        addButton.backgroundColor = .blueAccent
        addButton.layer.cornerRadius = 30
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.pinCenterX(to: view)
        addButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 20)
        addButton.setWidth(60)
        addButton.setHeight(60)
    }
    
    @objc private func addButtonTapped() {
        let testCreationVC = TestCreationRouter.createModule()
        let navigationController = UINavigationController(rootViewController: testCreationVC)
        present(navigationController, animated: true)
    }
    
    // MARK: Tests List Management
    private func setupInitialTestsList() {
        showTestsList(for: .upcoming)
    }
    
    private func showTestsList(for status: TestStatus) {
        // Remove current tests list if exists
        if let currentVC = currentTestsListViewController {
            // Анимация исчезновения старого контроллера
            UIView.animate(withDuration: 0.3, animations: {
                currentVC.view.alpha = 0
                currentVC.view.transform = CGAffineTransform(translationX: -20, y: 0)
            }) { _ in
                currentVC.willMove(toParent: nil)
                currentVC.view.removeFromSuperview()
                currentVC.removeFromParent()
                
                // Создаем новый контроллер после удаления старого
                self.createNewTestsList(status: status)
            }
        } else {
            // Если нет текущего контроллера, создаем новый сразу
            createNewTestsList(status: status)
        }
    }
    
    private func createNewTestsList(status: TestStatus) {
        // Create new tests list
        let testsListVC = TestsListViewController(testStatus: status)
        testsListVC.delegate = self
        currentTestsListViewController = testsListVC
        
        // Add as child view controller
        addChild(testsListVC)
        containerView.addSubview(testsListVC.view)
        testsListVC.view.translatesAutoresizingMaskIntoConstraints = false
        testsListVC.view.pin(to: containerView)
        testsListVC.didMove(toParent: self)
        
        // Анимация появления нового контроллера
        testsListVC.view.alpha = 0
        testsListVC.view.transform = CGAffineTransform(translationX: 20, y: 0)
        
        UIView.animate(withDuration: 0.3) {
            testsListVC.view.alpha = 1
            testsListVC.view.transform = .identity
        }
    }
}

// MARK: - CustomSegmentedControlDelegate
extension DashboardViewController: CustomSegmentedControlDelegate {
    func didSelectSegment(at index: Int) {
        print("Selected segment at index: \(index)")
        
        let testStatus: TestStatus = index == 0 ? .upcoming : .completed
        showTestsList(for: testStatus)
    }
}

// MARK: - TestsListViewControllerDelegate
extension DashboardViewController: TestsListViewControllerDelegate {
    func didSelectTest(_ test: Test) {
        if test.status == .completed {
            // Проверяем роль пользователя
            if currentUser.isTeacher {
                // Для преподавателя: переход к списку студентов
                let studentsListVC = TestResultsRouter.createStudentsListModule(with: test)
                if let studentsListVC = studentsListVC as? StudentsListViewController {
                    studentsListVC.delegate = self
                }
                navigationController?.pushViewController(studentsListVC, animated: true)
            } else {
                // Для студента: переход к результатам теста
                let testResultsVC = TestResultsAssembly.createModule(with: test)
                navigationController?.pushViewController(testResultsVC, animated: true)
            }
        } else {
            // Переход к началу теста
            print("Starting test: \(test.title)")
            // TODO: Navigate to test start
        }
    }
}

// MARK: - StudentsListViewControllerDelegate
extension DashboardViewController: StudentsListViewControllerDelegate {
    func didSelectStudent(_ studentResult: StudentTestResult) {
        // Переход к результатам теста для выбранного студента
        let studentTestResultsVC = TestResultsRouter.createStudentTestResultsModule(with: studentResult)
        navigationController?.pushViewController(studentTestResultsVC, animated: true)
    }
}
