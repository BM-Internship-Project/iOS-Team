//
//  ProfileVC.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var profileView: UIView!

    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Profile", selector: #selector(self.goBack))
        self.setupTableView()
        self.profileView.cornerRadius = profileView.frame.width / 2

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

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as! ProfileViewCell
        cell.configureCell(profileItem: profileItems[indexPath.row])
        return cell
    }
    
    
}
