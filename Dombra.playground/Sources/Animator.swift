import UIKit

// Animator - the class, that handles transitions between the View Controllers
public class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK:- Properties
    weak var containerView: UIView!
    weak var toView: UIView!
    
    private let duration = 0.5
    
    // MARK:- Protocol Methods
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        setupViews(context: transitionContext)
        
        containerView.addSubview(toView)
        
        toView.alpha = 0

        UIView.animate(withDuration: duration, animations: {
            self.toView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    
    // MARK: Helper Methods
    private func setupViews(context: UIViewControllerContextTransitioning) {
        containerView = context.containerView
        toView = context.viewController(forKey: .to)!.view
    }
}



