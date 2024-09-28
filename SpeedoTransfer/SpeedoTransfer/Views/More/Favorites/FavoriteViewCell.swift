//
//  FavoriteViewCell.swift
//  Registration
//
//  Created by Merna Islam on 09/09/2024.
//

import UIKit

class FavoriteViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FavoriteViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    weak var delegate: FavoritesProtocol?
    var currentIndexPath: Int?
    
    // MARK: - IBOutlet
    @IBOutlet var editView: UIView!
    @IBOutlet var deleteView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var accountNumberLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Methods
    private func addGesture(){
        let openTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openEditSheet))
        self.editView.addGestureRecognizer(openTapGesture)
        
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.deleteFavorite))
        self.deleteView.addGestureRecognizer(deleteTapGesture)
    }
    
    func configureCell(favorite: FavoriteModel, i: Int){
        self.nameLabel.text = favorite.recipientName
        self.accountNumberLabel.text = favorite.recipientAccountNumber
        self.currentIndexPath = i
    }
    
    // MARK: - objc Methods
    @objc private func openEditSheet(){
        if let indexPath = self.currentIndexPath {
            self.delegate?.openEditSheet(at: indexPath)
        }
    }
    
    @objc private func deleteFavorite(){
        if let indexPath = self.currentIndexPath {
            self.delegate?.deleteFavorite(at: indexPath)
        }
    }
}
