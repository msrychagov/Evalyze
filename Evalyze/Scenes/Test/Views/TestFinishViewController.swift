//
//  TestFinishViewController.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

final class TestFinishViewController: UIViewController {
    private let result: TestResult

    init(result: TestResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Результат теста"
        l.font = UIFont.custom(.sansBold, size: 22)
        l.textColor = .mainTextApp
        return l
    }()

    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.custom(.sansRegular, size: 15)
        tv.textColor = .mainTextApp
        tv.backgroundColor = .lightGrayApp
        tv.layer.cornerRadius = 10
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackApp
        view.addSubview(titleLabel)
        view.addSubview(textView)
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        titleLabel.pinCenterX(to: view)

        textView.pinTop(to: titleLabel.bottomAnchor, 12)
        textView.pinLeft(to: view, 16)
        textView.pinRight(to: view, 16)
        textView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)

        var lines = [String]()
        for (id, answer) in result.answers.sorted(by: { $0.key < $1.key }) {
            lines.append("Вопрос \(id):\n\(answer.isEmpty ? "(не дан ответ)" : answer)")
        }
        textView.text = lines.joined(separator: "\n\n")
    }
}
