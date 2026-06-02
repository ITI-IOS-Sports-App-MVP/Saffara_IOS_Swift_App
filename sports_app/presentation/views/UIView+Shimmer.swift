import UIKit

extension UIView {
    
    /// Starts a premium shimmer animation on the view using CAGradientLayer
    func startShimmer(
        lightColor: UIColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.12, alpha: 1.0)
                : UIColor(white: 0.85, alpha: 1.0)
        },
        darkColor: UIColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.22, alpha: 1.0)
                : UIColor(white: 0.95, alpha: 1.0)
        },
        duration: CFTimeInterval = 1.2
    ) {
        // Avoid adding duplicate shimmer layers
        if self.layer.sublayers?.contains(where: { $0.name == "shimmerLayer" }) == true {
            return
        }
        
        let gradient = CAGradientLayer()
        gradient.name = "shimmerLayer"
        
        // Use bounds of the view; if bounds are zero, use a default frame and we will update it if needed.
        let width = self.bounds.width > 0 ? self.bounds.width : 200
        let height = self.bounds.height > 0 ? self.bounds.height : 80
        
        gradient.frame = CGRect(x: -width, y: 0, width: width * 3, height: height)
        gradient.colors = [lightColor.cgColor, darkColor.cgColor, lightColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.35, 0.5, 0.65]
        
        self.layer.addSublayer(gradient)
        self.clipsToBounds = true
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.byValue = width * 2
        animation.duration = duration
        animation.repeatCount = .infinity
        
        gradient.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopShimmer() {
        self.layer.sublayers?.forEach { layer in
            if layer.name == "shimmerLayer" {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
    }
}
