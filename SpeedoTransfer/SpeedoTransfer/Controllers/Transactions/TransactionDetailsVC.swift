//
//  TransactionDetailsVC.swift
//  Registration
//
//  Created by Merna Islam on 06/09/2024.
//

import UIKit

class TransactionDetailsVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var senderName: UILabel!
    @IBOutlet var senderAccount: UILabel!
    @IBOutlet var receiverName: UILabel!
    @IBOutlet var receiverAccount: UILabel!
    @IBOutlet var amount: UILabel!
    @IBOutlet var transactionID: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var transaction: TransactionModel!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Successful Trasactions", selector: #selector(self.goBack))
        self.setupDetails()
    }
    
    // MARK: - Private Methods
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupDetails(){
        amountLabel.text = "EGP \(transaction.amount)"
        senderName.text = transaction.senderAccount.name
        senderAccount.text = transaction.senderAccount.accountNumber
        receiverName.text = transaction.receiverAccount.name
        receiverAccount.text = transaction.receiverAccount.accountNumber
        amount.text = "EGP \(transaction.amount)"
        transactionID.text = "\(transaction.id)"
        dateLabel.text = transaction.formatDayTime()
    }

}
