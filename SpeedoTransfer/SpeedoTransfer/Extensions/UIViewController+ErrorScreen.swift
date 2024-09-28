//
//  UIViewController+ErrorScreen.swift
//  SpeedoTransfer
//
//  Created by Merna Islam on 15/09/2024.
//

import UIKit

extension UIViewController {
    func goToErrorScreen() {
        self.navigationController?.pushViewController(ServerErrorVC(), animated: true)
    }
}
