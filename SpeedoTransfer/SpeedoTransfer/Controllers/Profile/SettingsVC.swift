//
//  SettingsVC.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class SettingsVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var settingTableView: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Settings", selector: #selector(self.goBack))
        self.setupTableView()
    }
    
    private func setupTableView(){
        self.settingTableView.register(ProfileViewCell.nib, forCellReuseIdentifier: ProfileViewCell.identifier)
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.backgroundColor = .clear
    }
    
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func pushViewController(for item: Int) {
        switch item {
        case 0:
            self.navigationController?.pushViewController(ChangePasswordVC(), animated: true)
        case 1:
            self.navigationController?.pushViewController(EditProfileVC(), animated: true)
        default:
            break
        }
    }
}

// MARK: - UITableView Extension
extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as! ProfileViewCell
        cell.configureCell(profileItem: settingItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
