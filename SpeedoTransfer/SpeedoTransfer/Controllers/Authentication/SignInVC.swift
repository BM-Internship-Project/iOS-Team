import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    let emailIcon = UIImageView(image: UIImage(named: "email"))
    let eyeOpenIconPassword = UIImageView(image: UIImage(named: "eye open"))
    
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        self.applyGradientBgWhiteToRed()
        configureSignUpButton()
        setupIcons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaultsManager.shared().isLoggedIn = false
        loggedOut = true
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
    
    private func configureSignUpButton() {
        let signUpButtonTitle = "Sign Up"
        let attributedTitle = NSMutableAttributedString(string: signUpButtonTitle)
        let range = NSRange(location: 0, length: attributedTitle.length)
        
        // Set font, color, and underline style
        let attributes: [NSAttributedString.Key: Any] = [
            .font: signUpButton.titleLabel?.font ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: signUpButton.titleLabel?.textColor ?? UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedTitle.addAttributes(attributes, range: range)
        
        signUpButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                // Call the switchToRegisterScreen method
                appDelegate.switchToRegisterScreen()
            }
    }
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
        guard let email = EmailTextField.text, !email.isEmpty,
              let password = PasswordTextField.text, !password.isEmpty else {
            self.showAlert(title: "Missing Data", message: "Please enter your credientials.")
            return
        }
        self.checkNetworkAndProceed {
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
}
