import UIKit

final class TestHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .mainTextColor
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemOrange
        label.textAlignment = .center
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .lightGrayApp
        progressView.progressTintColor = .systemYellow
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .grayApp
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGrayApp.cgColor
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, timeLabel, progressView, statsLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func configure(title: String, timeRemaining: String, totalStudents: String, joinedStudents: String, progress: String) {
        titleLabel.text = title
        timeLabel.text = "Осталось времени: \(timeRemaining)"
        statsLabel.text = "Студентов: \(joinedStudents)/\(totalStudents) • Прогресс: \(progress)"
        
        if let progressValue = Double(progress.replacingOccurrences(of: "%", with: "")) {
            progressView.setProgress(Float(progressValue / 100), animated: false)
        }
    }
    
    func updateInfo(timeRemaining: String, joinedStudents: String, progress: String) {
        timeLabel.text = "Осталось времени: \(timeRemaining)"
        statsLabel.text = "Студентов: \(joinedStudents) • Прогресс: \(progress)"
        
        if let progressValue = Double(progress.replacingOccurrences(of: "%", with: "")) {
            progressView.setProgress(Float(progressValue / 100), animated: true)
        }
        
        // Add pulse animation for time update
        UIView.animate(withDuration: 0.3, animations: {
            self.timeLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.timeLabel.transform = .identity
            }
        }
    }
}
