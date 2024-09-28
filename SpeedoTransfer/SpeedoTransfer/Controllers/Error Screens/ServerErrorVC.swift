//
//  ServerErrorVC.swift
//  Registration
//
//  Created by Malak Mohamed on 09/09/2024.
//

import UIKit

class ServerErrorVC: UIViewController {

    @IBOutlet weak var MessageUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyGradientBgWhiteToRed()
        self.setupNavigationBar(title: "", selector: nil)
        MessageUsButton.layer.borderWidth = 1.5
    }

}
