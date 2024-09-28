//
//  ChangePasswordVC.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var currentPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    
    // MARK: - Private Properities
    private let eyeOpenIconCurrPassword = UIImageView(image: UIImage(named: "eye open"))
    private let eyeOpenIconNewPassword = UIImageView(image: UIImage(named: "eye open"))
    private var isCurrPasswordVisible = false
    private var isNewPasswordVisible = false

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Change Password", selector: #selector(self.goBack))
        self.setupVisibilityIcons()
        self.addTapGestures()
    }
    
    private func setupVisibilityIcons(){
        eyeOpenIconCurrPassword.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingEyePassword = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingEyePassword.addSubview(eyeOpenIconCurrPassword)
        currentPassword.rightView = paddingEyePassword
        currentPassword.rightViewMode = .always
        
        eyeOpenIconNewPassword.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingEyeConfPassword = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingEyeConfPassword.addSubview(eyeOpenIconNewPassword)
        newPassword.rightView = paddingEyeConfPassword
        newPassword.rightViewMode = .always
    }
    
    private func addTapGestures(){
        let tapGestureCurrPassword = UITapGestureRecognizer(target: self, action: #selector(toggleCurrPasswordVisibility(_:)))
        eyeOpenIconCurrPassword.isUserInteractionEnabled = true
        eyeOpenIconCurrPassword.addGestureRecognizer(tapGestureCurrPassword)
        
        let tapGestureNewPassword = UITapGestureRecognizer(target: self, action: #selector(toggleNewPasswordVisibility(_:)))
        eyeOpenIconNewPassword.isUserInteractionEnabled = true
        eyeOpenIconNewPassword.addGestureRecognizer(tapGestureNewPassword)
    }
    
    // MARK: - objc Methods
    @objc func toggleCurrPasswordVisibility(_ sender: UITapGestureRecognizer) {
        isCurrPasswordVisible.toggle()
        currentPassword.isSecureTextEntry = !isCurrPasswordVisible
        eyeOpenIconCurrPassword.image = UIImage(named: isCurrPasswordVisible ? "closed eye" : "eye open")
    }
    
    @objc func toggleNewPasswordVisibility(_ sender: UITapGestureRecognizer) {
        isNewPasswordVisible.toggle()
        newPassword.isSecureTextEntry = !isNewPasswordVisible
        eyeOpenIconNewPassword.image = UIImage(named: isNewPasswordVisible ? "closed eye" : "eye open")
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }

}
