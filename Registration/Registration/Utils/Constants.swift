//
//  Constants.swift
//  Registration
//
//  Created by Merna Islam on 29/08/2024.
//

import Foundation
import UIKit

struct ViewControllersID {
    static let SignUp = "SignUpVC1"
    static let OnBoarding = "OnBoardingVC"
    static let SignIn = "SignInVC"
}

struct Storyboard {
    static let Main = "Main"
    static let OnBoardingScreen = "OnBoardingScreen"
}

let moreItems = [
    MoreItem(prefixIcon: UIImage(named: "Website"), title: "Transfer From Website"),
    MoreItem(prefixIcon: UIImage(named: "Favorite"), title: "Favourites"),
    MoreItem(prefixIcon: UIImage(named: "Person"), title: "Profile"),
    MoreItem(prefixIcon: UIImage(named: "Help"), title: "Help"),
    MoreItem(prefixIcon: UIImage(named: "Logout"), title: "Logout")
]

let slides = [
    OnBoardingModel(title: "Amount", description: "Send money fast with simple steps. Create account, Confirmation, Payment. Simple.", image: UIImage(imageLiteralResourceName: "Amount")),
    
    OnBoardingModel(title: "Confirmation", description: "Transfer funds instantly to friends and family worldwide, strong shield protecting a money.", image: UIImage(imageLiteralResourceName: "Confirmation")),
    
    OnBoardingModel(title: "Payment", description: "Enjoy peace of mind with our secure platform  Transfer funds instantly to friends.", image: UIImage(imageLiteralResourceName: "Payment"))
]
