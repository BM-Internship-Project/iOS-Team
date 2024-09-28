//
//  TransactionsVC.swift
//  Registration
//
//  Created by Merna Islam on 04/09/2024.
//

import UIKit

class TransactionsVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var transactionTableView: UITableView!
    
    // MARK: - Properties
    var tabSwitchDelegate: TabSwitchProtocol?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var transactions: [TransactionModel] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldUpdateTransactionsScreen {
            self.activityIndicator.startAnimating()
            self.toggleViewsVisibility(alpha: 0)
            self.getTransactions()
            shouldUpdateTransactionsScreen = false
        }
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Transactions", selector: #selector(self.goBack))
        self.setupTableView()
        self.setupActivityIndicator()
    }
    
    private func setupActivityIndicator(){
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = .gray
        self.view.addSubview(activityIndicator)
    }
    
    private func toggleViewsVisibility(alpha: Double){
        self.transactionTableView.alpha = alpha
    }
    
    @objc private func goBack(){
        if self.tabSwitchDelegate == nil {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.tabSwitchDelegate?.switchToHomeTab()
    }
    
    private func setupTableView(){
        transactionTableView.register(TransactionsViewCell.nib, forCellReuseIdentifier: TransactionsViewCell.identifier)
        transactionTableView.register(HomeEmptyTransactionCell.nib, forCellReuseIdentifier: HomeEmptyTransactionCell.identifier)
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.backgroundColor = .clear
    }
    
    // MARK: - API Methods
    private func getTransactions(){
        APIManager.shared().getTransactions { result in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.3) {
                    self.toggleViewsVisibility(alpha: 1)
                }
        
                switch result {
                case .success(let transactions):
                    self.transactions = transactions
                    self.transactions = self.transactions.filter { $0.amount > 1}
                    self.transactions = Array(self.transactions.reversed())
                    self.transactionTableView.reloadData()
                    
                case .failure(_):
                    self.goToErrorScreen()
                }
            }

        }
    }

}

// MARK: - UITableView Extension
extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsViewCell.identifier, for: indexPath) as! TransactionsViewCell
        cell.configureCell(transaction: self.transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.transactions.isEmpty {
            return tableView.frame.height
        }
        return 141
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionDetails = TransactionDetailsVC()
        transactionDetails.transaction = self.transactions[indexPath.row]
        self.navigationController?.pushViewController(transactionDetails, animated: true)
    }
}

// MARK: - TransferVCDelegate
extension TransactionsVC: TransferVCDelegate{
    func goToTransfer() {
        self.tabSwitchDelegate?.switchToTransferTab()
    }
}
