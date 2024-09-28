//
//  OnBoardingVC.swift
//  Registration
//
//  Created by Merna Islam on 28/08/2024.
//

import UIKit

class OnBoardingVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var verticalSpace: NSLayoutConstraint!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Private Properties
    private var currentPage = 0 {
        didSet{
            self.pageControl.currentPage = currentPage
            if currentPage == onBoardingSlides.count - 1 {
                self.nextBtn.setTitle("Get Started", for: .normal)
            } else {
                self.nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setVerticalSpace()
        self.applyGradientBgWhiteToRed()
    }
    
    override func viewDidLayoutSubviews() {
        if UIScreen.main.bounds.size.height <= 700 {
            self.pageControl.subviews.forEach {
                $0.transform = CGAffineTransform(scaleX: 1, y: 1)}
        } else {
            self.pageControl.subviews.forEach {
                $0.transform = CGAffineTransform(scaleX: 2, y: 2)}
        }
        
        self.pageControl.numberOfPages = onBoardingSlides.count
    }
    
    // MARK: - IBAction
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        if currentPage == onBoardingSlides.count - 1 {
            self.goToRegisterScreen()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        self.goToRegisterScreen()
    }
    
    // MARK: - Private Methods
    private func setupCollectionView(){
        self.collectionView.register(UINib(nibName: OnBoardingViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: OnBoardingViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
    }
    
    private func setVerticalSpace() {
        if UIScreen.main.bounds.size.height <= 700 {
            self.verticalSpace.constant = 140
        } else {
            self.verticalSpace.constant = 180
        }
    }
    
    private func goToRegisterScreen(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UIView.transition(with: appDelegate.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            appDelegate.switchToRegisterScreen()
        }, completion: nil)
    }
    
}

// MARK: - Collection View Extension
extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingViewCell.identifier, for: indexPath) as! OnBoardingViewCell
        cell.configureCell(onBoardingSlides[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        self.currentPage = Int(scrollView.contentOffset.x / width)
    }
}
