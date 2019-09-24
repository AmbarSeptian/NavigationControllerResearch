//
//  TKPNavigationPushAnimator.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 11/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

internal class TKPNavigationPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            assertionFailure("Previous ViewController while transitioning not found")
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            assertionFailure("Next ViewController while transitioning not found")
            return
        }
        
        guard let tkpNavigationBar = fromVC.navigationController?.navigationBar as? TKPNavigationBar else {
            assertionFailure("Previous Controller Navbar should be TKPNavigationBar")
            return
        }
        
        let nextStyle = toVC.tkpNavigationItem.backgroundStyle
        let containerView = transitionContext.containerView
        let shadowMask = UIView(frame: containerView.bounds)
        shadowMask.backgroundColor = .black
        shadowMask.alpha = 0
        
        containerView.addSubview(shadowMask)
        containerView.addSubview(toVC.view)
        
        let originFrame = fromVC.view.frame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalFrame.offsetBy(dx: finalFrame.width, dy: 0)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            
            toVC.view.frame = finalFrame
            let finalFromFrame = originFrame.offsetBy(dx: -originFrame.width, dy: 0)
            fromVC.view.frame = finalFromFrame
            shadowMask.alpha = 0.1
            tkpNavigationBar.backgroundStyle = nextStyle
            
        }) { _ in
            fromVC.view.frame = originFrame
            shadowMask.removeFromSuperview()
            
            let completeTransition = !(transitionContext.transitionWasCancelled)
            transitionContext.completeTransition(completeTransition)
        }
    }
}
