//
//  AppDelegate.swift
//  Registration
//
//  Created by Malak Mohamed on 27/08/2024.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var inactivityManager = InactivityManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initializeApp()
        NetworkMonitor.shared.startMonitoring()
        
        return true
    }
    
    private func initializeApp(){
        window = UIWindow(frame: UIScreen.main.bounds)
        UNUserNotificationCenter.current().delegate = self
        askNotificationPermission()
      
        IQKeyboardManager.shared.enable = true
        navBarSetup()
        
        let isFirstOpen = UserDefaultsManager.shared().isFirstOpen
        
        if isFirstOpen {
            self.showOnBoardingScreen()
        } else {
            self.checkIfUserIsLoggedIn()
        }
        
        window?.makeKeyAndVisible()

        
    }
    
    func navBarSetup() {
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .light)
            ]
            navigationBarAppearance.backgroundColor = UIColor.clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }

}

// MARK: - Navigation Extension
extension AppDelegate {
    func switchToStoryboardScreen(storyboardName: String, identifier: String){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        window?.rootViewController = initialViewController
    }
    
    func showOnBoardingScreen() {
        self.switchToStoryboardScreen(storyboardName: Storyboard.OnBoardingScreen, identifier: ViewControllersID.OnBoarding)
    }

    func switchToRegisterScreen() {
        self.switchToStoryboardScreen(storyboardName: Storyboard.Main, identifier: ViewControllersID.SignUp)
    }
       
    func switchToLoginScreen() {
        self.switchToStoryboardScreen(storyboardName: Storyboard.Main, identifier: ViewControllersID.SignIn)
    }
    
    func switchToHomeScreen() {
        guard let window = UIApplication.shared.delegate?.window else { return }
        
        let initialViewController = AnimatedTabBarController()
        
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = initialViewController
        }, completion: nil)
    }
    
    func switchToNotificationsScreen() {
        guard let window = UIApplication.shared.delegate?.window else { return }
        
        let initialViewController = AnimatedTabBarController()
        
        window?.rootViewController = initialViewController
        if let homeNavigationController = initialViewController.viewControllers?[0] as? UINavigationController {
            homeNavigationController.pushViewController(NotificationVC(), animated: true)
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if UserDefaultsManager.shared().isLoggedIn {
            switchToLoginScreen()
        } else {
            switchToRegisterScreen()
        }
    }
}

// MARK: - Notifications Extension
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.switchToNotificationsScreen()
    }
    
    func askNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound,
          .badge]) { granted, error in
            if granted {
                canSendNotifications = true
            }
        }
    }
}


// MARK: - Timeout Extension
extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        inactivityManager.startInactivityTimer()
    }
    
    func getTopMostViewController(from viewController: UIViewController) -> UIViewController {
        if let presentedVC = viewController.presentedViewController {
            return getTopMostViewController(from: presentedVC)
        } else if let navigationVC = viewController as? UINavigationController {
            return getTopMostViewController(from: navigationVC.visibleViewController ?? viewController)
        } else if let tabBarVC = viewController as? UITabBarController {
            return getTopMostViewController(from: tabBarVC.selectedViewController ?? viewController)
        } else {
            return viewController
        }
    }
    
    func switchToTimeOutScreen(){
        guard let window = self.window,
            let rootVC = window.rootViewController else {
            return
        }
        
        let topVC = getTopMostViewController(from: rootVC)

       if topVC is SignInVC || topVC is SignUpVC || topVC is OnBoardingVC || topVC is ContinueSignUpVC || topVC is TimeOutVC {
           return
       }
        
        let alertController = UIAlertController(title: "Session Timeout",
                                                message: "You have been inactive for 2 minutes.\n Please sign in again.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let timeOutVC = TimeOutVC()
            window.rootViewController = timeOutVC
            window.makeKeyAndVisible()
        }

        alertController.addAction(okAction)

        rootVC.present(alertController, animated: true)
    }
}


// MARK: - Network Monitor Extension
extension AppDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkMonitor.shared.stopMonitoring()
    }
}
