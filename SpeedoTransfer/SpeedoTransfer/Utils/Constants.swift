//
//  Constants.swift
//  Registration
//
//  Created by Merna Islam on 29/08/2024.
//

import Foundation
import UIKit

// MARK: - Storyboard IDs
struct ViewControllersID {
    static let SignUp = "SignUpNC"
    static let OnBoarding = "OnBoardingVC"
    static let SignIn = "SignInNC"
}

struct Storyboard {
    static let Main = "Main"
    static let OnBoardingScreen = "OnBoardingScreen"
}

// MARK: - Static Data
let moreItems = [
    MoreItem(prefixImage: UIImage(named: "Website"), title: "Transfer From Website"),
    MoreItem(prefixImage: UIImage(named: "Favorite"), title: "Favourites"),
    MoreItem(prefixImage: UIImage(named: "Person"), title: "Profile"),
    MoreItem(prefixImage: UIImage(named: "Help"), title: "Help"),
    MoreItem(prefixImage: UIImage(named: "Logout"), title: "Logout")
]

let onBoardingSlides = [
    OnBoardingModel(title: "Amount", description: "Send money fast with simple steps. Create account, Confirmation, Payment. Simple.", image: UIImage(imageLiteralResourceName: "Amount")),
    
    OnBoardingModel(title: "Confirmation", description: "Transfer funds instantly to friends and family worldwide, strong shield protecting a money.", image: UIImage(imageLiteralResourceName: "Confirmation")),
    
    OnBoardingModel(title: "Payment", description: "Enjoy peace of mind with our secure platform  Transfer funds instantly to friends.", image: UIImage(imageLiteralResourceName: "Payment"))
]

let profileItems = [
    ListItem(prefixImage: UIImage(named: "Profile Information"), title: "Personal Information", subTitle: "Your information"),
    ListItem(prefixImage: UIImage(named: "Settings"), title: "Settings", subTitle: "Change your settings"),
    ListItem(prefixImage: UIImage(named: "Payment History"), title: "Payment History", subTitle: "view your transactions"),
    ListItem(prefixImage: UIImage(named: "Favorite List"), title: "My Favorite list", subTitle: "view your favorites")
]

let settingItems = [
    ListItem(prefixImage: UIImage(named: "Change Password"), title: "Change Password", subTitle: "Change Password"),
    ListItem(prefixImage: UIImage(named: "Edit Profile"), title: "Edit Profile", subTitle: "Change your information")
]

let countries: [(name: String, flag: String)] = [
    ("United States", "🇺🇸"),
    ("Canada", "🇨🇦"),
    ("UK", "🇬🇧"),
    ("Germany", "🇩🇪"),
    ("France", "🇫🇷"),
    ("Egypt", "🇪🇬"),
    ("India", "🇮🇳"),
    ("Australia", "🇦🇺"),
    ("Saudi Arabia", "🇸🇦"),
    ("", "")
]

// MARK: - Current Data Handler
var currentTransaction: TransactionModel?

var currentBalance: Double!

struct CurrentUser {
    var name: String
    var balance: Double
    var email: String
    var dateOfBirth: String
    var country: String
    var bankAccount: String
}

var currentUser = CurrentUser(name: "", balance: 0, email: "", dateOfBirth: "", country: "", bankAccount: "")

var canSendNotifications: Bool = false

var loggedOut: Bool = false

// MARK: - Update Screen Handler
var shouldUpdateHomeTransactions: Bool = true
var shouldUpdateTransactionsScreen: Bool = true
var shouldUpdateFavoriteScreen: Bool = true
var shouldUpdateFavoriteSheet: Bool = true

