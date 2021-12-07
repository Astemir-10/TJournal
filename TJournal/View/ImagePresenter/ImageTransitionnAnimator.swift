import UIKit


class ImageTransitioAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (() -> ())?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let imagePresenterView = presenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : imagePresenterView.frame
        let finalFrame = presenting ? imagePresenterView.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            imagePresenterView.transform = scaleTransform
            imagePresenterView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            imagePresenterView.clipsToBounds = true
        }
        
        if let toView = transitionContext.view(forKey: .to) {
            containerView.addSubview(toView)
        }
        
        containerView.bringSubviewToFront(imagePresenterView)
        imagePresenterView.alpha = 0
        UIView.animate(withDuration: duration) {
            
            imagePresenterView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            imagePresenterView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            imagePresenterView.alpha = 1
        } completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }


    }
    
    
}
