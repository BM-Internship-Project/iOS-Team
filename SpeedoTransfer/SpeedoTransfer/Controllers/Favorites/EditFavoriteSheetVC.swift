//
//  EditFavorite.swift
//  Registration
//
//  Created by Merna Islam on 09/09/2024.
//

import UIKit

class EditFavoriteSheetVC: UIViewController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSheet()
    }
    
    // MARK: - Private Methods
    private func createSheet(){
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 50
        }
    }
    

}
