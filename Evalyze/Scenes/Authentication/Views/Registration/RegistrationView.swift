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
        label.textColor = .mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGrayApp
        field.layer.cornerRadius = 10
        field.textColor = .mainTextColor
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .words
        
        field.textContentType = .name
        field.keyboardType = .default
        field.returnKeyType = .next
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "Иванов Иван Иванович",
            attributes: [.foregroundColor: UIColor.secondaryTextColor]
        )
        return field
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextColor
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
        field.textContentType = .emailAddress
        field.returnKeyType = .next
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "example@email.com",
            attributes: [.foregroundColor: UIColor.secondaryTextColor]
        )
        return field
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.setCustomFont(.sansRegular, size: 16)
        label.textColor = .mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor(hex: "#2C2C2E")
        field.layer.cornerRadius = 10
        field.textColor = .mainTextColor
        
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .none
        
        field.isSecureTextEntry = true
        field.textContentType = .password
        field.returnKeyType = .default
        field.keyboardType = .asciiCapable
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        field.rightViewMode = .always
        
        field.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [.foregroundColor: UIColor.secondaryTextColor]
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
        button.setTitleColor(.secondaryTextColor, for: .normal)
        button.titleLabel?.font = UIFont.custom(.sansRegular, size: 16)
        
        let arrowImage = UIImage(systemName: "chevron.down")?.withTintColor(.secondaryTextColor, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        
        var config = UIButton.Configuration.plain()
        config.title = "Выберите группу"
        config.baseForegroundColor = .secondaryTextColor
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
        label.textColor = .mainTextColor
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let createGroupField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGrayApp
        field.layer.cornerRadius = 10
        field.textColor = .mainTextColor
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
            attributes: [.foregroundColor: UIColor.secondaryTextColor]
        )
        return field
    }()
    
    private let addGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGrayApp
        button.layer.cornerRadius = 10
        button.isHidden = true
        
        button.setTitle("+ Добавить группу", for: .normal)
        button.setTitleColor(.secondaryTextColor, for: .normal)
        button.titleLabel?.font = UIFont.custom(.sansRegular, size: 14)
        
        return button
    }()
    
    private var createdGroups: [String] = []
    
    var onRegistrationTapped: ((String, String, String, UserRole, [String]) -> Void)?
    var onEmailChanged: ((String) -> Void)?
    var onGroupSelected: ((String) -> Void)?
    
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
        
        // Настройка элементов для преподавателей
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
        
        // Кнопка будет привязана к нижнему элементу в зависимости от роли
        updateRegistrationButtonConstraints()
        
        registrationButton.pinHorizontal(to: self)
        registrationButton.setHeight(50)
        registrationButton.pinBottom(to: self, 20)
        
        registrationButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        registrationButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        registrationButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
    }
    
    private func updateRegistrationButtonConstraints() {
        registrationButton.removeFromSuperview()
        self.addSubview(registrationButton)
        
        if roleSwitch.selectedSegmentIndex == 0 { // Студент
            registrationButton.pinTop(to: groupButton.bottomAnchor, 35)
        } else { // Преподаватель
            registrationButton.pinTop(to: addGroupButton.bottomAnchor, 35)
        }
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
            } else { // Преподаватель
                self.showTeacherElements()
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
    
    @objc private func groupButtonTapped() {
        let groups = ["ИВТ-21", "ИВТ-22", "ИВТ-23", "ПИ-21", "ПИ-22", "ИБ-21"]
        
        let alert = UIAlertController(title: "Выберите группу", message: nil, preferredStyle: .actionSheet)
        
        groups.forEach { group in
            alert.addAction(UIAlertAction(title: group, style: .default) { [weak self] _ in
                self?.selectGroup(group)
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
    
    @objc private func addGroupButtonTapped() {
        guard let groupText = createGroupField.text, !groupText.isEmpty else { return }
        
        // Разбиваем по запятым и очищаем от пробелов
        let newGroups = groupText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        
        createdGroups.append(contentsOf: newGroups)
        createGroupField.text = ""
        
        // Обновляем placeholder с количеством созданных групп
        let groupCount = createdGroups.count
        createGroupField.attributedPlaceholder = NSAttributedString(
            string: "Создано групп: \(groupCount). Добавить еще?",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
        
        print("Созданные группы: \(createdGroups)")
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
        
        if roleSwitch.selectedSegmentIndex == 0 { // Студент
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

