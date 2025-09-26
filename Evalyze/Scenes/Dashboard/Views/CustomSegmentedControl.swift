//
//  CustomSegmentedControl.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func didSelectSegment(at index: Int)
}

final class CustomSegmentedControl: UIView {
    // MARK: UI Properties
    private let stackView: UIStackView = UIStackView()
    private let selectionOval: UIView = UIView()
    private var segmentButtons: [UIButton] = []
    
    // MARK: Properties
    weak var delegate: CustomSegmentedControlDelegate?
    private var selectedIndex: Int = 0
    private var segments: [String] = []
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func configure(segments: [String], selectedIndex: Int = 0) {
        self.segments = segments
        self.selectedIndex = selectedIndex
        setupSegments()
        updateSelection(animated: false)
    }
    
    func selectSegment(at index: Int, animated: Bool = true) {
        guard index >= 0 && index < segments.count else { return }
        selectedIndex = index
        updateSelection(animated: animated)
        delegate?.didSelectSegment(at: index)
    }
    
    // MARK: Private Methods
    private func configureUI() {
        backgroundColor = .clear
        
        // Configure stack view first (so it's on top)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.pin(to: self)
        
        // Configure selection oval (so it's behind)
        selectionOval.backgroundColor = UIColor.blueAccent.withAlphaComponent(0.3)
        selectionOval.layer.cornerRadius = 16
        addSubview(selectionOval)
        selectionOval.translatesAutoresizingMaskIntoConstraints = false
        
        // Send oval to back
        sendSubviewToBack(selectionOval)
    }
    
    private func setupSegments() {
        // Remove existing buttons
        segmentButtons.forEach { $0.removeFromSuperview() }
        segmentButtons.removeAll()
        
        // Create new buttons
        for (index, segment) in segments.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(segment, for: .normal)
            button.setTitleColor(.secondaryTextColor, for: .normal)
            button.setTitleColor(.blueAccent, for: .selected)
            button.titleLabel?.setCustomFont(.sansRegular, size: 16)
            button.backgroundColor = .clear
            button.tag = index
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            
            // Remove all button highlighting
            button.adjustsImageWhenHighlighted = false
            button.adjustsImageWhenDisabled = false
            button.showsTouchWhenHighlighted = false
            
            segmentButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func segmentTapped(_ sender: UIButton) {
        selectSegment(at: sender.tag, animated: true)
    }
    
    private func updateSelection(animated: Bool) {
        guard selectedIndex < segmentButtons.count else { return }
        let selectedButton = segmentButtons[selectedIndex]
        
        if animated {
            // First fade out the oval
            UIView.animate(withDuration: 0.15, animations: {
                self.selectionOval.alpha = 0
            }) { _ in
                // Move to new position (no animation)
                self.updateOvalConstraints(for: selectedButton)
                self.layoutIfNeeded()
                
                // Update button states
                for (index, button) in self.segmentButtons.enumerated() {
                    button.isSelected = (index == self.selectedIndex)
                }
                
                // Fade in at new position
                UIView.animate(withDuration: 0.15) {
                    self.selectionOval.alpha = 1
                }
            }
        } else {
            // Update button states
            for (index, button) in segmentButtons.enumerated() {
                button.isSelected = (index == selectedIndex)
            }
            updateOvalConstraints(for: selectedButton)
            selectionOval.alpha = 1
        }
    }
    
    private func updateOvalConstraints(for button: UIButton) {
        // Remove existing constraints
        selectionOval.removeFromSuperview()
        addSubview(selectionOval)
        selectionOval.translatesAutoresizingMaskIntoConstraints = false
        
        // Send oval to back
        sendSubviewToBack(selectionOval)
        
        // Add new constraints - oval should match button size exactly
        NSLayoutConstraint.activate([
            selectionOval.topAnchor.constraint(equalTo: button.topAnchor),
            selectionOval.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            selectionOval.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            selectionOval.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
    }
}
