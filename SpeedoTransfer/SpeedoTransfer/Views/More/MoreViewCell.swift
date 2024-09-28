//
//  MoreViewCell.swift
//  Registration
//
//  Created by Merna Islam on 09/09/2024.
//

import UIKit

class MoreViewCell: UITableViewCell {
    
    // MARK: - Static Properities
    static let identifier = "MoreViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)

    // MARK: - IBOutlet
    @IBOutlet var separatorView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var prefixICon: UIImageView!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Methods
    func configureCell(i: Int){
        self.prefixICon.image = moreItems[i].prefixImage
        self.titleLabel.text = moreItems[i].title
        if i == moreItems.count - 1{
            self.separatorView.backgroundColor = .clear
        }
    }
    
}
