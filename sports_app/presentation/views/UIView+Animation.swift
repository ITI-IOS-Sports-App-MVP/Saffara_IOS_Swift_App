import UIKit

extension UIView {
    enum CellAnimationType {
        case slideUpWithFade
        case slideInFromLeft
        case slideInFromRight
        case scaleIn
        case flip3D
    }
    
    /// Animates a cell view when it is about to be displayed or scrolled into view.
    /// - Parameters:
    ///   - duration: The total duration of the animations.
    ///   - delay: The amount of time to wait before starting the animation.
    ///   - type: The style of the animation.
    func animateCellDisplay(
        duration: TimeInterval = 0.45,
        delay: TimeInterval = 0.0,
        type: CellAnimationType = .slideUpWithFade
    ) {
        // Initial state before animation starts
        self.alpha = 0.0
        
        switch type {
        case .slideUpWithFade:
            self.transform = CGAffineTransform(translationX: 0, y: 40).scaledBy(x: 0.96, y: 0.96)
            
        case .slideInFromLeft:
            self.transform = CGAffineTransform(translationX: -60, y: 0)
            
        case .slideInFromRight:
            self.transform = CGAffineTransform(translationX: 60, y: 0)
            
        case .scaleIn:
            self.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            
        case .flip3D:
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 400.0
            self.layer.transform = CATransform3DRotate(perspective, .pi / 6, 1, 0, 0)
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        
        // Run animation with slight spring spring behavior for high-quality feel
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.82,
            initialSpringVelocity: 0.3,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.alpha = 1.0
                switch type {
                case .flip3D:
                    self.layer.transform = CATransform3DIdentity
                default:
                    self.transform = .identity
                }
            },
            completion: nil
        )
    }
}
