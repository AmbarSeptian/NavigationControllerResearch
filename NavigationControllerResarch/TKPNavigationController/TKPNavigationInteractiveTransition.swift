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
    var isInteractionTransitionAllowed: Bool { get }
    var isPopAnimatorAnimating: Bool { get }
}

internal class TKPNavigationInteractiveTransition: UIPercentDrivenInteractiveTransition {
    /*
    `panGesture` -> used for swipe back in whole screen area
     screenEdgeGesture` -> used for swipe back only at left edge screen
     
    Why we need two `UIPanGestureRecognizer` to swipe back?
    let's say the current page in navigationController has horizontal scrollView
    and ideally, the `panGesture` should not be activated unless that scrollView
    reach the most left scroll area.
    But if a user wants to swipe back inside that horizontal scrollview that user can use screen edge area by using `screenEdgeGesture`
    */
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.handleGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    private lazy var screenEdgeGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer()
        gesture.edges = .left
        gesture.addTarget(self, action: #selector(self.handleGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    internal override var completionSpeed: CGFloat {
        get {
            return max(0.5, 1 - percentComplete)
        }   
        set{
            self.completionSpeed = newValue
        }
    }
    
    internal weak var delegate: TKPNavigationTransitionDelegate?
    internal weak var transitionContext: UIViewControllerContextTransitioning?
    
    /// Boolean value that indicates if the panGesture currently is being interacted
    internal var isInteracting: Bool = false
    
    // Bind the gesture to view (UINavigationController view in this case) to enable interact swipe back
    internal func bindPanGesture(to view: UIView) {
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(screenEdgeGesture)
    }
    
    @objc private func handleGesture(_ panGesture: UIPanGestureRecognizer) {
        guard let delegate = delegate else {
            assertionFailure("Delegate must not empty")
            return
        }
        
        let offset = panGesture.translation(in: panGesture.view)
        let velocity = panGesture.velocity(in: panGesture.view)
        
        // we only need handle when panGesture swipe from left to right
        let isGestureMovingToRight = velocity.x > 0
        
        switch panGesture.state {
        case .began:
            let popBackAllowed = delegate.isInteractionTransitionAllowed
            //            let position = panGesture.location(in: panGesture.view) //EDIT
            if !delegate.isPopAnimatorAnimating && popBackAllowed{
                isInteracting = true
                
                if isGestureMovingToRight {
                    delegate.triggerPopViewController()
                }
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
            isInteracting = false
            cancel()
        case .possible, .failed:
            break
            
        @unknown default:
            break
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        self.transitionContext = transitionContext
    }
    
    override func cancel() {
        super.cancel()
    }
    
}

extension TKPNavigationInteractiveTransition: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture,
            let otherPanGesture = otherGestureRecognizer as? UIPanGestureRecognizer,
            let scrollView = otherPanGesture.view as? UIScrollView {
            if scrollView.contentOffset.x > 0 {
                return false
            }
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == screenEdgeGesture {
            return true
        }
        
        return false
    }
}
