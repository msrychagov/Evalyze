//
//  RegistrationView.swift
//  Evalyze
//
//  Created by Артём on 22.09.2025.
//

import UIKit

import UIKit

final class RegistrationView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "ФИО"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextApp
        label.textAlignment = .left
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGrayApp
        field.layer.cornerRadius = 10
        field.textColor = .mainTextApp
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .words
        
        field.textContentType = .none
        field.keyboardType = .default
        field.returnKeyType = .next
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "Иванов Иван Иванович",
            attributes: [.foregroundColor: UIColor.secondaryTextApp]
        )
        return field
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextApp
        label.textAlignment = .left
        return label
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGrayApp
        field.layer.cornerRadius = 10
        field.textColor = .white
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .none
        
        field.keyboardType = .emailAddress
        field.textContentType = .none
        field.returnKeyType = .next
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "example@email.com",
            attributes: [.foregroundColor: UIColor.secondaryTextApp]
        )
        return field
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextApp
        label.textAlignment = .left
        return label
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor(hex: "#2C2C2E")
        field.layer.cornerRadius = 10
        field.textColor = .mainTextApp
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .none
        
        field.isSecureTextEntry = false
        field.textContentType = .none
        field.passwordRules = nil
        field.returnKeyType = .default
        field.keyboardType = .asciiCapable
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [.foregroundColor: UIColor.secondaryTextApp]
        )
        return field
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.grayApp, for: .normal)
        button.titleLabel?.font = UIFont.custom(.sansBold, size: 18)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let roleSwitch: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Студент", "Преподаватель"])
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .lightGrayApp
        segmentedControl.selectedSegmentTintColor = .white
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.blackApp,
            .font: UIFont.custom(.sansRegular, size: 14)
        ], for: .selected)
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .font: UIFont.custom(.sansRegular, size: 14)
        ], for: .normal)
        
        return segmentedControl
    }()
    
    private let groupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGrayApp
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .left
        
        button.setTitle("Выберите группу", for: .normal)
        button.setTitleColor(.secondaryTextApp, for: .normal)
        button.titleLabel?.font = UIFont.custom(.sansRegular, size: 16)
        
        let arrowImage = UIImage(systemName: "chevron.down")?.withTintColor(.secondaryTextApp, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        
        var config = UIButton.Configuration.plain()
        config.title = "Выберите группу"
        config.baseForegroundColor = .secondaryTextApp
        config.image = arrowImage
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.custom(.sansRegular, size: 16)
            return outgoing
        }
        button.configuration = config
        
        return button
    }()
    
    private let createGroupLabel: UILabel = {
        let label = UILabel()
        label.text = "Создайте группы"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextApp
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let createGroupField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGrayApp
        field.layer.cornerRadius = 10
        field.textColor = .mainTextApp
        field.isHidden = true
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .words
        
        field.textContentType = .none
        field.keyboardType = .default
        field.returnKeyType = .done
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "Введите названия групп через запятую",
            attributes: [.foregroundColor: UIColor.secondaryTextApp]
        )
        return field
    }()
    
    private let addGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGrayApp
        button.layer.cornerRadius = 10
        button.isHidden = true
        
        button.setTitle("+ Добавить группу", for: .normal)
        button.setTitleColor(.secondaryTextApp, for: .normal)
        button.titleLabel?.font = UIFont.custom(.sansRegular, size: 14)
        
        return button
    }()
    
    private var createdGroups: [String] = []
    private var availableGroups: [Group] = []
    
    var onRegistrationTapped: ((String, String, String, UserRole, [String]) -> Void)?
    var onEmailChanged: ((String) -> Void)?
    var onGroupSelected: ((String) -> Void)?
    var onLoadGroups: (() -> Void)?
    var onCreateGroup: ((String) -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private final func configureUI() {
        self.isUserInteractionEnabled = true
        configureNameLabel()
        configureNameField()
        configureEmailLabel()
        configureEmailField()
        configurePasswordLabel()
        configurePasswordField()
        configureRoleSwitch()
        configureGroupElements()
        configureRegistrationButton()
        
        // Устанавливаем начальное состояние для студента
        showStudentElements()
        updateEmailPlaceholder(for: .student)
        
        // Запрашиваем загрузку групп
        onLoadGroups?()
    }
    
    private final func configureNameLabel() {
        self.addSubview(nameLabel)
        
        nameLabel.pinTop(to: self)
        nameLabel.pinLeft(to: self.leadingAnchor, 5)
    }
    
    private final func configureNameField() {
        self.addSubview(nameField)
        
        nameField.pinTop(to: nameLabel.bottomAnchor, 5)
        nameField.pinHorizontal(to: self)
        nameField.setHeight(40)
        
        nameField.delegate = self
    }
    
    private final func configureEmailLabel() {
        self.addSubview(emailLabel)
        
        emailLabel.pinTop(to: nameField.bottomAnchor, 15)
        emailLabel.pinLeft(to: self.leadingAnchor, 5)
    }
    
    private final func configureEmailField() {
        self.addSubview(emailField)
        
        emailField.pinTop(to: emailLabel.bottomAnchor, 5)
        emailField.pinHorizontal(to: self)
        emailField.setHeight(40)
        
        emailField.delegate = self
    }
    
    private final func configurePasswordLabel() {
        self.addSubview(passwordLabel)
        
        passwordLabel.pinTop(to: emailField.bottomAnchor, 15)
        passwordLabel.pinLeft(to: self.leadingAnchor, 5)
    }
    
    private final func configurePasswordField() {
        self.addSubview(passwordField)
        
        passwordField.pinTop(to: passwordLabel.bottomAnchor, 5)
        passwordField.pinHorizontal(to: self)
        passwordField.setHeight(40)
        
        passwordField.delegate = self
    }
    
    private final func configureRoleSwitch() {
        self.addSubview(roleSwitch)
        
        roleSwitch.pinTop(to: passwordField.bottomAnchor, 25)
        roleSwitch.pinHorizontal(to: self)
        
        roleSwitch.addTarget(self, action: #selector(roleSwitchChanged), for: .valueChanged)
    }
    
    private final func configureGroupElements() {
        // Настройка элементов для студентов
        self.addSubview(groupButton)
        groupButton.pinTop(to: roleSwitch.bottomAnchor, 25)
        groupButton.pinHorizontal(to: self)
        groupButton.setHeight(44)
        groupButton.addTarget(self, action: #selector(groupButtonTapped), for: .touchUpInside)
        
        self.addSubview(createGroupLabel)
        createGroupLabel.pinTop(to: roleSwitch.bottomAnchor, 25)
        createGroupLabel.pinLeft(to: self.leadingAnchor, 5)
        
        self.addSubview(createGroupField)
        createGroupField.pinTop(to: createGroupLabel.bottomAnchor, 5)
        createGroupField.pinHorizontal(to: self)
        createGroupField.setHeight(44)
        createGroupField.delegate = self
        
        self.addSubview(addGroupButton)
        addGroupButton.pinTop(to: createGroupField.bottomAnchor, 10)
        addGroupButton.pinHorizontal(to: self)
        addGroupButton.setHeight(36)
        addGroupButton.addTarget(self, action: #selector(addGroupButtonTapped), for: .touchUpInside)
    }
    
    private final func configureRegistrationButton() {
        self.addSubview(registrationButton)
        
        // Настраиваем статичные констрейнты
        registrationButton.pinHorizontal(to: self)
        registrationButton.setHeight(50)
        registrationButton.pinBottom(to: self, 20)
        
        // Устанавливаем динамический top констрейнт
        updateRegistrationButtonConstraints()
        
        registrationButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        registrationButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        registrationButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
    }
    
    private var registrationButtonTopConstraint: NSLayoutConstraint?
    
    private func updateRegistrationButtonConstraints() {
        // Деактивируем старый констрейнт
        registrationButtonTopConstraint?.isActive = false
        
        // Создаем новый констрейнт в зависимости от выбранной роли
        if roleSwitch.selectedSegmentIndex == 0 { // Студент
            registrationButtonTopConstraint = registrationButton.topAnchor.constraint(equalTo: groupButton.bottomAnchor, constant: 35)
        } else { // Преподаватель
            registrationButtonTopConstraint = registrationButton.topAnchor.constraint(equalTo: addGroupButton.bottomAnchor, constant: 35)
        }
        
        // Активируем новый констрейнт
        registrationButtonTopConstraint?.isActive = true
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.08, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.registrationButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.registrationButton.alpha = 0.9
        }
    }
    
    @objc private func roleSwitchChanged() {
        UIView.animate(withDuration: 0.3) {
            if self.roleSwitch.selectedSegmentIndex == 0 { // Студент
                self.showStudentElements()
                self.updateEmailPlaceholder(for: .student)
            } else { // Преподаватель
                self.showTeacherElements()
                self.updateEmailPlaceholder(for: .teacher)
            }
            self.updateRegistrationButtonConstraints()
            self.layoutIfNeeded()
        }
    }
    
    private func showStudentElements() {
        groupButton.isHidden = false
        createGroupLabel.isHidden = true
        createGroupField.isHidden = true
        addGroupButton.isHidden = true
    }
    
    private func showTeacherElements() {
        groupButton.isHidden = true
        createGroupLabel.isHidden = false
        createGroupField.isHidden = false
        addGroupButton.isHidden = false
    }
    
    private func updateEmailPlaceholder(for role: UserRole) {
        let placeholderText: String
        let textColor = UIColor.secondaryTextApp
        
        switch role {
        case .student:
            placeholderText = "student@edu.hse.ru"
        case .teacher:
            placeholderText = "teacher@hse.ru"
        }
        
        emailField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.foregroundColor: textColor]
        )
    }
    
    @objc private func groupButtonTapped() {
        guard !availableGroups.isEmpty else {
            showNoGroupsAlert()
            return
        }
        
        let alert = UIAlertController(title: "Выберите группу", message: nil, preferredStyle: .actionSheet)
        
        availableGroups.forEach { group in
            alert.addAction(UIAlertAction(title: group.displayName, style: .default) { [weak self] _ in
                self?.selectGroup(group.name)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let parentViewController = self.findViewController() {
            parentViewController.present(alert, animated: true)
        }
    }
    
    private func selectGroup(_ groupName: String) {
        groupButton.setTitle(groupName, for: .normal)
        groupButton.setTitleColor(.white, for: .normal)
        onGroupSelected?(groupName)
    }
    
    private func showNoGroupsAlert() {
        let alert = UIAlertController(
            title: "Нет доступных групп",
            message: "Пока нет созданных групп. Обратитесь к преподавателю для создания группы.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let parentViewController = self.findViewController() {
            parentViewController.present(alert, animated: true)
        }
    }
    
    @objc private func addGroupButtonTapped() {
        guard let groupText = createGroupField.text, !groupText.isEmpty else { return }
        
        // Разбиваем по запятым и очищаем от пробелов
        let newGroups = groupText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        
        // Проверяем каждую группу на существование
        for trimmedGroupName in newGroups {
            let groupExists = availableGroups.contains { $0.name.uppercased() == trimmedGroupName.uppercased() } ||
                             createdGroups.contains { $0.uppercased() == trimmedGroupName.uppercased() }
            
            if groupExists {
                showGroupExistsAlert(groupName: trimmedGroupName)
                return
            }
            
            createdGroups.append(trimmedGroupName)
            onCreateGroup?(trimmedGroupName)
        }
        
        createGroupField.text = ""
        updateCreateGroupPlaceholder()
        
        print("Группы добавлены локально: \(newGroups)")
        print("Всего групп для создания: \(createdGroups)")
    }
    
    private func showGroupExistsAlert(groupName: String) {
        let alert = UIAlertController(
            title: "Группа уже существует",
            message: "Группа \"\(groupName)\" уже создана",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let parentViewController = self.findViewController() {
            parentViewController.present(alert, animated: true)
        }
    }
    
    private func updateCreateGroupPlaceholder() {
        let groupCount = createdGroups.count
        let placeholderText = groupCount == 0 ? 
            "Введите название группы" : 
            "Создано групп: \(groupCount). Добавить еще?"
        
        createGroupField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.foregroundColor: UIColor.secondaryTextApp]
        )
    }
    
    // MARK: - Public Methods
    func updateAvailableGroups(_ groups: [Group]) {
        availableGroups = groups
        
        if availableGroups.isEmpty {
            groupButton.setTitle("Нет доступных групп", for: .normal)
            groupButton.setTitleColor(.secondaryTextApp, for: .normal)
            groupButton.isEnabled = false
        } else {
            groupButton.setTitle("Выберите группу", for: .normal)
            groupButton.setTitleColor(.secondaryTextApp, for: .normal)
            groupButton.isEnabled = true
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.registrationButton.transform = .identity
            self.registrationButton.alpha = 1.0
        }
    }
    
    @objc final func registrationButtonTapped() {
        let name = nameField.text ?? ""
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let userRole = roleSwitch.selectedSegmentIndex == 0 ? UserRole.student : UserRole.teacher
        
        var groups: [String] = []
        
        if roleSwitch.selectedSegmentIndex == 0 {
            if let selectedGroup = groupButton.titleLabel?.text, selectedGroup != "Выберите группу" {
                groups = [selectedGroup]
            }
        } else { // Преподаватель
            groups = createdGroups
            // Если есть текст в поле, добавляем его тоже
            if let fieldText = createGroupField.text, !fieldText.isEmpty {
                let additionalGroups = fieldText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                groups.append(contentsOf: additionalGroups)
            }
        }
        
        onRegistrationTapped?(name, email, password, userRole, groups)
        print("reg in - Role: \(userRole), Groups: \(groups)")
    }
}

extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            self.emailField.becomeFirstResponder()
        } else if textField == emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            if roleSwitch.selectedSegmentIndex == 1 { // Преподаватель
                self.createGroupField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else if textField == createGroupField {
            addGroupButtonTapped()
        }
        return false
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

