//
//  AppColors.swift
//  Registration
//
//  Created by Merna Islam on 28/08/2024.
//

import Foundation
import UIKit

struct AppColors {
    static let darkRed = UIColor(red: 82/255, green: 18/255, blue: 32/255, alpha: 1.0)
    static let primaryColor = UIColor(red: 135/255, green: 30/255, blue: 53/255, alpha: 1.0)
    static let white = UIColor(white: 1, alpha: 1)
    static let lightRed = UIColor(red: 1, green: 234/255, blue: 238/255, alpha: 1)
    static let lightYellow = UIColor(red: 1, green: 248/255, blue: 231/255, alpha: 1)
    static var whiteRedGradient: CAGradientLayer {
       let gl = CAGradientLayer()
       gl.colors = [white.cgColor, lightRed.cgColor]
        gl.locations = [0.0, 0.75]
       return gl
    }
    static var yellowRedGradient: CAGradientLayer {
       let gl = CAGradientLayer()
       gl.colors = [lightYellow.cgColor, lightRed.cgColor]
        gl.locations = [0.0, 1.0]
       return gl
    }
}


