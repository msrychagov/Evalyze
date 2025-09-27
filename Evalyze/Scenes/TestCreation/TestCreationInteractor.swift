//
//  TestCreationInteractor.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

final class TestCreationInteractor: TestCreationInteractorInputProtocol {
    weak var presenter: TestCreationInteractorOutputProtocol?
    
    private let groupService: GroupServiceProtocol
    private let questionService: QuestionServiceProtocol
    private let testService: TestServiceProtocol
    
    init(groupService: GroupServiceProtocol = GroupService(),
         questionService: QuestionServiceProtocol = QuestionService(),
         testService: TestServiceProtocol = TestService()) {
        self.groupService = groupService
        self.questionService = questionService
        self.testService = testService
    }
    
    func fetchGroups() {
        // Получаем группы созданные текущим преподавателем
        guard let currentUser = UserManager.shared.getCurrentUser(),
              currentUser.role == .teacher else {
            print("❌ User is not a teacher or not logged in")
            presenter?.didFetchGroups([])
            return
        }
        
        print("🔍 Fetching groups for teacher: \(currentUser.id)")
        
        groupService.getGroupsCreatedBy(teacherId: currentUser.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let groups):
                    print("✅ Successfully fetched \(groups.count) groups:")
                    for group in groups {
                        print("  - \(group.name) (createdBy: \(group.createdBy))")
                    }
                    let groupNames = groups.map { $0.name }
                    self?.presenter?.didFetchGroups(groupNames)
                case .failure(let error):
                    print("❌ Failed to fetch groups: \(error.localizedDescription)")
                    self?.presenter?.didFetchGroups([])
                }
            }
        }
    }
    
    func fetchQuestions() {
        print("🔍 Fetching questions from Firebase...")
        questionService.getAllQuestions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    print("✅ Successfully fetched \(questions.count) questions")
                    self?.presenter?.didFetchQuestions(questions)
                case .failure(let error):
                    print("❌ Failed to fetch questions: \(error.localizedDescription)")
                    self?.presenter?.didFetchQuestions([])
                }
            }
        }
    }
    
    func createTest(_ testModel: TestCreationModel) {
        let currentUserId = UserManager.shared.getCurrentUser()?.id ?? "unknown_teacher"
        let newTest = Test(
            id: UUID().uuidString,
            title: testModel.title,
            description: testModel.description,
            questions: testModel.selectedQuestions,
            duration: testModel.duration,
            status: .upcoming,
            createdBy: currentUserId,
            createdAt: Date(),
            dueDate: testModel.startDate,
            completedAt: nil,
            score: nil,
            maxScore: testModel.selectedQuestions.count * 10
        )
        
        print("🚀 Creating test: \(newTest.title) with \(newTest.questions.count) questions")
        
        testService.createTest(newTest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let test):
                    print("✅ Test created successfully in Firebase")
                    self?.presenter?.didCreateTest(test)
                case .failure(let error):
                    print("❌ Failed to create test: \(error.localizedDescription)")
                    self?.presenter?.didFailToCreateTest(error)
                }
            }
        }
    }
}
