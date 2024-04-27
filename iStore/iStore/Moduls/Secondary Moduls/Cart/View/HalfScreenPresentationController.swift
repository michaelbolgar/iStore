import UIKit

class HalfScreenPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerViewBounds = containerView?.bounds else { return .zero }
        let height = containerViewBounds.height / 2
        let yPos = containerViewBounds.height - height
        return CGRect(x: 0, y: yPos, width: containerViewBounds.width, height: height)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
