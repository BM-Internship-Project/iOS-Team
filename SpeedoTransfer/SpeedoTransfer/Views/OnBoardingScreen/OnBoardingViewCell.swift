//
//  OnBoardingViewCell.swift
//  Registration
//
//  Created by Merna Islam on 29/08/2024.
//

import UIKit

class OnBoardingViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "OnBoardingViewCell"
    
    // MARK: - IBOutlet
    @IBOutlet var verticalSpaceInBetween: NSLayoutConstraint!
    @IBOutlet var slideStackView: UIStackView!
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideDescription: UILabel!
    @IBOutlet weak var slideTitle: UILabel!
    
    // MARK: - Methods
    func configureCell(_ onBoardingModel: OnBoardingModel){
        slideImageView.image = onBoardingModel.image
        slideTitle.text = onBoardingModel.title
        slideDescription.text = onBoardingModel.description
        modifyStackViewProperties()
    }
    
    private func modifyStackViewProperties(){
        if UIScreen.main.bounds.size.height <= 700 {
            slideStackView.spacing = 4
            slideTitle.font = slideTitle.font.withSize(20)
            slideDescription.font = slideDescription.font.withSize(16)
            verticalSpaceInBetween.constant = 90
        } 
    }
    
}
