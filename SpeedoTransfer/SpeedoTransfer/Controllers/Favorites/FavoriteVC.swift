//
//  FavoriteVC.swift
//  Registration
//
//  Created by Merna Islam on 09/09/2024.
//

import UIKit

class FavoriteVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var favoriteTableView: UITableView!
    
    // MARK: - Private Properties
    private var favorites: [FavoriteModel] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getFavorites()
        shouldUpdateFavoriteScreen = false
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Favorites", selector: #selector(self.goBack))
        self.setupTableView()
    }
    
    private func setupTableView(){
        self.favoriteTableView.register(FavoriteViewCell.nib, forCellReuseIdentifier: FavoriteViewCell.identifier)
        self.favoriteTableView.dataSource = self
        self.favoriteTableView.delegate = self
        self.favoriteTableView.backgroundColor = .clear
    }
    
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API Methods
    private func getFavorites(){
        APIManager.shared().getFavorites { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let favorites):
                    self.favorites = favorites
                    self.favoriteTableView.reloadData()
                    
                case .failure(_):
                    self.goToErrorScreen()
                }
            }
        }
    }
    
    private func deleteFavorites(id: Int){
        APIManager.shared().deleteFavorite(id: id){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.getFavorites()
                    self.favoriteTableView.reloadData()
                    
                case .failure(_):
                    self.goToErrorScreen()
                }
            }
        }
    }

}

// MARK: - UITableView Extension
extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewCell.identifier, for: indexPath) as! FavoriteViewCell
        cell.configureCell(favorite: favorites[indexPath.row], i: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Cell Swipe Extension
extension FavoriteVC {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteItem(at: indexPath.row)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named: "Delete")
        deleteAction.backgroundColor = .red
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = true
        
        return swipeActions
    }

    func deleteItem(at i: Int) {
        let id = self.favorites[i].id
        self.deleteFavorites(id: id)
    }
}

// MARK: - FavoritesProtocol Extension
extension FavoriteVC: FavoritesProtocol{
    func openEditSheet(at i: Int) {
        self.navigationController?.present(EditFavoriteSheetVC(), animated: true)
    }
    
    func deleteFavorite(at i: Int) {
        self.deleteItem(at: i)
    }
}
