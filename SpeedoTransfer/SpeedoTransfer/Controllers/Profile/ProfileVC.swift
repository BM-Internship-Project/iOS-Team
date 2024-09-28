//
//  ProfileTestVC.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class ProfileVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var nameProfile: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.setupNavigationBar(title: "Profile", selector: #selector(self.goBack))
        self.setupTableView()
        self.profileView.cornerRadius = profileView.frame.width / 2
        self.applyGradientBgYellowToRed()
        self.nameLabel.text = currentUser.name
        self.nameProfile.text = AppHelper.getInitials(from: currentUser.name)
    }
    
    private func setupTableView(){
        self.profileTableView.register(ProfileViewCell.nib, forCellReuseIdentifier: ProfileViewCell.identifier)
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.backgroundColor = .clear
        
    }
    
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func pushViewController(for item: Int) {
        switch item {
        case 0:
            self.navigationController?.pushViewController(ProfileInfoVC(), animated: true)
        case 1:
            self.navigationController?.pushViewController(SettingsVC(), animated: true)
        case 2:
            self.navigationController?.pushViewController(TransactionsVC(), animated: true)
        case 3:
            self.navigationController?.pushViewController(FavoriteVC(), animated: true)
        default:
            break
        }
    }

}

// MARK: - UITableView Extension
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as! ProfileViewCell
        cell.configureCell(profileItem: profileItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
