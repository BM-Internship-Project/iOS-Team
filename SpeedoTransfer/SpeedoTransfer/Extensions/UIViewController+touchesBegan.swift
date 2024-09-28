//
//  UIViewController+touchesBegan.swift
//  SpeedoTransfer
//
//  Created by Merna Islam on 14/09/2024.
//

import UIKit

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.inactivityManager.userDidInteract()
        }
    }
}
