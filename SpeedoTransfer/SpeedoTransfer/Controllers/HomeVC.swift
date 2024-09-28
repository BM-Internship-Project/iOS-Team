//
//  HomeVC.swift
//  Registration
//
//  Created by Merna Islam on 02/09/2024.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var profileView: UIView!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameProfile: UILabel!
    @IBOutlet var transactionTableView: UITableView!
    @IBOutlet var notificationIcon: UIImageView!
    // For hiding it
    @IBOutlet var profileStackView: UIStackView!
    @IBOutlet var balanceView: UIView!
    @IBOutlet var viewAllStackView: UIStackView!
    
    // MARK: - Properties
    var tabSwitchDelegate: TabSwitchProtocol!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var transactions: [TransactionModel] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
        self.dummyTransfer() // to get user details
        UserDefaultsManager.shared().isLoggedIn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaultsManager.shared().isLoggedIn = true
        if loggedOut {
            self.startLoading()
            self.dummyTransfer()
            loggedOut = false
            shouldUpdateTransactionsScreen = true
            shouldUpdateHomeTransactions = false
            return
        }
        
        if shouldUpdateHomeTransactions {
            self.startLoading()
            self.updateHomeData()
            shouldUpdateHomeTransactions = false
        }
    }

    // MARK: - Private Methods
    private func initiateVC() {
        self.applyGradientBgYellowToRed()
        self.setupNavigationBorder()
        self.profileView.cornerRadius = profileView.frame.width / 2
        self.setupTableView()
        self.setupActivityIndicator()
        self.addTapGesture()
    }
    
    private func updateHomeData(){
        self.getBalance()
        self.getTransactions()
    }
    
    private func startLoading(){
        self.activityIndicator.startAnimating()
        self.toggleViewsVisibility(alpha: 0)
    }
    
    private func stopLoading(){
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) {
            self.toggleViewsVisibility(alpha: 1)
        }
    }
    
    private func setupActivityIndicator(){
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = .gray
        self.view.addSubview(activityIndicator)
    }
    
    private func toggleViewsVisibility(alpha: Double){
        self.transactionTableView.alpha = alpha
        self.profileStackView.alpha = alpha
        self.balanceView.alpha = alpha
        self.viewAllStackView.alpha = alpha
        self.profileView.alpha = alpha
        self.notificationIcon.alpha = alpha
    }
    
    // Handle token expiration and replace the root view with TimeOutVC
    private static func handleTokenExpiration() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let timeOutVC = TimeOutVC(nibName: "TimeOutVC", bundle: nil)	
                window.rootViewController = timeOutVC
            }
        }
    }
    
    private func setupTableView(){
        self.transactionTableView.register(HomeTransactionCell.nib, forCellReuseIdentifier: HomeTransactionCell.identifier)
        self.transactionTableView.register(HomeEmptyTransactionCell.nib, forCellReuseIdentifier: HomeEmptyTransactionCell.identifier)
        self.transactionTableView.delegate = self
        self.transactionTableView.dataSource = self
        self.transactionTableView.backgroundColor = .clear
    }
    
    private func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToNotifications))
        self.notificationIcon.addGestureRecognizer(tapGesture)
    }
    
    @objc private func goToNotifications(){
        self.navigationController?.pushViewController(NotificationVC(), animated: true)
    }
    
    private func fillCurrentUserData(){
        let i = self.transactions.count - 1
        let user = self.transactions[i].senderAccount
        currentUser.name = user.name
        currentUser.email = user.email
        currentUser.bankAccount = user.accountNumber
        currentUser.country = user.country
        currentUser.balance = user.balance
        currentUser.dateOfBirth = user.dateOfBirth
        self.nameLabel.text = user.name
        self.nameProfile.text = AppHelper.getInitials(from: user.name)
    }
    
    private func updateTransactions(transactions: [TransactionModel]){
        self.transactions = transactions
        self.fillCurrentUserData()
        self.transactions = self.transactions.filter( {$0.amount > 1})
        self.transactions = Array(self.transactions.reversed())
        self.transactionTableView.reloadData()
    }
    
    // MARK: - API Methods
    private func getTransactions(){
        APIManager.shared().getTransactions { result in
            DispatchQueue.main.async {
                self.stopLoading()
                switch result {
                case .success(let transactions):
                    self.updateTransactions(transactions: transactions)
                case .failure(_):
                    HomeVC.handleTokenExpiration()
                }
            }
        }
    }
    
    // Workaround to get current user details (No API exist for this)
    private func dummyTransfer(){
        APIManager.shared().transfer(to: "0890675435", amount: 0.0001) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.updateHomeData()
                case .failure(_):
                    self.goToErrorScreen()
                }
            }
        }
    }
    
    private func getBalance() {
        APIManager.shared().getBalance { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let balance):
                    currentBalance = balance
                    let balanceInt = Int(balance)
                    self.balanceLabel.text = "\(balanceInt)"
                case .failure(_):
                    self.goToErrorScreen()
                }
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func viewAllBtnTapped(_ sender: UIButton) {
        self.tabSwitchDelegate.switchToTransactionTab()
    }
}

// MARK: - UITableView Extension
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = self.transactions.count
        if cnt == 0 {
            return cnt + 1
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.transactions.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeEmptyTransactionCell.identifier, for: indexPath) as! HomeEmptyTransactionCell
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTransactionCell.identifier, for: indexPath) as! HomeTransactionCell
        cell.configureCell(transaction: self.transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.transactions.isEmpty {
            return tableView.frame.height
        }
        return 85
    }
}


// MARK: - TransferVCDelegate Extension
extension HomeVC: TransferVCDelegate {
    func goToTransfer() {
        self.tabSwitchDelegate.switchToTransferTab()
    }
}
