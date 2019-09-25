//
//  TKPNavigationDrivenTransition.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 24/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

protocol TKPNavigationTransitionDelegate: class {
    func triggerPopViewController()
    var isViewControllersNotEmpty: Bool { get }
    var isPopAnimatorAnimating: Bool { get }
}

internal class TKPNavigationInteractiveTransition: UIPercentDrivenInteractiveTransition {
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.handleGesture(_:)))
        return gesture
    }()
    
    
    internal override var completionSpeed: CGFloat {
        get {
            print("::Name \(max(CGFloat(0.5), 1 - self.percentComplete))")
            return max(0.5, 1 - percentComplete)
        }
        set{
            self.completionSpeed = newValue
        }
    }
    
    internal weak var delegate: TKPNavigationTransitionDelegate?

    /// Boolean value that indicates if the panGesture currently is being interacted
    internal var isInteracting: Bool = false
    
    internal func bindPanGesture(to view: UIView) {
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleGesture(_ panGesture: UIPanGestureRecognizer) {
        let offset = panGesture.translation(in: panGesture.view)
        let velocity = panGesture.velocity(in: panGesture.view)

        // we only need handle when panGesture swipe from left to right
        let isGestureMovingToRight = velocity.x > 0
        
        switch panGesture.state {
        case .began:
            guard let delegate = delegate, !(delegate.isPopAnimatorAnimating) else {
                return
            }
            isInteracting = true
            
            if isGestureMovingToRight, delegate.isViewControllersNotEmpty {
                 delegate.triggerPopViewController()
            }
        case .changed:
            guard isInteracting, let view = panGesture.view else { return }
            
            let progress = max(0, offset.x / view.bounds.width)
            self.update(progress)
        case .ended:
            guard isInteracting else { return }
            
            if isGestureMovingToRight {
                self.finish()
            } else {
                self.cancel()
            }
            isInteracting = false
            
        case .cancelled:
            guard isInteracting else { return }
            
            cancel()
            isInteracting = false

        case .possible, .failed:
            break
        @unknown default:
            break
        }
    }
}
