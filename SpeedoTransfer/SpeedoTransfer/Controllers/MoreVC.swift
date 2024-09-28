import UIKit

class MoreVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var moreTableView: UITableView!
    @IBOutlet weak var contactUsSelected: UILabel!
    
    // MARK: - Properties
    var tabSwitchDelegate: TabSwitchProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "More", selector: #selector(self.goBack))
        self.setupTableView()
    }
    
    private func setupTableView(){
        self.moreTableView.register(MoreViewCell.nib, forCellReuseIdentifier: MoreViewCell.identifier)
        self.moreTableView.delegate = self
        self.moreTableView.dataSource = self
        self.moreTableView.backgroundColor = .clear
    }
    
    @objc private func goBack(){
        self.tabSwitchDelegate?.switchToHomeTab()
    }
    
    private func clearUserSession() {
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.synchronize()
    }
    
    private func pushViewController(for item: Int) {
        switch item {
        case 1:
            self.navigationController?.pushViewController(FavoriteVC(), animated: true)
        case 2:
            self.navigationController?.pushViewController(ProfileVC(), animated: true)
        case 3:
            present(HelpVC(), animated: true)
        case 4:
            self.logout()
        default:
            break
        }
    }
    
    private func logout(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        APIManager.shared().logoutUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("Logout successful: \(message)")
                    self.clearUserSession()
                    let alert = UIAlertController(title: "Logged Out", message: "You have successfully logged out.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        delegate.switchToLoginScreen()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                case .failure(let error):
                    print("Logout failed: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - UITableView Extension
extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreViewCell.identifier, for: indexPath) as! MoreViewCell
        cell.configureCell(i: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushViewController(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
