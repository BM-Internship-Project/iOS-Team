//
//  HomeTransactionCell.swift
//  Registration
//
//  Created by Merna Islam on 02/09/2024.
//

import UIKit

class HomeTransactionCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var visaDetails: UILabel!
    @IBOutlet var receivedOrSent: UILabel!
    
    // MARK: - Static Properities
    static var identifier: String = "HomeTransactionCell"
    static var nib: UINib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    private func checkSenderOrReceiver(transaction: TransactionModel){
        var accNum: String
        if currentUser.name == transaction.senderAccount.name {
            self.receivedOrSent.text = "- Sent"
            self.nameLabel.text = transaction.receiverAccount.name
            accNum = transaction.receiverAccount.accountNumber
        } else {
            self.receivedOrSent.text = "- Received"
            self.nameLabel.text = transaction.senderAccount.name
            accNum = transaction.senderAccount.accountNumber
        }
        let lastFourDigits = String(accNum.suffix(4))
        self.visaDetails.text = "Visa . Master Card . \(lastFourDigits)"
        self.dateLabel.text = transaction.formatDayTime()
        self.balanceLabel.text = "\(Int(transaction.amount)) EGP"
    }
    
    func configureCell(transaction: TransactionModel){
        self.checkSenderOrReceiver(transaction: transaction)
    }
    
}
