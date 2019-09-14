//
//  NavigationBarColorable.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 09/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit
/// Navigation bar colors for `ColorableNavigationController`, called on `push` & `pop` actions
public protocol NavigationBarColorable: class {
    var navigationTintColor: UIColor? { get }
    var navigationBarTintColor: UIColor? { get }
}

public extension NavigationBarColorable {
    var navigationTintColor: UIColor? { return nil }
}

/**
 UINavigationController with different colors support of UINavigationBar.
 To use it please adopt needed child view controllers to protocol `NavigationBarColorable`.
 - note: Don't forget to set initial tint and barTint colors
 */
open class ColorableNavigationController: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        navigationBar.isTranslucent = false
        guard let viewController = rootViewController as? NavigationBarColorable else {
            return
        }
        setNavigationBarColors(viewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var previousViewController: UIViewController? {
        guard viewControllers.count > 1 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let colors = viewController as? NavigationBarColorable {
            self.setNavigationBarColors(colors)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        if let colors = self.previousViewController as? NavigationBarColorable {
            self.setNavigationBarColors(colors)
        }
        
        // Let's start pop action or we can't get transitionCoordinator()
        let popViewController = super.popViewController(animated: animated)
        
        // Secure situation if user cancelled transition
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] (context) in
            guard let colors = self?.topViewController as? NavigationBarColorable else { return }
            self?.setNavigationBarColors(colors)
        })
        
        return popViewController
    }
    
    private func setNavigationBarColors(_ colors: NavigationBarColorable) {
//        if let tintColor = colors.navigationTintColor {
//            self.navigationBar.tintColor = tintColor
//        }
//
//        self.navigationBar.barTintColor = colors.navigationBarTintColor
        
        
        changeBackgroundColor(color:
            colors.navigationBarTintColor ?? .white)
    }
}

//
//class RainbowPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    var animating = false
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.2
//    }
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
//        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
//        
//        let fromColorSource = fromVC as? RainbowColorSource
//        let toColorSource = toVC as? RainbowColorSource
//        
//        var nextColor:UIColor?
//        nextColor = fromColorSource?.navigationBarOutColor?()
//        nextColor = toColorSource?.navigationBarInColor?()
//        
//        let containerView = transitionContext.containerView
//        let shadowMask = UIView(frame: containerView.bounds)
//        shadowMask.backgroundColor = UIColor.black
//        shadowMask.alpha = 0.3
//        
//        let finalToFrame = transitionContext.finalFrame(for: toVC)
//        toVC.view.frame = finalToFrame.offsetBy(dx: -finalToFrame.width/2, dy: 0)
//        
//        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
//        containerView.insertSubview(shadowMask, aboveSubview: toVC.view)
//        
//        let duration = self.transitionDuration(using: transitionContext)
//        
//        animating = true
//        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
//            fromVC.view.frame = fromVC.view.frame.offsetBy(dx: fromVC.view.frame.width, dy: 0)
//            toVC.view.frame = finalToFrame
//            shadowMask.alpha = 0
//            if let navigationColor = nextColor {
//                fromVC.navigationController?.navigationBar.rb.backgroundColor = navigationColor
//            }
//            
//            }) { (finished) -> Void in
//                self.animating = false
//                shadowMask.removeFromSuperview()
//                
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//}
