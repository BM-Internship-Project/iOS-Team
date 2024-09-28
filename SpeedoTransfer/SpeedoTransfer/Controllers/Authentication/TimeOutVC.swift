//
//  TimeOutVC.swift
//  Registration
//
//  Created by Malak Mohamed on 11/09/2024.
//

import UIKit

class TimeOutVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var closeButton: UIImageView!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    // MARK: - Private Properties
    private let emailIcon = UIImageView(image: UIImage(named: "email"))
    private let eyeOpenIconPassword = UIImageView(image: UIImage(named: "eye open"))
    private var isPasswordVisible = false

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyGradientBgWhiteToRed()
        setupIcons()
        closeButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeNotification))
           closeButton.addGestureRecognizer(tapGesture)
       }

    // MARK: - Private Methods
    @objc private func closeNotification() {
       UIView.animate(withDuration: 0.3) {
           self.notificationView.alpha = 0
       } completion: { _ in
           self.notificationView.removeFromSuperview()
       }
    }
    
    private func checkIfUserIsRegistered() -> Bool{
        let userDefaults = UserDefaults.standard
        if let isRegistered = userDefaults.value(forKey: "isRegistered") as? Bool, isRegistered {
            if let fullName = userDefaults.value(forKey: "fullName") as? String,
               let email = userDefaults.value(forKey: "email") as? String {
                print("User is registered")
                print("Full Name: \(fullName)")
                print("Email: \(email)")
            } else {
                print("User details are missing")
                return false
            }
        } else {
            print("User is not registered")
            return false
        }
        return true
    }
    
    private func setupIcons() {
        // Setup for Email text field
        emailIcon.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingEmail = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingEmail.addSubview(emailIcon)
        EmailTextField.rightView = paddingEmail
        EmailTextField.rightViewMode = .always
        
        // Setup for Password text field (eye open icon)
        eyeOpenIconPassword.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingEyePassword = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingEyePassword.addSubview(eyeOpenIconPassword)
        PasswordTextField.rightView = paddingEyePassword
        PasswordTextField.rightViewMode = .always
        
        // Add tap gesture recognizer to toggle password visibility
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility(_:)))
        eyeOpenIconPassword.isUserInteractionEnabled = true
        eyeOpenIconPassword.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Toggle Password Visibility
    @objc func togglePasswordVisibility(_ sender: UITapGestureRecognizer) {
        isPasswordVisible.toggle()
        PasswordTextField.isSecureTextEntry = !isPasswordVisible
        eyeOpenIconPassword.image = UIImage(named: isPasswordVisible ? "closed eye" : "eye open")
    }
    
    // MARK: - IBAction
    @IBAction func SignInButtonTapped(_ sender: Any) {
        guard let email = EmailTextField.text, !email.isEmpty,
              let password = PasswordTextField.text, !password.isEmpty else {
            self.showAlert(title: "Missing Data", message: "Please enter your credientials.")
            return
        }

        APIManager.shared().loginUser(email: email, password: password) { result in
            switch result {
            case .success(let response):
                print("Login successful: \(response)")
                DispatchQueue.main.async {
                    print(TokenManager.shared().getToken() ?? "no token")
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate?.switchToHomeScreen()
                }
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                  self.showAlert(title: "Login Failed", message: "User is not registered or login details are incorrect.")
                }
            }
        }
        
        
    }
}
