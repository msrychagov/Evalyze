import UIKit

final class StudentCell: UITableViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = UIColor.mainTextColor
        return label
    }()
    
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryTextColor
        return label
    }()
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .systemBlue
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(selectionIndicator)
        contentView.addSubview(nameLabel)
        contentView.addSubview(groupLabel)
        
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            selectionIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 8),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 8),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: selectionIndicator.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            groupLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            groupLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            groupLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            groupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with studentDisplay: StudentDisplay) {
        nameLabel.text = studentDisplay.name
        groupLabel.text = studentDisplay.group
        selectionIndicator.isHidden = studentDisplay.isSelected
        accessoryType = studentDisplay.isSelected ? .checkmark : .none
    }
}
