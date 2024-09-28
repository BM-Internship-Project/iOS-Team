//
//  EditProfileVC.swift
//  Registration
//
//  Created by Merna Islam on 10/09/2024.
//

import UIKit

class EditProfileVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    
    // MARK: - Private Properties
    private var selectedCountry: String?
    private let countryIcon = UIImageView(image: UIImage(named: "DRop down"))
    private let calenderIcon = UIImageView(image: UIImage(named: "Vector"))
    private let countryPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Edit Profile", selector: #selector(self.goBack))
        self.setupIcons()
        self.setupPickerView()
        self.setupDatePicker()
    }
    
    private func setupPickerView(){
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryTextField.inputView = countryPicker
        countryTextField.text = nil
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCountryPicker))
        countryTextField.addGestureRecognizer(tapGesture)
    }
    
    private func setupDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        self.setupDateToolbar()
    }
    
    private func setupDateToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
    }
    
    private func setupIcons() {
        self.setupCountryIcon()
        self.setupDateIcon()
    }
    
    private func setupCountryIcon(){
        countryIcon.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingUser = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingUser.addSubview(countryIcon)
        countryTextField.rightView = paddingUser
        countryTextField.rightViewMode = .always
    }
    
    private func setupDateIcon(){
        calenderIcon.frame = CGRect(x: -14, y: 0, width: 24, height: 24)
        let paddingEmail = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        paddingEmail.addSubview(calenderIcon)
        dateTextField.rightView = paddingEmail
        dateTextField.rightViewMode = .always
    }
    
    private func countryFlag(for country: String) -> String {
        return countries.first(where: { $0.name == country })?.flag ?? "🏳️"
    }
    
    // MARK: - objc Methods
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func doneButtonTapped() {
        dateTextField.resignFirstResponder()
    }
    
    @objc private func openCountryPicker() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let countryPickerVC = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as? CountryPickerVC else { return }
        
        countryPickerVC.didSelectCountry = { [weak self] selectedCountry in
            self?.selectedCountry = selectedCountry
            self?.countryTextField.text = "\(self?.countryFlag(for: selectedCountry) ?? "") \(selectedCountry)"
        }
        
        present(countryPickerVC, animated: true, completion: nil)
    }

    // MARK: - IBAction
    @IBAction func saveBtnTapped(_ sender: UIButton){
        
    }
}


// MARK: - UIPickerView Extension
extension EditProfileVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
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
}
