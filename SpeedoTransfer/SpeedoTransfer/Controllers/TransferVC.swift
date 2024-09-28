//
//  AmountTransferVC.swift
//  Registration
//
//  Created by Merna Islam on 06/09/2024.
//

import UIKit

// MARK: - TransferVCDelegate
protocol TransferVCDelegate {
    func goToTransfer()
}

class TransferVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var firstStepView: UIView!
    @IBOutlet var secondStepView: UIView!
    @IBOutlet var thirdStepView: UIView!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var secondLine: UIView!
    @IBOutlet var transferCollectionView: UICollectionView!
   
    // MARK: - Properities
    var tabSwitchDelegate: TabSwitchProtocol?
    private let gradientLayer = CAGradientLayer()
    private var amountValue: Double = 0.0
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initiateVC()
    }
    
    // MARK: - Private Methods
    private func initiateVC(){
        self.applyGradientBgYellowToRed()
        self.setupNavigationBar(title: "Transfer", selector: #selector(self.goBack))
        self.setupStepperViews()
        self.cellsRegistration()
        self.setupCollectionView()
    }
    
    private func setupActivityIndicator(){
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = .gray
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
    }
    
    private func toggleViewsVisibility(alpha: Double){
        self.transferCollectionView.alpha = alpha
    }
    
    // MARK: - Collection View Setup
    private func cellsRegistration(){
        self.transferCollectionView.register(AmountCollectionCell.nib, forCellWithReuseIdentifier: AmountCollectionCell.identifier)
        self.transferCollectionView.register(ConfirmCollectionCell.nib, forCellWithReuseIdentifier: ConfirmCollectionCell.identifier)
        self.transferCollectionView.register(SuccessCollectionCell.nib, forCellWithReuseIdentifier: SuccessCollectionCell.identifier)
    }
    
    private func setupCollectionView(){
        self.transferCollectionView.delegate = self
        self.transferCollectionView.dataSource = self
        self.transferCollectionView.backgroundColor = .clear
    }
    
    private func setupStepperViews(){
        let sz = self.firstStepView.frame.width
        
        self.firstStepView.layer.borderWidth = 2
        self.firstStepView.layer.borderColor = AppColors.primaryColor.cgColor
        self.firstStepView.layer.cornerRadius = sz / 2
        
        self.secondStepView.layer.borderWidth = 2
        self.secondStepView.layer.borderColor = UIColor.lightGray.cgColor
        self.secondStepView.layer.cornerRadius = sz / 2
        
        self.thirdStepView.layer.borderWidth = 2
        self.thirdStepView.layer.borderColor = UIColor.lightGray.cgColor
        self.thirdStepView.layer.cornerRadius = sz / 2
    }
    
    // MARK: - Animation Setup
    private func setupGradientLayerForward(){
        self.gradientLayer.frame = self.secondLine.bounds
        self.gradientLayer.colors = [AppColors.primaryColor.cgColor, UIColor.lightGray.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.gradientLayer.locations = [0, 0]
        self.secondLine.layer.addSublayer(self.gradientLayer)
    }
    
    private func setupGradientLayerBackward(){
        self.gradientLayer.frame = secondLine.bounds
        self.gradientLayer.colors = [UIColor.lightGray.cgColor, AppColors.primaryColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        self.gradientLayer.locations = [1, 1]
        self.secondLine.layer.addSublayer(self.gradientLayer)
    }
    
    private func resetState(){
        let indexPath = IndexPath(item: 0, section: 0)
        self.transferCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.animateStepColorChange(step: -1)
        self.thirdStepView.layer.borderColor = UIColor.lightGray.cgColor
        self.thirdLabel.textColor = UIColor.lightGray
    }
    
    private func startAnimation(color: UIColor){
        self.gradientLayer.locations = [1, 1]
        UIView.animate(withDuration: 0.5, animations: {
            self.secondLabel.textColor = color
            self.secondStepView.layer.borderColor = color.cgColor
        })
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0]
        animation.toValue = [1, 1]
        animation.duration = 1
        self.gradientLayer.add(animation, forKey: nil)
    }
    
    func getConfirmCollectionCell() -> ConfirmCollectionCell? {
        let indexPath = IndexPath(item: 1, section: 0)
        return self.transferCollectionView.cellForItem(at: indexPath) as? ConfirmCollectionCell
    }
    
    // MARK: - Navigation Function
    @objc func goBack(){
        if let visibleIndexPath = self.transferCollectionView.indexPathsForVisibleItems.first {
            let visibleCell = self.transferCollectionView.cellForItem(at: visibleIndexPath)
            if visibleCell is ConfirmCollectionCell {
                self.resetState()
            } else {
                self.resetState()
                self.tabSwitchDelegate?.switchToHomeTab()

            }
        }
    }
}

// MARK: - UICollectionView Extension
extension TransferVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(indexPath.row){
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmountCollectionCell.identifier, for: indexPath) as! AmountCollectionCell
            cell.delegate = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfirmCollectionCell.identifier, for: indexPath) as! ConfirmCollectionCell
            cell.delegate = self
            cell.amount = self.amountValue
            return cell
                        
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuccessCollectionCell.identifier, for: indexPath) as! SuccessCollectionCell
            cell.delegate = self
            cell.amount = self.amountValue
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - CellDelegate Extension
extension TransferVC: CustomCellDelegate {
    var transferAmount: Double {
        get {
            return amountValue
        }
        set {
            self.amountValue = newValue
            let indexPath = IndexPath(item: 1, section: 0)
            transferCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func showMessage(title: String, message: String) {
        self.showAlert(title: title, message: message)
    }
    
    func goToHome() {
        self.resetState()
        self.tabSwitchDelegate?.switchToHomeTab()
    }
    
    func animateStepColorChange(step: Int) {
        let color = AppColors.primaryColor
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if step == 2 {
                self.setupGradientLayerForward()
                self.startAnimation(color: color)
            } else if step == 3 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.thirdStepView.layer.borderColor = color.cgColor
                    self.thirdLabel.textColor = color
                })
            } else if step == -1 {
                self.setupGradientLayerBackward()
                self.startAnimation(color: UIColor.lightGray)
            }
        }
    }
    
    func goToCell(in cell: UICollectionViewCell, next: Bool) {
        var cnt = -1
        if next {
            cnt = 1
        }
        guard let indexPath = self.transferCollectionView.indexPath(for: cell) else { return }
        let item = IndexPath(item: indexPath.item + cnt, section: indexPath.section)
        self.transferCollectionView.scrollToItem(at: item, at: .centeredHorizontally, animated: true)
    }
}
