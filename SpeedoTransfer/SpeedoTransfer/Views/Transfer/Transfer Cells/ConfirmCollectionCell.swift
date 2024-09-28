//
//  ConfirmCollectionCell.swift
//  Registration
//
//  Created by Merna Islam on 06/09/2024.
//

import UIKit

class ConfirmCollectionCell: UICollectionViewCell {

    // MARK: - Static Properties
    static let identifier = "ConfirmCollectionCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Properities
    var amount: Double? {
        didSet {
            fillDetails()
        }
    }
    var delegate: CustomCellDelegate?

    // MARK: - IBOutlet
    @IBOutlet var cellView: UIView!
    @IBOutlet var transferAmount: UILabel!
    @IBOutlet var totalAmount: UILabel!
    @IBOutlet var senderName: UILabel!
    @IBOutlet var senderAccountNum: UILabel!
    @IBOutlet var receiverName: UILabel!
    @IBOutlet var receiverAccountNum: UILabel!
    @IBOutlet var previousBtn: UIButton!
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.previousBtn.layer.borderColor = AppColors.primaryColor.cgColor
        self.previousBtn.layer.borderWidth = 1.5
        self.previousBtn.layer.cornerRadius = 5
    }
    
    // MARK: - Private Methods
    private func fillDetails(){
        self.transferAmount.text = "\(Int(amount!)) EGP"
        self.totalAmount.text = "\(Int(amount!)) EGP"
        self.senderName.text = currentTransaction!.senderAccount.name
        self.senderAccountNum.text = currentTransaction!.senderAccount.accountNumber
        self.receiverName.text = currentTransaction!.receiverAccount.name
        self.receiverAccountNum.text = currentTransaction!.receiverAccount.accountNumber
        
    }
    
    private func sendNotifications(){
        let content = UNMutableNotificationContent()
        content.title = "Successful Transaction"
        content.body = "You have sent money to \(currentTransaction!.receiverAccount.name)"
        content.sound = .default
        content.badge = 0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(1),
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testID", content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - API Methods
    private func transfer(){
        APIManager.shared().transfer(to: receiverAccountNum.text!, amount: amount!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    return
                case .failure(let error):
                    return
                }
            }
        }
    }

    // MARK: - IBAction
    @IBAction func confirmBtnTapped(_ sender: Any) {
        self.transfer()
        delegate?.goToCell(in: self, next: true)
        delegate?.animateStepColorChange(step: 3)
        shouldUpdateHomeTransactions = true
        shouldUpdateTransactionsScreen = true
        if canSendNotifications {
            self.sendNotifications()
        }
    }
    
    @IBAction func previousBtnTapped(_ sender: Any) {
        delegate?.goToCell(in: self, next: false)
        delegate?.animateStepColorChange(step: -1)
    }
}
