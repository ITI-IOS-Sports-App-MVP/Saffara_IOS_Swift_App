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
        updateUI()
    }
    
    func setupSlides() {
        slides = [
            OnboardingSlide(title: "Your World of Sports, All in One Place", description: "Explore leagues, follow upcoming events, and save your favorite teams.", animationName: "onboarding_lottie_1"),
            OnboardingSlide(title: "Stay on Top of Every Match", description: "Get upcoming fixtures, live scores, and full results — all in one clean view.", animationName: "onboarding_lottie_2"),
            OnboardingSlide(title: "Save Your Favorite Leagues", description: "Tap the heart on any league to pin it for quick access — even offline. Your favorites are always one tap away.", animationName: "onboarding_lottie_3")
        ]
        pageControl.numberOfPages = slides.count
    }
    
    func updateUI() {
        if currentPage == slides.count - 1 {
            // Last Page: Show ONLY the big "Get Started" button
            getStartedButton.isHidden = false
            nextButton.isHidden = true
            prevButton.isHidden = true
            skipButton.isHidden = true
        } else {
            // Other Pages: Show normal pagination controls
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
        goToHome()
    }
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        goToHome()
    }
    
    func goToHome() {
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

// MARK: - CollectionView Extension
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
