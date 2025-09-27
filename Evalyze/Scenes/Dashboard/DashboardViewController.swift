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
        print("Add button tapped")
        // TODO: Add action for teacher
    }
}

// MARK: - CustomSegmentedControlDelegate
extension DashboardViewController: CustomSegmentedControlDelegate {
    func didSelectSegment(at index: Int) {
        print("Selected segment at index: \(index)")
        // Handle segment selection logic here
    }
}
