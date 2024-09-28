//
//  HelpVC.swift
//  SpeedoTransfer
//
//  Created by Merna Islam on 14/09/2024.
//

import UIKit

class HelpVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var callView: UIView!
    @IBOutlet var emailView: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSheet()
        self.setupShadow()
    }
    
    // MARK: - Private Methods
    private func createSheet() {
        if let sheet = self.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let smallDetent = UISheetPresentationController.Detent.custom(resolver: { _ in
                    return 300
                })
                sheet.detents = [smallDetent]
                sheet.preferredCornerRadius = 50
                sheet.largestUndimmedDetentIdentifier = .medium
            } else {
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = 50
            }
        }

    }

    
    private func setupShadow(){
        callView.layer.shadowColor = UIColor.lightGray.cgColor
        callView.layer.shadowOpacity = 0.5
        callView.layer.shadowOffset = CGSize(width: 0, height: 0)
        callView.layer.shadowRadius = 1
        callView.layer.masksToBounds = false
        
        emailView.layer.shadowColor = UIColor.lightGray.cgColor
        emailView.layer.shadowOpacity = 0.5
        emailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        emailView.layer.shadowRadius = 1
        emailView.layer.masksToBounds = false
    }
}
