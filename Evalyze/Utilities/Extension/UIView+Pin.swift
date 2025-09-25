//
//  UIView+Pin.swift
//  Evalyze
//
//  Created by Артём on 22.09.2025.
//

import UIKit

// MARK: - Pin methods
/// Will throw exceptions when there is no common superview between constrained views.
extension UIView {
    enum ConstraintMode {
        case equal
        /// greaterOrEqual
        case grOE
        /// lessOrEqual
        case lsOE
    }
    
    enum PinSides {
        case top, bottom, left, right
    }
    
    // MARK: - Pin left
    @discardableResult
    /// Creates and activates a constraint from views leadingAnchor to otherView's leadingAnchor.
    final func pinLeft(
        to otherView: UIView,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, leadingAnchor, otherView.leadingAnchor, constant: const)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views leadingAnchor to a given xAxisAnchor.
    final func pinLeft(
        to anchor: NSLayoutXAxisAnchor,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, leadingAnchor, anchor, constant: const)
    }
    
    // MARK: - Pin right
    @discardableResult
    /// Creates and activates a constraint from views trailingAnchor to otherView's trailingAnchor.
    final func pinRight(
        to otherView: UIView,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, trailingAnchor, otherView.trailingAnchor, constant: -1 * const)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views trailingAnchor to a given xAxisAnchor.
    final func pinRight(
        to anchor: NSLayoutXAxisAnchor,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, trailingAnchor, anchor, constant: -1 * const)
    }
    
    // MARK: - Pin top
    @discardableResult
    /// Creates and activates a constraint from views topAnchor to otherView's topAnchor.
    final func pinTop(
        to otherView: UIView,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, topAnchor, otherView.topAnchor, constant: const)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views topAnchor to a given xAxisAnchor.
    final func pinTop(
        to anchor: NSLayoutYAxisAnchor,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, topAnchor, anchor, constant: const)
    }
    
    // MARK: - Pin bottom
    @discardableResult
    /// Creates and activates a constraint from views bottomAnchor to otherView's bottomAnchor.
    final func pinBottom(
        to otherView: UIView,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, bottomAnchor, otherView.bottomAnchor, constant: -1 * const)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views bottomAnchor to a given xAxisAnchor.
    final func pinBottom(
        to anchor: NSLayoutYAxisAnchor,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, bottomAnchor, anchor, constant: -1 * const)
    }
    
    // MARK: - Pin center
    /// Creates and activates a constraint from views centerXAnchor to otherView's centerXAnchor.
    final func pinCenter(to otherView: UIView) {
        pinConstraint(mode: .equal, centerXAnchor, otherView.centerXAnchor)
        pinConstraint(mode: .equal, centerYAnchor, otherView.centerYAnchor)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views centerXAnchor to otherView's centerXAnchor.
    final func pinCenterX(
        to otherView: UIView,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, centerXAnchor, otherView.centerXAnchor, constant: const)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views centerXAnchor to a given xAxisAnchor.
    final func pinCenterX(
        to anchor: NSLayoutXAxisAnchor,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, centerXAnchor, anchor, constant: const)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views centerYAnchor to otherView's centerYAnchor.
    final func pinCenterY(
        to otherView: UIView,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, centerYAnchor, otherView.centerYAnchor, constant: const)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views centerYAnchor to a given yAxisAnchor.
    final func pinCenterY(
        to anchor: NSLayoutYAxisAnchor,
        _ const: Double = 0,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinConstraint(mode: mode, centerYAnchor, anchor, constant: const)
    }
    
    // MARK: - Pin width
    @discardableResult
    /// Creates and activates a constraint from views widthAnchor to otherView's widthAnchor.
    final func pinWidth(
        to otherView: UIView,
        _ mult: Double = 1,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinDimension(mode: mode, widthAnchor, otherView.widthAnchor, multiplier: mult)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views widthAnchor to a given NSLayoutDimension.
    final func pinWidth(
        to anchor: NSLayoutDimension,
        _ mult: Double = 1,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinDimension(mode: mode, widthAnchor, anchor, multiplier: mult)
    }
    
    @discardableResult
    final func setWidth(mode: ConstraintMode = .equal, _ const: Double) -> NSLayoutConstraint {
        pinDimension(mode: mode, widthAnchor, constant: const)
    }
    
    // MARK: - Pin height
    @discardableResult
    /// Creates and activates a constraint from views heightAnchor to otherView's heightAnchor.
    final func pinHeight(
        to otherView: UIView,
        _ mult: Double = 1,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinDimension(mode: mode, heightAnchor, otherView.heightAnchor, multiplier: mult)
    }
    
    @discardableResult
    /// Creates and activates a constraint from views heightAnchor to a given NSLayoutDimension.
    final func pinHeight(
        to dimension: NSLayoutDimension,
        _ mult: Double = 1,
        _ mode: ConstraintMode = .equal
    ) -> NSLayoutConstraint {
        pinDimension(mode: mode, heightAnchor, dimension, multiplier: mult)
    }
    
    @discardableResult
    final func setHeight(mode: ConstraintMode = .equal, _ const: Double) -> NSLayoutConstraint {
        pinDimension(mode: mode, heightAnchor, constant: const)
    }
    
    // MARK: - Pin utilities
    final func pinHorizontal(
        to otherView: UIView,
        _ const: Double = 0,
        mode: ConstraintMode = .equal
    ) {
        pinLeft(to: otherView, const, mode)
        pinRight(to: otherView, const, mode)
    }
    
    final func pinHorizontal(
        to layoutGuide: UILayoutGuide,
        _ const: Double = 0,
        mode: ConstraintMode = .equal
    ) {
        pinLeft(to: layoutGuide.leadingAnchor, const, mode)
        pinRight(to: layoutGuide.trailingAnchor, const, mode)
    }
    
    final func pinVertical(
        to otherView: UIView,
        _ const: Double = 0,
        mode: ConstraintMode = .equal
    ) {
        pinTop(to: otherView, const, mode)
        pinBottom(to: otherView, const, mode)
    }
    
    final func pinVertical(
        to layoutGuide: UILayoutGuide,
        _ const: Double = 0,
        mode: ConstraintMode = .equal
    ) {
        pinTop(to: layoutGuide.topAnchor, const, mode)
        pinBottom(to: layoutGuide.bottomAnchor, const, mode)
    }
    
    final func pin(to otherView: UIView, _ const: Double = 0) {
        pinVertical(to: otherView, const)
        pinHorizontal(to: otherView, const)
    }
    
    final func pin(to layoutGuide: UILayoutGuide, _ const: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: const),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -const),
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: const),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -const)
        ])
    }
    
    // MARK: - Private methods
    @discardableResult
    private final func pinConstraint<Axis: AnyObject, AnyAnchor: NSLayoutAnchor<Axis>>(
        mode: ConstraintMode,
        _ firstAnchor: AnyAnchor,
        _ secondAnchor: AnyAnchor,
        constant: Double = 0
    ) -> NSLayoutConstraint {
        let const = CGFloat(constant)
        let result: NSLayoutConstraint
        translatesAutoresizingMaskIntoConstraints = false
        switch mode {
        case .equal:
            result = firstAnchor.constraint(equalTo: secondAnchor, constant: const)
        case .grOE:
            result = firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: const)
        case .lsOE:
            result = firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: const)
        }
        
        result.isActive = true
        return result
    }
    
    @discardableResult
    private final func pinDimension(
        mode: ConstraintMode,
        _ firstDimension: NSLayoutDimension,
        _ secondDimension: NSLayoutDimension,
        multiplier: Double = 1
    ) -> NSLayoutConstraint {
        let mult = CGFloat(multiplier)
        let result: NSLayoutConstraint
        translatesAutoresizingMaskIntoConstraints = false
        switch mode {
        case .equal:
            result = firstDimension.constraint(equalTo: secondDimension, multiplier: mult)
        case .grOE:
            result = firstDimension.constraint(greaterThanOrEqualTo: secondDimension, multiplier: mult)
        case .lsOE:
            result = firstDimension.constraint(lessThanOrEqualTo: secondDimension, multiplier: mult)
        }
        
        result.isActive = true
        return result
    }
    
    @discardableResult
    private final func pinDimension(
        mode: ConstraintMode,
        _ dimension: NSLayoutDimension,
        constant: Double
    ) -> NSLayoutConstraint {
        let const = CGFloat(constant)
        let result: NSLayoutConstraint
        translatesAutoresizingMaskIntoConstraints = false
        switch mode {
        case .equal:
            result = dimension.constraint(equalToConstant: const)
        case .grOE:
            result = dimension.constraint(greaterThanOrEqualToConstant: const)
        case .lsOE:
            result = dimension.constraint(lessThanOrEqualToConstant: const)
        }
        
        result.isActive = true
        return result
    }
}
