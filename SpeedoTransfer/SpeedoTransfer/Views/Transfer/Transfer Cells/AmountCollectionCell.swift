//
//  AmountCollectionCell.swift
//  Registration
//
//  Created by Merna Islam on 06/09/2024.
//

import UIKit

class AmountCollectionCell: UICollectionViewCell {
    
    // MARK: - Static Properities
    static let identifier = "AmountCollectionCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Properties
    weak var delegate: CustomCellDelegate?

    // MARK: - IBOutlet
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var favoriteStackView: UIStackView!
    @IBOutlet var continueBtn: UIButton!
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTextFieldBorder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openFavoriteSheet))
        favoriteStackView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private Methods
    private func setupTextFieldBorder(){
        self.setupAmountTextField()
        self.setupNameTextField()
        self.setupAccountTextField()
    }
    
    private func setupAmountTextField(){
        self.amountTextField.borderStyle = .roundedRect
        self.amountTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.amountTextField.layer.borderWidth = 1.5
        self.amountTextField.layer.cornerRadius = 10
    }
    
    private func setupNameTextField(){
        self.nameTextField.borderStyle = .roundedRect
        self.nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.nameTextField.layer.borderWidth = 1.5
        self.nameTextField.layer.cornerRadius = 5
    }
    
    private func setupAccountTextField(){
        self.accountTextField.borderStyle = .roundedRect
        self.accountTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.accountTextField.layer.borderWidth = 1.5
        self.accountTextField.layer.cornerRadius = 5
    }
    
    private func fieldsNotEmpty() -> Bool {
        if self.amountTextField.text == "" {
            delegate?.showMessage(title: "Invalid Data", message: "You must write an amount to transfer")
            return false
        }
        
        if self.accountTextField.text == "" {
            delegate?.showMessage(title: "Invalid Data", message: "You must write the account number of the recepient")
            return false
        }
        
        if Double(self.amountTextField.text!)! > currentBalance {
            delegate?.showMessage(title: "Invalid Data", message: "Insuffient Balance,\nYour current balance is \(currentBalance!) EGP")
            return false
        }
        
        if Double(self.amountTextField.text!)! < 0 {
            delegate?.showMessage(title: "Invalid Data", message: "The balance should be greater than 0 EGP")
            return false
        }
        
        return true
    }
    
    // MARK: - API Methods (Validation)
    private func isValidAccount(completion: @escaping (Bool) -> Void) {
        APIManager.shared().transfer(to: accountTextField.text!, amount: 0.0001) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    completion(true)
                case .failure(_):
                    self.delegate?.showMessage(title: "Invalid Transfer", message: "No such account number exist")
                    completion(false)
                }
            }
        }
    }
    
    private func getDetails(){
        APIManager.shared().getTransactions { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    let last = transactions.count - 1
                    let transaction = transactions[last]
                    currentTransaction = transaction
                    self.delegate?.goToCell(in: self, next: true)
                    self.delegate?.animateStepColorChange(step: 2)
                case .failure(_):
                    return
                }
            }
        }
    }
    
    private func canTransfer(completion: @escaping (Bool) -> Void) {
        if self.fieldsNotEmpty() {
            self.isValidAccount { isValid in
                completion(isValid)
            }
        } else {
            completion(false)
        }
    }
    
    // MARK: - IBAction
    @IBAction func continueBtnTapped(_ sender: Any) {
        continueBtn.setTitle("Loading...", for: .normal)
        continueBtn.isEnabled = false
        self.canTransfer { canTransfer in
            if canTransfer {
                self.getDetails()
                if let amountText = self.amountTextField.text, let amount = Double(amountText) {
                   self.delegate?.transferAmount = amount
               }
            }
            DispatchQueue.main.async {
                self.continueBtn.setTitle("Continue", for: .normal)
                self.continueBtn.isEnabled = true
            }
        }
    }
    
}

// MARK: - Scroll Extension
extension AmountCollectionCell: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}

// MARK: - FavoriteDelegate Extension
extension AmountCollectionCell: FavoriteSelectionDelegate{
    @objc private func openFavoriteSheet() {
        if let viewController = delegate as? UIViewController {
            let favoriteSheetVC = FavoriteSheetVC()
            favoriteSheetVC.delegate = self
            viewController.present(favoriteSheetVC, animated: true, completion: nil)
        }
    }
    
    func didSelectFavorite(_ favorite: FavoriteModel) {
        self.nameTextField.text = favorite.recipientName
        self.accountTextField.text = favorite.recipientAccountNumber
    }
}
