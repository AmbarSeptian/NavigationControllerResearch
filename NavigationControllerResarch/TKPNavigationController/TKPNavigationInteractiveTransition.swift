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
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.handleGesture(_:)))
        gesture.delegate = self
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
    internal weak var transitionContext: UIViewControllerContextTransitioning?

    /// Boolean value that indicates if the panGesture currently is being interacted
    internal var isInteracting: Bool = false
    
    internal func bindPanGesture(to view: UIView) {
        view.addGestureRecognizer(panGesture)
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
            if !delegate.isPopAnimatorAnimating {
                isInteracting = true
                
                if isGestureMovingToRight {
                    delegate.triggerPopViewController()
                    print("::Began")
                }
            }
            
        case .changed:
            guard isInteracting, let view = panGesture.view else { return }
            
            let progress = max(0, offset.x / view.bounds.width)
            self.update(progress)
            print("::Update \(progress) - \(offset.x)")
        case .ended:
            guard isInteracting else { return }
            
            if isGestureMovingToRight {
                print("::Finish \(percentComplete)")
                self.finish()
            } else {
                self.cancel()
                print("::Cancel \(percentComplete)")
            }
            isInteracting = false
            
        case .cancelled:
            guard isInteracting else { return }
            isInteracting = false
            cancel()
            print("::CancelA")
        case .possible, .failed:
            print("::Break \(panGesture.state)")
            break
            
        @unknown default:
            print("::Break \(panGesture.state)")
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
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
////        if gestureRecognizer == panGesture, let otherPanGesture = otherGestureRecognizer as? UIPanGestureRecognizer, let scrollView = otherPanGesture.view as? UIScrollView {
////            if scrollView.contentOffset.x > 0 {
////                print("::Pager")
////                return false
////            }
////        }
////        print("::PanGesture")
//        return true
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return true
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let otherPanGesture = otherGestureRecognizer as? UIPanGestureRecognizer, let scrollView = otherPanGesture.view as? UIScrollView {
//            if scrollView.contentOffset.x > 0 {
//                return true
//            }
//        }
//        return false
//    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let otherPanGesture = otherGestureRecognizer as? UIPanGestureRecognizer, let scrollView = otherPanGesture.view as? UIScrollView {
//
//        }
//        return true
//    }
}
