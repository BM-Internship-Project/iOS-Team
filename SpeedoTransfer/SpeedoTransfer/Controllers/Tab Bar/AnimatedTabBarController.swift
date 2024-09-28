///
///  AnimatedTabBarController.swift
///  Registration
///
///  Created by Merna Islam on 03/09/2024.
///
import RAMAnimatedTabBarController
import UIKit


class AnimatedTabBarController: RAMAnimatedTabBarController {
    
    // MARK: - Properties
    var homeNavigation: UINavigationController!
    var transferNavigation: UINavigationController!
    var transactionNavigation: UINavigationController!
    var cardNavigation: UINavigationController!
    var moreNavigation: UINavigationController!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewControllers()
        self.setupTabBar()
    }
}

// MARK: - Private Methods
extension AnimatedTabBarController {
    
    private func setupTabBar(){
        self.tabBar.tintColor = AppColors.primaryColor
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.backgroundColor = UIColor.white.cgColor
        self.viewControllers = [homeNavigation, transferNavigation, transactionNavigation, cardNavigation, moreNavigation]
    }
    
    // MARK: - Controllers Setup
    private func setupViewControllers(){
        self.setupHomeTab()
        self.setupTransferTab()
        self.setupTransactionTab()
        self.setupCardTab()
        self.setupMoreTab()
    }
    
    private func setupHomeTab(){
        let homeVC = HomeVC()
        homeVC.tabSwitchDelegate = self
        self.homeNavigation = UINavigationController(rootViewController: homeVC)
        self.homeNavigation.tabBarItem = customAnimatedTabBar(title: "Home", image: UIImage(named: "Home"), tag: 0, animation: RAMBounceAnimation())
    }
    
    private func setupTransferTab(){
        let transferVC = TransferVC()
        transferVC.tabSwitchDelegate = self
        self.transferNavigation = UINavigationController(rootViewController: transferVC)
        self.transferNavigation.tabBarItem = customAnimatedTabBar(title: "Transfer", image: UIImage(named: "Transfer"), tag: 1, animation: RAMRotationAnimation())
        
    }
    
    private func setupTransactionTab(){
        let transactionVC = TransactionsVC()
        transactionVC.tabSwitchDelegate = self
        self.transactionNavigation = UINavigationController(rootViewController: transactionVC)
        self.transactionNavigation.tabBarItem = customAnimatedTabBar(title: "Transactions", image: UIImage(named: "Transactions"), tag: 2, animation: RAMBounceAnimation())
    }

    private func setupCardTab(){
        self.cardNavigation = UINavigationController(rootViewController: UIViewController())
        self.cardNavigation.tabBarItem = customAnimatedTabBar(title: "My Cards", image: UIImage(named: "My Cards"), tag: 3, animation: RAMRightRotationAnimation())
    }
    
    private func setupMoreTab(){
        let moreVC = MoreVC()
        moreVC.tabSwitchDelegate = self
        self.moreNavigation = UINavigationController(rootViewController: moreVC)
        
        self.moreNavigation.tabBarItem = customAnimatedTabBar(title: "More", image: UIImage(named: "More"), tag: 4, animation: RAMBounceAnimation())
    }
    
    // MARK: - RAMAnimatedTabBarItem
    private func customAnimatedTabBar(title: String, image: UIImage?, tag: Int, animation: RAMItemAnimation) -> RAMAnimatedTabBarItem{
        
        let item = RAMAnimatedTabBarItem(title: title, image: image, tag: tag)
        animation.textSelectedColor = AppColors.primaryColor
        
        item.animation = animation
        item.textFontSize = 12
        
        item.textColor = .darkGray
        item.iconColor = .darkGray
                        
        return item
    }
}

// MARK: - TabSwitchProtocol Extension
extension AnimatedTabBarController: TabSwitchProtocol{
    func deselectAnimation(){
        if let items = self.tabBar.items as? [RAMAnimatedTabBarItem?], let previousSelectedItem = items[self.selectedIndex] {
            previousSelectedItem.deselectAnimation()
        }
    }
    
    func playAnimation(){
        if let items = self.tabBar.items as? [RAMAnimatedTabBarItem?], let selectedItem = items[self.selectedIndex] {
            selectedItem.playAnimation()
        }
    }
    
    func switchToTransferTab() {
        self.deselectAnimation()
        self.selectedIndex = 1
        self.playAnimation()
    }
    
    func switchToHomeTab(){
        self.deselectAnimation()
        self.selectedIndex = 0
        self.playAnimation()
    }
    
    func switchToTransactionTab(){
        self.deselectAnimation()
        self.selectedIndex = 2
        self.playAnimation()
    }
}
