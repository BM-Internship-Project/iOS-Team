//
//  CustomDelegate.swift
//  Registration
//
//  Created by Merna Islam on 07/09/2024.
//

import UIKit

protocol CustomCellDelegate: AnyObject {
    var transferAmount: Double { get set }
    func goToCell(in cell: UICollectionViewCell, next: Bool)
    func animateStepColorChange(step: Int)
    func goToHome()
    func showMessage(title: String, message: String)
}
