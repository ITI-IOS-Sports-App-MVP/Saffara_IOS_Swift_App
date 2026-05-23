//
//  OnboardingCollectionViewCell.swift
//  sports_app
//
//  Created by Abdullh Gaber on 21/05/2026.
//

import UIKit
import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var animationView: LottieAnimationView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAnimationView()
    }
    
    private func setupAnimationView() {
        let animView = LottieAnimationView()
        animView.contentMode = .scaleAspectFit
        animView.loopMode = .loop
        animView.translatesAutoresizingMaskIntoConstraints = false
        
        animationContainerView.addSubview(animView)
        
        NSLayoutConstraint.activate([
            animView.topAnchor.constraint(equalTo: animationContainerView.topAnchor),
            animView.bottomAnchor.constraint(equalTo: animationContainerView.bottomAnchor),
            animView.leadingAnchor.constraint(equalTo: animationContainerView.leadingAnchor),
            animView.trailingAnchor.constraint(equalTo: animationContainerView.trailingAnchor)
        ])
        
        self.animationView = animView
    }
    
    func setup(_ slide: OnboardingSlide) {
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description
        
        animationView?.animation = LottieAnimation.named(slide.animationName)
        animationView?.play()
    }
}
