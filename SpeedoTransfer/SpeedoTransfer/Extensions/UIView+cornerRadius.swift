//
//  UIView+cornerRadius.swift
//  Registration
//
//  Created by Merna Islam on 29/08/2024.
//

import UIKit


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set { self.layer.cornerRadius = newValue}
    }
}
