import UIKit

class ContinueSignUpVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    let countryIcon = UIImageView(image: UIImage(named: "DRop down"))
    let calenderIcon = UIImageView(image: UIImage(named: "Vector"))
    
    // The userData passed from SignUpVC1
    var userData: UserData?
    
    // Array of tuples for countries with flags
    var countries: [(name: String, flag: String)] = [
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
    
    var selectedCountry: String?
    
    // Picker view and date picker
    private let countryPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInButton()
        setupIcons()
        // Setting up the country picker
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryTextField.inputView = countryPicker
        self.applyGradientBgWhiteToRed()
        self.setupNavigationBar(title: "", selector: #selector(self.goBack))
        
        // Setting up the date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels // Use the wheels style
        datePicker.maximumDate = Date() // Prevent future dates
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
        
        // Adding a toolbar with "Done" button for date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        dateOfBirthTextField.inputAccessoryView = toolbar
        
        // Initial state: No country is selected, keep countryTextField blank
        countryTextField.text = nil
        
        // Displaying passed userData
        if let userData = userData {
            print("User Data received: Full Name: \(userData.fullName), Email: \(userData.email)")
            // Here, you can use userData to pre-fill or display data
            // For instance, if you had text fields to show fullName, email, etc., you could assign them here
            // Example: fullNameTextField.text = userData.fullName
        }
        
        // Adding tap gesture to countryTextField to show country picker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCountryPicker))
        countryTextField.addGestureRecognizer(tapGesture)
    }
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    private func setupIcons() {
        // Setup for Full Name text field
        countryIcon.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingUser = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingUser.addSubview(countryIcon)
        countryTextField.rightView = paddingUser
        countryTextField.rightViewMode = .always
        
        // Setup for Email text field
        calenderIcon.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingEmail = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingEmail.addSubview(calenderIcon)
        dateOfBirthTextField.rightView = paddingEmail
        dateOfBirthTextField.rightViewMode = .always
    }
    // MARK: - Picker View Data Source and Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(countries[row].flag) \(countries[row].name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row].name
        countryTextField.text = "\(countries[row].flag) \(countries[row].name)"
    }
    
    // Date picker value change handler
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateOfBirthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - Done Button Handling for Date Picker
    
    @objc private func doneButtonTapped() {
        dateOfBirthTextField.resignFirstResponder() // Dismiss the date picker
    }
    
    // MARK: - Country Picker Handling
    
    @objc private func openCountryPicker() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let countryPickerVC = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as? CountryPickerVC else { return }
        
        countryPickerVC.didSelectCountry = { [weak self] selectedCountry in
            self?.selectedCountry = selectedCountry
            self?.countryTextField.text = "\(self?.countryFlag(for: selectedCountry) ?? "") \(selectedCountry)"
        }
        
        present(countryPickerVC, animated: true, completion: nil)
    }
    
    private func countryFlag(for country: String) -> String {
        return countries.first(where: { $0.name == country })?.flag ?? "🏳️"
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard CheckData() else { return }
        guard let userData = userData, let selectedCountry = selectedCountry else {
            print("Missing data")
            return
        }

        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        _ = dateFormatter.string(from: selectedDate)

        // Create the User object with correct date format
        let newUser = User(
            name: userData.fullName,
            email: userData.email,
            password: userData.password,
            confirmPassword: userData.password,
            country: selectedCountry,
            dateOfBirth: selectedDate
        )
        
        APIManager.shared().registerUser(user: newUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        delegate?.switchToLoginScreen()
                    }
                case .failure(let error):
                    self.goToErrorScreen()
                }
            }
        }
    }
    
       // Helper method to show alerts
        private func showMessage(message: String) {
            self.showAlert(title: "Validation Error", message: message)
        }
       
       // Data validation checks
        private func CheckData() -> Bool{
        
        guard selectedCountry != nil else {
            showMessage(message: "Please select a country.")
            return false
        }
        
        guard let dateOfBirthText = dateOfBirthTextField.text, !dateOfBirthText.isEmpty else {
            showMessage(message: "Please select your date of birth.")
            return false
        }
        
        // Convert the date string to a Date object (assuming the date picker format is valid)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust based on your date picker format
            let dateOfBirth = datePicker.date // Directly use the selected date from the date picker

            // Calculate the age based on the date of birth
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
            // Check if the user is at least 18 years old
            guard let age = ageComponents.year, age >= 18 else {
                showMessage(message: "You must be at least 18 years old.")
                return false
            }
        return true
            
    }

    // Configure sign-in button
    private func configureSignInButton() {
        let signUpButtonTitle = "Sign In"
        let attributedTitle = NSMutableAttributedString(string: signUpButtonTitle)
        let range = NSRange(location: 0, length: attributedTitle.length)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: signInButton.titleLabel?.font ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: signInButton.titleLabel?.textColor ?? UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedTitle.addAttributes(attributes, range: range)
        
        signInButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
}
