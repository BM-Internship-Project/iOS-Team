//
//  UIViewController+NavigationBar.swift
//  Registration
//
//  Created by Merna Islam on 06/09/2024.
//

import UIKit

extension UIViewController {
        
    func setupNavigationBar(title: String?, selector: Selector?) {
        
        if let text = title {
            self.navigationItem.title = text
        }
        
        self.setupNavigationBorder()
        
        if let action = selector {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: action)
            backButton.tintColor = .black
            self.navigationItem.leftBarButtonItem = backButton
        }
        
    }
    
    func setupNavigationBorder(){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // For iOS 12 and below
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.backgroundColor = .clear
        }
    }
}


