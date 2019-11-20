//
//  TKNavigationController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 11/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

public class TKPNavigationController: UINavigationController {
    
    private let pushAnimator = TKPNavigationPushAnimator()
    private let popAnimator = TKPNavigationPopAnimator()
    private let interactiveTransition = TKPNavigationInteractiveTransition()
    
    private var tkpNavigationBar: TKPNavigationBar {
        guard let navigationBar = navigationBar as? TKPNavigationBar else {
            fatalError("NavigationBar class should be `TKPNavigationBar`")
        }
        
        return navigationBar
    }
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: TKPNavigationBar.self, toolbarClass: nil)
        setViewControllers([rootViewController], animated: false)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        /* We need to override this method, because on iOS 10
         before `init(rootViewController: UIViewController)` called this
         method will be called and it should be implemented else fatalError will occur
         */
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        interactiveTransition.delegate = self
        interactiveTransition.bindPanGesture(to: view)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        guard let initialBackgroundStyle = topViewController?.tkpNavigationItem.backgroundStyle else { return }
        tkpNavigationBar.backgroundStyle = initialBackgroundStyle
    }
}


extension TKPNavigationController: UINavigationControllerDelegate  {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return pushAnimator
        case .pop, .none:
            return popAnimator
        @unknown default:
            return nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isInteracting ? interactiveTransition : nil
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
      
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
 
    }
}

extension TKPNavigationController: TKPNavigationTransitionDelegate {
    internal func triggerPopViewController() {
        popViewController(animated: true)
    }
    
    internal var isInteractionTransitionAllowed: Bool {
        if let hidesBackButton = navigationBar.topItem?.hidesBackButton {
            return !hidesBackButton
        }
        
        return true
    }
    
    internal var isPopAnimatorAnimating: Bool {
        print("::Animator \(popAnimator.isAnimating)")
        return popAnimator.isAnimating
    }
}


extension UINavigationItem {
    private struct TKPAssociatedKey {
          static var navigationItem = "NavigationItemAssociatedKey"
      }
   
   public var tkpNavigationItem: TKPNavigationItem {
       if let navbarItem = objc_getAssociatedObject(self, &TKPAssociatedKey.navigationItem) as? TKPNavigationItem {
           return navbarItem
       }
       let navbarItem = TKPNavigationItem(self)
       objc_setAssociatedObject(self,
                                &TKPAssociatedKey.navigationItem,
                                navbarItem,
                                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
       return navbarItem
   }
}


extension UIViewController {
    public var tkpNavigationItem: TKPNavigationItem {
        navigationItem.tkpNavigationItem
    }
}
