import UIKit

class CountryPickerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

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

    var selectedCountryIndex: IndexPath?
    var didSelectCountry: ((String) -> Void)?

    // Custom grabber view
    private let grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#3C3A37")
        view.layer.cornerRadius = 3
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")

        tableView.separatorStyle = .none
        self.applyGradientBgWhiteToRed()
        // Configure bottom sheet presentation
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()] // Medium detent for the bottom sheet
            sheet.prefersGrabberVisible = false // Hide the default grabber
            sheet.preferredCornerRadius = 50 // Set corner radius
        }

        // Add custom grabber and top spacer
        setupCustomGrabber()
    }

    // MARK: - TableView Delegate and DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = countries[indexPath.row]

        cell.textLabel?.text = "\(country.flag) \(country.name)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor(hex: "#706E6C") // Updated text color

        if selectedCountryIndex == indexPath {
            cell.backgroundColor = UIColor(hex: "#FFEBEE") // Light reddish background
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(hex: "#871E35") // Updated checkmark color
        } else {
            cell.backgroundColor = .clear
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountryIndex = indexPath
        let selectedCountry = countries[indexPath.row].name
        didSelectCountry?(selectedCountry)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Custom Grabber and Top Spacer

    private func setupCustomGrabber() {
        let topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.backgroundColor = .clear

        view.addSubview(topSpacer)
        view.addSubview(grabberView)

        grabberView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Top spacer constraints
            topSpacer.topAnchor.constraint(equalTo: view.topAnchor),
            topSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSpacer.heightAnchor.constraint(equalToConstant: 24), // 24 points top space

            // Grabber view constraints
            grabberView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            grabberView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 50), // Wider grabber width
            grabberView.heightAnchor.constraint(equalToConstant: 4) // Grabber height
        ])
    }
}

// Helper extension for UIColor to use hex color codes
extension UIColor {
    convenience init(hex: String) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner = Scanner(string: String(hexString.dropFirst()))
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let red = Int(color >> 16) & mask
        let green = Int(color >> 8) & mask
        let blue = Int(color) & mask

        let redNormalized = CGFloat(red) / 255.0
        let greenNormalized = CGFloat(green) / 255.0
        let blueNormalized = CGFloat(blue) / 255.0
        
        self.init(red: redNormalized, green: greenNormalized, blue: blueNormalized, alpha: 1)
    }
}
