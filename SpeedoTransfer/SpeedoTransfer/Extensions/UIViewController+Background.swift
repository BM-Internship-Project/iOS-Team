//
//  UIViewController+BackgroundColor.swift
//  Registration
//
//  Created by Merna Islam on 03/09/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func applyGradientBgYellowToRed() {
        let gradientLayer = AppColors.yellowRedGradient
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradientBgWhiteToRed() {
        let gradientLayer = AppColors.whiteRedGradient
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
