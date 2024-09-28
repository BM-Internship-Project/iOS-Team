//
//  HomeEmptyTransactionCell.swift
//  Registration
//
//  Created by Merna Islam on 11/09/2024.
//

import UIKit

class HomeEmptyTransactionCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let identifier = "HomeEmptyTransactionCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Properties
    var delegate: TransferVCDelegate!

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBAction
    @IBAction func transferBTntapped(_ sender: UIButton) {
        delegate?.goToTransfer()
    }
}
