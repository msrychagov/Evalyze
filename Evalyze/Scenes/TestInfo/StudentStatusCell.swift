import UIKit

final class StudentStatusCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .mainTextColor
        return label
    }()
    
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryTextColor
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .lightGrayApp
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        return progressView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .grayApp
        self.contentView.backgroundColor = .grayApp
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let leftStack = UIStackView(arrangedSubviews: [nameLabel, groupLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2
        leftStack.alignment = .leading
        
        let rightStack = UIStackView(arrangedSubviews: [statusLabel, progressLabel, timeLabel])
        rightStack.axis = .vertical
        rightStack.spacing = 2
        rightStack.alignment = .trailing
        
        let mainStack = UIStackView(arrangedSubviews: [leftStack, rightStack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fillEqually
        mainStack.alignment = .center
        
        contentView.addSubview(mainStack)
        contentView.addSubview(progressView)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    func configure(with studentStatus: StudentStatusDisplay) {
        nameLabel.text = studentStatus.name
        groupLabel.text = studentStatus.group
        statusLabel.text = studentStatus.status
        statusLabel.textColor = studentStatus.statusColor
        progressLabel.text = studentStatus.progress
        timeLabel.text = studentStatus.timeSpent
        
        progressView.progressTintColor = studentStatus.statusColor
        progressView.setProgress(Float(studentStatus.progressPercentage), animated: false)
        
        // Visual feedback based on status
        contentView.backgroundColor = studentStatus.statusColor.withAlphaComponent(0.1)
    }
}
