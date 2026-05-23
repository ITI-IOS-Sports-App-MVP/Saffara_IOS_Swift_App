//
//  OnboardingViewController.swift
//  sports_app
//
//  Created by Abdullh Gaber on 21/05/2026.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton! 
    
    var presenter: OnboardingPresenter!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupSlides()
        setupButtons()
        updateUI()
    }
    
    func setupSlides() {
        slides = [
            OnboardingSlide(title: "onboarding_title_1".localized, description: "onboarding_desc_1".localized, animationName: "onboarding_lottie_1"),
            OnboardingSlide(title: "onboarding_title_2".localized, description: "onboarding_desc_2".localized, animationName: "onboarding_lottie_2"),
            OnboardingSlide(title: "onboarding_title_3".localized, description: "onboarding_desc_3".localized, animationName: "onboarding_lottie_3")
        ]
        pageControl.numberOfPages = slides.count
    }
    
    func setupButtons() {
        skipButton.setTitle("onboarding_skip".localized, for: .normal)
        prevButton.setTitle("onboarding_previous".localized, for: .normal)
        nextButton.setTitle("onboarding_next".localized, for: .normal)
        getStartedButton.setTitle("onboarding_get_started".localized, for: .normal)
    }
    
    func updateUI() {
        if currentPage == slides.count - 1 {
            getStartedButton.isHidden = false
            nextButton.isHidden = true
            prevButton.isHidden = true
            skipButton.isHidden = true
        } else {
            getStartedButton.isHidden = true
            nextButton.isHidden = false
            prevButton.isHidden = currentPage == 0
            pageControl.isHidden = false
            skipButton.isHidden = false
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if currentPage < slides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func prevButtonClicked(_ sender: UIButton) {
        if currentPage > 0 {
            currentPage -= 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func getStartedButtonClicked(_ sender: UIButton) {
        presenter.onGetStartedTapped()
    }
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        presenter.onSkipTapped()
    }
}

extension OnboardingViewController: OnboardingViewProtocol {
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = homeVC
                window.makeKeyAndVisible()
                
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
