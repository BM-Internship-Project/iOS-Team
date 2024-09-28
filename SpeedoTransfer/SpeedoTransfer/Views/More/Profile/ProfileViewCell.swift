//
//  ProfileViewCell.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let identifier = "ProfileViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)

    // MARK: - IBOutlet
    @IBOutlet var prefixImageView: UIImageView!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    func configureCell(profileItem: ListItem){
        titleLabel.text = profileItem.title
        subTitleLabel.text = profileItem.subTitle
        prefixImageView.image = profileItem.prefixImage
        
    }
    
}
