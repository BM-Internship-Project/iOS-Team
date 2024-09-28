//
//  FavoriteSheetVC.swift
//  Registration
//
//  Created by Merna Islam on 08/09/2024.

import UIKit

// MARK: - FavoriteSelectionDelegate
protocol FavoriteSelectionDelegate: AnyObject {
    func didSelectFavorite(_ favorite: FavoriteModel)
}

class FavoriteSheetVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var favoriteTableView: UITableView!
    
    // MARK: - Properties
    private var favorites: [FavoriteModel] = []
    weak var delegate: FavoriteSelectionDelegate?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getFavorites()
        shouldUpdateFavoriteSheet = false
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.createSheet()
        self.setupTableView()
    }
    
    private func createSheet(){
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 50
        }
    }
    
    private func setupTableView(){
        self.favoriteTableView.register(FavoriteSheetViewCell.nib, forCellReuseIdentifier: FavoriteSheetViewCell.identifier)
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = self
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
}

// MARK: - UITableView Extension
extension FavoriteSheetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteSheetViewCell.identifier, for: indexPath) as! FavoriteSheetViewCell
        cell.configureCell(favorite: favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFavorite = favorites[indexPath.row]
        delegate?.didSelectFavorite(selectedFavorite)
        dismiss(animated: true, completion: nil)
    }
}
