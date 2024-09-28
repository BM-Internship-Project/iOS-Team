//
//  ProfileInfoViewCell.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class ProfileInfoViewCell: UITableViewCell {

    // MARK: - Static Properties
    static let identifier = "ProfileInfoViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - IBOutlet
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    func configureCell(detailItem: DetailItem) {
        titleLabel.text = detailItem.title
        subTitleLabel.text = detailItem.subTitle
    }
    
}
