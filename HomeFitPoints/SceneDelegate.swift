//
//  SceneDelegate.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 18/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private var noConnectionVC: NoConnectionViewController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor(red: 1.00, green: 0.48, blue: 0.00, alpha: 1.00)
        
        let homeVC = HomeExercisesViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "home_title", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let progressVC = ProgressViewController()
        let progressNav = UINavigationController(rootViewController: progressVC)
        progressNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("progress_title", comment: ""),
            image: UIImage(systemName: "chart.bar.fill"),
            tag: 1
        )
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: NSLocalizedString("profile_title", comment: ""), image: UIImage(systemName: "person.fill"), tag: 2)
        
        tabBarController.viewControllers = [homeNav, progressNav, profileNav]
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        
        setupConnectivityObserver()
    }
    
    private func setupConnectivityObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityChanged),
            name: .connectivityStatusChanged,
            object: nil
        )
    }
    
    @objc private func connectivityChanged() {
        let isConnected = ConnectivityService.shared.isConnected
        
        if !isConnected {
            showNoConnectionScreen()
        } else {
            hideNoConnectionScreen()
        }
    }
    
    private func showNoConnectionScreen() {
        guard noConnectionVC == nil else { return }
        
        let vc = NoConnectionViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        vc.onRetry = { [weak self] in
            if ConnectivityService.shared.isConnected {
                self?.hideNoConnectionScreen()
            }
        }
        
        if let topController = getTopViewController() {
            topController.present(vc, animated: true)
            self.noConnectionVC = vc
        }
    }
    
    private func hideNoConnectionScreen() {
        if let vc = noConnectionVC {
            vc.dismiss(animated: true)
            self.noConnectionVC = nil
        }
    }
    
    private func getTopViewController(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? window?.rootViewController
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        NotificationCenter.default.removeObserver(self)
    }
}

