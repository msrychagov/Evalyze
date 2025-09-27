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
    
    // MARK: Current User
    private var currentUser: User? {
        return UserManager.shared.getCurrentUser()
    }
    
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
        if currentUser?.isTeacher == true {
            configureAddButton()
        }
        configureContainerView()
        setupInitialTestsList()
    }
    
    private func configureProfileHeaderView() {
        guard let user = currentUser else {
            navigateToAuthentication()
            return
        }
        
        let title = user.isTeacher ? "Преподаватель" : "Студент"
        let group = user.isStudent ? user.studentGroup ?? "" : user.teacherGroups.first ?? ""
        
        profileHeaderView.configure(viewModel: .init(title: title, name: user.fullName, group: group))
        profileHeaderView.delegate = self
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.pinHorizontal(to: view, 10)
        profileHeaderView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        profileHeaderView.setHeight(120)
    }
    
    private func navigateToAuthentication() {
        DispatchQueue.main.async {
            let authViewController = AuthenticationAssembly.createModule()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = authViewController
                }, completion: nil)
            }
        }
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
        
        if currentUser?.isTeacher == true {
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
            if currentUser?.isTeacher == true {
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
            // Переход к intro экрану теста
            let testIntroVC = TestRouter.assembleModule()
            navigationController?.pushViewController(testIntroVC, animated: true)
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

// MARK: - ProfileHeaderViewDelegate
extension DashboardViewController: ProfileHeaderViewDelegate {
    func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Выход",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        // Используем AuthenticationService для выхода из Firebase
        let authService = AuthenticationService()
        authService.logout { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Очищаем пользователя из UserManager
                    UserManager.shared.clearUser()
                    
                    // Переходим на экран авторизации
                    self?.navigateToAuthentication()
                    
                case .failure(let error):
                    // Показываем ошибку, но всё равно очищаем локальные данные
                    print("Logout error: \(error.localizedDescription)")
                    UserManager.shared.clearUser()
                    self?.navigateToAuthentication()
                }
            }
        }
    }
}
