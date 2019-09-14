//
//  TKPNavigationPopAnimator.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 11/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class TKPNavigationPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            assertionFailure("Previous ViewController while transitioning not found")
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            assertionFailure("Next ViewController while transitioning not found")
            return
        }
        
        let toColor = toVC.tkpNavigationItem.backgroundStyle.color
    
        let containerView = transitionContext.containerView
        let shadowMask = UIView(frame: containerView.bounds)
        shadowMask.backgroundColor = .black
        shadowMask.alpha = 0.3
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalFrame.offsetBy(dx: -finalFrame.width / 2, dy: 0)
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.insertSubview(shadowMask, aboveSubview: toVC.view)
        
        let fromTitleFrame = fromVC.navigationItem.titleView?.frame
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            fromVC.view.frame = fromVC.view.frame.offsetBy(dx: fromVC.view.frame.width, dy: 0)
            toVC.view.frame = finalFrame
            shadowMask.alpha = 0
            fromVC.navigationController?.navigationBar.barTintColor = toColor
        }) { _ in
            shadowMask.removeFromSuperview()
            let completeTransition = !(transitionContext.transitionWasCancelled)
        transitionContext.completeTransition(completeTransition)
        }
        
    }
}
