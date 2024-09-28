//
//  FavoriteViewCell.swift
//  Registration
//
//  Created by Merna Islam on 08/09/2024.
//

import UIKit

class FavoriteSheetViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let identifier = "FavoriteSheetViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)

    // MARK: - IBOutlet
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var accountNumberLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Methods
    func configureCell(favorite: FavoriteModel){
        self.nameLabel.text = favorite.recipientName
        self.accountNumberLabel.text = favorite.recipientAccountNumber
    }
}
