//
//  UIViewController+NetworkCheck.swift
//  SpeedoTransfer
//
//  Created by Merna Islam on 14/09/2024.
//

import UIKit

extension UIViewController {
    func checkNetworkAndProceed(apiCall: () -> Void) {
        if !NetworkMonitor.shared.isConnected {
            self.navigationController?.pushViewController(InternetErrorVC(), animated: true)
        } else {
            apiCall()
        }
    }
}
