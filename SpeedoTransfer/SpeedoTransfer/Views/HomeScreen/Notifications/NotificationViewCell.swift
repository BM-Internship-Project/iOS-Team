//
//  NotificationViewCell.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class NotificationViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet var notificationBody: UILabel!
    @IBOutlet var notificationDate: UILabel!
    @IBOutlet var iconView: UIView!
    
    // MARK: - Static Properties
    static let identifier = "NotificationViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupIconView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Methods
    func configureCell(transaction: TransactionModel){
        self.notificationBody.text = "You have sent \(transaction.amount) EGP to \(transaction.receiverAccount.name)"
        self.notificationDate.text = transaction.formatFullDatetime()
    }
    
    func setupIconView(){
        self.iconView.layer.shadowColor = UIColor.systemGray2.cgColor
        self.iconView.layer.shadowOpacity = 1
        self.iconView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.iconView.layer.shadowRadius = 1
        self.iconView.layer.shouldRasterize = true
        self.iconView.layer.rasterizationScale = UIScreen.main.scale
    }
}
