//
//  ExamProtectionManager.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 26.09.2025.
//

import UIKit

final class ExamProtectionManager {
    private weak var targetView: UIView?
    private var blurView: UIVisualEffectView?
    private var onScreenshot: (() -> Void)?

    init(targetView: UIView, onScreenshot: (() -> Void)? = nil) {
        self.targetView = targetView
        self.onScreenshot = onScreenshot
        setupObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDidTakeScreenshot),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenCaptureChanged),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIScene.didActivateNotification,
            object: nil
        )

        handleScreenCapture(isCaptured: UIScreen.main.isCaptured)
    }

    // MARK: - Handlers
    @objc private func userDidTakeScreenshot() {
        print("Screenshot detected!!!")
        DispatchQueue.main.async { [weak self] in
            self?.onScreenshot?()
        }
    }

    @objc private func screenCaptureChanged() {
        handleScreenCapture(isCaptured: UIScreen.main.isCaptured)
    }

    private func handleScreenCapture(isCaptured: Bool) {
        if isCaptured {
            print("Screen recording detected!!!")
            showBlur()
        } else {
            removeBlur()
        }
    }

    @objc private func appDidBecomeActive() {
        if UIScreen.main.isCaptured {
            showBlur()
        } else {
            removeBlur()
        }
    }

    // MARK: - Blur helpers
    func showBlur() {
        guard let view = targetView, blurView == nil else { return }
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = view.bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.tag = 9999
        blurView = blur
        view.addSubview(blur)
    }

    func removeBlur() {
        blurView?.removeFromSuperview()
        blurView = nil
    }
}
