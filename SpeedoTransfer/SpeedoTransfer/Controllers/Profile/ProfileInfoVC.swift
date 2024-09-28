//
//  ProfileInformationVC.swift
//  Registration
//
//  Created by Malak Mohamed on 10/09/2024.
//

import UIKit

class ProfileInfoVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var detailsTableView: UITableView!
    
    // MARK: - Properties
    var user: User?
    var profileDetails: [DetailItem] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initiateVC(){
        self.setupTableView()
        self.setupNavigationBar(title: "Profile Information", selector: #selector(self.goBack))
        self.applyGradientBgYellowToRed()
        self.setupProfileDetails()
    }
    
    private func setupTableView() {
        detailsTableView.register(ProfileInfoViewCell.nib, forCellReuseIdentifier: ProfileInfoViewCell.identifier)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.backgroundColor = .clear
    }
    
    private func setupProfileDetails() {
        profileDetails = [
            DetailItem(title: "Full Name", subTitle: currentUser.name),
            DetailItem(title: "Email", subTitle: currentUser.email),
            DetailItem(title: "Date Of Birth", subTitle: currentUser.dateOfBirth),
            DetailItem(title: "Country", subTitle: currentUser.country),
            DetailItem(title: "Bank Account", subTitle: currentUser.bankAccount)
        ]
        
        detailsTableView.reloadData()
    }
    
}

// MARK: - UITableView Extension
extension ProfileInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoViewCell.identifier, for: indexPath) as! ProfileInfoViewCell
        let detailItem = profileDetails[indexPath.row]
        cell.configureCell(detailItem: detailItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
