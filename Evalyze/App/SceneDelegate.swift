//
//  SceneDelegate.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 20.09.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow()
        window.windowScene = windowScene
        
        // Проверяем, есть ли сохраненный пользователь в UserDefaults
        if let savedUser = UserManager.shared.getCurrentUser() {
            print("Found saved user: \(savedUser.fullName) - showing dashboard")
            // Показываем dashboard, если пользователь уже залогинен
            let dashboardVC = DashboardViewController()
            let navigationController = UINavigationController(rootViewController: dashboardVC)
            window.rootViewController = navigationController
        } else {
            print("No saved user found - showing authentication")
            // Показываем экран аутентификации
            let authViewController = AuthenticationAssembly.createModule()
            window.rootViewController = authViewController
        }
        
        window.overrideUserInterfaceStyle = .dark
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        window?.viewWithTag(9999)?.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = window?.bounds ?? .zero
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 9999
        window?.addSubview(blurView)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
