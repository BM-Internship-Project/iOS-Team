//
//  InternetErrorVC.swift
//  Registration
//
//  Created by Malak Mohamed on 09/09/2024.
//

import UIKit

class InternetErrorVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyGradientBgWhiteToRed()
        self.setupNavigationBar(title: "", selector: nil)
    }
 
    @IBAction func UpdateButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

 
