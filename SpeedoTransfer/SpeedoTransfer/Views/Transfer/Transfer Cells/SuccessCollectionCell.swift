//
//  SuccessfulTransferCollectionCell.swift
//  Registration
//
//  Created by Merna Islam on 07/09/2024.
//

import UIKit

class SuccessCollectionCell: UICollectionViewCell {
    
    // MARK: - Static Properities
    static let identifier = "SuccessCollectionCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Properities
    var delegate: CustomCellDelegate?
    var amount: Double? {
        didSet {
            fillDetails()
        }
    }

    // MARK: - IBOutlet
    @IBOutlet var senderName: UILabel!
    @IBOutlet var senderAccountNum: UILabel!
    @IBOutlet var receiverName: UILabel!
    @IBOutlet var receiverAccountNum: UILabel!
    @IBOutlet var transferAmount: UILabel!
    @IBOutlet var addToFavoritesBtn: UIButton!
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addToFavoritesBtn.layer.borderColor = AppColors.primaryColor.cgColor
        self.addToFavoritesBtn.layer.borderWidth = 1.5
        self.addToFavoritesBtn.layer.cornerRadius = 5
    }
    
    // MARK: - Private Methods
    private func fillDetails(){
        self.transferAmount.text = "\(Int(amount!)) EGP"
        self.senderName.text = currentTransaction!.senderAccount.name
        self.senderAccountNum.text = currentTransaction!.senderAccount.accountNumber
        self.receiverName.text = currentTransaction!.receiverAccount.name
        self.receiverAccountNum.text = currentTransaction!.receiverAccount.accountNumber
    }
    
    // MARK: - API Methods
    private func addFavorite(){
        APIManager.shared().addFavorite(to: receiverName.text!, withAccount: receiverAccountNum.text!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.addToFavoritesBtn.setTitle("Add to Favorites", for: .normal)
                    self.addToFavoritesBtn.isEnabled = true
                case .failure(let error):
                    self.addToFavoritesBtn.setTitle("Add to Favorites", for: .normal)
                    self.addToFavoritesBtn.isEnabled = true
                }
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func backToHomeBtnTapped(_ sender: UIButton) {
        self.delegate?.goToHome()
    }
    
    @IBAction func addToFavoriteBtnTapped(_ sender: UIButton) {
        self.addToFavoritesBtn.setTitle("Loading...", for: .normal)
        self.addToFavoritesBtn.isEnabled = false
        self.addFavorite()
        shouldUpdateFavoriteSheet = true
        shouldUpdateFavoriteScreen = true
    }
    
}
