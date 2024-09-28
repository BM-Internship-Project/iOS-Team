//
//  NotificationVC.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class NotificationVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var notificationTableView: UITableView!
    
    // MARK: - Private Properties
    private var notifications: [TransactionModel] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Notifications", selector: #selector(self.goBack))
        self.getNotifications()
        self.setupTableView()
    }
    
    private func setupTableView(){
        self.notificationTableView.register(NotificationViewCell.nib, forCellReuseIdentifier: NotificationViewCell.identifier)
        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.backgroundColor = .clear
    }
    
    private func getNotifications(){
        APIManager.shared().getTransactions { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    self.notifications = transactions.filter( {$0.senderAccount.accountNumber == currentUser.bankAccount && $0.amount > 1}).reversed()
                    self.notificationTableView.reloadData()
                case .failure(_):
                    self.goToErrorScreen()
                }
            }
            
        }
    }
    
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - UITableView Extension
extension NotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationViewCell.identifier, for: indexPath) as! NotificationViewCell
        cell.configureCell(transaction: self.notifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
