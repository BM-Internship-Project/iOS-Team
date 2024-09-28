//
//  TransactionsViewCell.swift
//  Registration
//
//  Created by Merna Islam on 04/09/2024.
//

import UIKit

class TransactionsViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let identifier = "TransactionsViewCell"
    static let nib = UINib(nibName: "TransactionsViewCell", bundle: nil)
    
    // MARK: - IBOutlet
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var receivedOrSentLabel: UILabel!
    @IBOutlet var visaDetails: UILabel!
    @IBOutlet var cellView: UIView!
    
    // MARK: - Lifecycle Methods
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
            self.receivedOrSentLabel.text = "- Sent"
            self.nameLabel.text = transaction.receiverAccount.name
            accNum = transaction.receiverAccount.accountNumber
        } else {
            self.receivedOrSentLabel.text = "- Received"
            self.nameLabel.text = transaction.senderAccount.name
            accNum = transaction.senderAccount.accountNumber
        }
        let lastFourDigits = String(accNum.suffix(4))
        self.visaDetails.text = "Visa . Master Card . \(lastFourDigits)"
        self.dateLabel.text = transaction.formatDayTime()
        self.amountLabel.text = "\(Int(transaction.amount)) EGP"
    }
    
    func configureCell(transaction: TransactionModel){
        checkSenderOrReceiver(transaction: transaction)
    }
    
}
