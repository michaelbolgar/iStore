//import UIKit
//
//class HalfScreenPresentationController: UIPresentationController {
//    override var frameOfPresentedViewInContainerView: CGRect {
//        guard let containerViewBounds = containerView?.bounds else { return .zero }
//        let height = containerViewBounds.height / 2
//        let yPos = containerViewBounds.height - height
//        return CGRect(x: 0, y: yPos, width: containerViewBounds.width, height: height)
//    }
//    
//    override func containerViewDidLayoutSubviews() {
//        super.containerViewDidLayoutSubviews()
//        presentedView?.frame = frameOfPresentedViewInContainerView
//    }
//}

import UIKit

class HalfScreenPresentationController: UIPresentationController {
    private var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerViewBounds = containerView?.bounds else { return .zero }
        let height = containerViewBounds.height / 2
        let yPos = containerViewBounds.height - height
        return CGRect(x: 0, y: yPos, width: containerViewBounds.width, height: height)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmingView.frame = containerView?.bounds ?? .zero
        applyCornerRadius()
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedViewController.view)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.5
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
    
    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func applyCornerRadius() {
        presentedView?.layer.cornerRadius = 16
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
