import Foundation
import UIKit

protocol FeedRouterProtocol {
    func showImagePresenter(image: UIImage, frame: CGRect)
}

class FeedRouter: NSObject, FeedRouterProtocol {
    weak var ownerViewCotroller: UIViewController?
    private var animator = ImageTransitioAnimator()
    private var imageFrame = CGRect.zero
    
    func showImagePresenter(image: UIImage, frame: CGRect) {
        let imagePresenter = ImagePresenterViewController()
        self.imageFrame = frame
        imagePresenter.image = image
        imagePresenter.transitioningDelegate = self
        imagePresenter.modalPresentationStyle = .overCurrentContext
        ownerViewCotroller?.present(imagePresenter, animated: true)
    }
    
    init(vc: UIViewController) {
        self.ownerViewCotroller = vc
    }
}

extension FeedRouter: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        animator.originFrame = imageFrame
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        
        return animator
    }
}
