import UIKit
import FirebaseFirestore

class AddQuestionsViewController: UIViewController {
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addQuestionsToFirestore()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Добавление вопросов в Firestore"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        view.addSubview(titleLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addQuestionsToFirestore() {
        let questions = createQuestions()
        
        // Создаем batch для атомарной записи
        let batch = db.batch()
        
        for question in questions {
            let questionRef = db.collection("questions").document()
            batch.setData(question.dictionary, forDocument: questionRef)
        }
        
        // Выполняем batch запрос
        batch.commit { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(message: "Ошибка при добавлении вопросов: \(error.localizedDescription)")
                } else {
                    self?.showSuccessAlert()
                }
            }
        }
    }
    
    private func createQuestions() -> [Question] {
        return [
            // Управление памятью
            Question(category: "Управление памятью", question: "Какие типы данных (различные по хранению в памяти) используются в iOS? Чем отличается стек от кучи?"),
            Question(category: "Управление памятью", question: "Как называется \"утечка памяти\" в Swift?"),
            Question(category: "Управление памятью", question: "Что такое ARC? Как это работает?"),
            Question(category: "Управление памятью", question: "Что означает unowned? Чем это отличается от weak?"),
            
            // Основы языка и конструкции
            Question(category: "Основы языка и конструкции", question: "Что такое enum? Является ли enum в Swift ссылочным или значим типом?"),
            Question(category: "Основы языка и конструкции", question: "Почему enum в Swift - это «лучший» enum на сегодняшний день, даже по сравнению с Java?"),
            Question(category: "Основы языка и конструкции", question: "Как сделать enum десериализуемым?"),
            Question(category: "Основы языка и конструкции", question: "В чем разница между ассоциированными и присвоенными (raw) значениями?"),
            Question(category: "Основы языка и конструкции", question: "В чем разница между классами и структурами в Swift?"),
            Question(category: "Основы языка и конструкции", question: "Что такое lazy свойства в Swift и зачем они нужны?"),
            Question(category: "Основы языка и конструкции", question: "Что такое Optional? Как он реализован в Swift?"),
            Question(category: "Основы языка и конструкции", question: "Назовите 4 способа, которыми можно развернуть Optional (превратить Type? в Type)"),
            Question(category: "Основы языка и конструкции", question: "Что такое COW?"),
            Question(category: "Основы языка и конструкции", question: "Что такое ключевое слово «final»? Зачем оно нам нужно? Подсказка: не для того, чтобы запрещать наследование"),
            Question(category: "Основы языка и конструкции", question: "Что такое typealias и зачем он нужен?"),
            Question(category: "Основы языка и конструкции", question: "Как работает defer в Swift? В каких случаях его использование оправдано?"),
            Question(category: "Основы языка и конструкции", question: "Что такое диспетчеризация методов в Swift? Назовите 4 типа."),
            Question(category: "Основы языка и конструкции", question: "Что такое замыкание в Swift? Когда замыкание захватывает по ссылке а когда по значению"),
            Question(category: "Основы языка и конструкции", question: "Чем отличаются escaping и non-escaping замыкания?"),
            
            // Архитектура и проектирование
            Question(category: "Архитектура и проектирование", question: "Назовите более 5 архитектур мобильных приложений"),
            Question(category: "Архитектура и проектирование", question: "В чем разница между инкапсуляцией и сокрытием? Подсказка: это совершенно разные вещи, не отвечайте «это одно и то же»."),
            Question(category: "Архитектура и проектирование", question: "Что такое модификаторы доступа в Swift? Какой из них используется по умолчанию?"),
            Question(category: "Архитектура и проектирование", question: "В чем отличие POP (Protocol-Oriented Programming) от OOP (Object-Oriented Programming)?"),
            Question(category: "Архитектура и проектирование", question: "Как в Swift можно реализовать Singleton и какие у него плюсы и минусы?"),
            
            // Жизненный цикл приложения и ViewController
            Question(category: "Жизненный цикл приложения и ViewController", question: "Назовите 5 этапов жизненного цикла приложения в iOS. Что они собой представляют?"),
            Question(category: "Жизненный цикл приложения и ViewController", question: "Назовите методы жизненного цикла UIViewController"),
            Question(category: "Жизненный цикл приложения и ViewController", question: "Что такое didReceiveMemoryWarning? Что нужно делать в этом случае? Memory Bubble"),
            Question(category: "Жизненный цикл приложения и ViewController", question: "Срабатывает ли viewDidAppear при открытии приложения из фонового или неактивного состояния?"),
            Question(category: "Жизненный цикл приложения и ViewController", question: "Что происходит, когда пользователь нажимает на иконку приложения, чтобы открыть его? смена состояний + методы AppDelegate"),
            Question(category: "Жизненный цикл приложения и ViewController", question: "Как работает viewWillAppear и viewDidAppear? В каких случаях их нужно переопределять?"),
            
            // Работа с UI
            Question(category: "Работа с UI", question: "Что такое UIStackView, UITableView, UICollectionView? В каких сценариях стоит использовать каждый из них? Почему?"),
            Question(category: "Работа с UI", question: "Для чего предназначен метод prepareForReuse?"),
            Question(category: "Работа с UI", question: "Что такое CALayer? Чем он отличается от UIView?"),
            Question(category: "Работа с UI", question: "Что такое layoutSubviews и когда он вызывается?"),
            Question(category: "Работа с UI", question: "В чем разница между frame и bounds у UIView?"),
            Question(category: "Работа с UI", question: "Напишите псевдокод на языке semiSwift для размещения кнопки в центре view"),
            Question(category: "Работа с UI", question: "Как работает setNeedsLayout() и layoutIfNeeded()?"),
            
            // Обработка событий и взаимодействие с пользователем
            Question(category: "Обработка событий и взаимодействие с пользователем", question: "Что такое RunLoop? autoReleasePool"),
            Question(category: "Обработка событий и взаимодействие с пользователем", question: "Что делает userInteractionEnabled?"),
            Question(category: "Обработка событий и взаимодействие с пользователем", question: "Какова логика hit-testing в iOS? когда point(inside: ...) вернёт false?"),
            Question(category: "Обработка событий и взаимодействие с пользователем", question: "Что такое цепочка UIResponder (UIResponder chain)?"),
            Question(category: "Обработка событий и взаимодействие с пользователем", question: "Чем отличаются цепочка UIResponder и механизм hit-testing?"),
            
            // Многопоточность и асинхронное выполнение
            Question(category: "Многопоточность и асинхронное выполнение", question: "Назовите 3 способа выполнения параллельных задач в Swift"),
            Question(category: "Многопоточность и асинхронное выполнение", question: "Как синхронизировать доступ к общему параметру из нескольких потоков в Swift?"),
            Question(category: "Многопоточность и асинхронное выполнение", question: "Что такое DispatchQueue?"),
            Question(category: "Многопоточность и асинхронное выполнение", question: "Почему нельзя вызывать DispatchQueue.main.sync в главном потоке? Можем ли мы делать это из других потоков?"),
            Question(category: "Многопоточность и асинхронное выполнение", question: "Назовите как можно больше известных вам проблем многопоточности"),
            Question(category: "Многопоточность и асинхронное выполнение", question: "Как работает DispatchGroup и в каких случаях его стоит использовать?"),
            Question(category: "Многопоточность и асинхронное выполнение", question: "Как сделать потокобезопасную коллекцию в Swift?"),
            Question(category: "Многопоточность и асинхронное выполнение", question: "В чем разница между NSOperationQueue и DispatchQueue?"),
            Question(category: "Miscellaneous", question: "Какова разница между KVO (Key-Value Observing) и NotificationCenter?"),
            Question(category: "Miscellaneous", question: "Назовите как минимум 2 способа сохранения информации на iPhone, чтобы она сохранялась при повторном открытии приложения. Когда и почему стоит использовать каждый из способов?"),
            Question(category: "Miscellaneous", question: "Что такое Codable и как его использовать?")
        ]
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Успех!",
            message: "Все вопросы успешно добавлены в Firestore",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.addQuestionsToFirestore()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
}

// Модель вопроса
struct Question {
    let id = UUID().uuidString
    let category: String
    let question: String
    let createdAt = Date()
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "category": category,
            "question": question,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
