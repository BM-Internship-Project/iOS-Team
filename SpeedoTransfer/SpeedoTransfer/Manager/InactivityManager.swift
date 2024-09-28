//
//  InactivityManager.swift
//  SpeedoTransfer
//
//  Created by Merna Islam on 14/09/2024.
//

import UIKit

class InactivityManager {
    var timer: Timer?
    private let timeoutInterval: TimeInterval = 120 // 2 minutes

    func startInactivityTimer() {
        resetTimer()
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timeoutInterval, target: self, selector: #selector(inactivityTimeout), userInfo: nil, repeats: false)
    }

    @objc private func inactivityTimeout() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.switchToTimeOutScreen()
    }

    func userDidInteract() {
        resetTimer()
    }
}

