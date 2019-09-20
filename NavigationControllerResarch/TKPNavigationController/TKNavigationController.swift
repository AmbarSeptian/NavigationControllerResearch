//
//  TKNavigationController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 11/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class TKPNavigationController: UINavigationController {
    
    private let pushAnimator = TKPNavigationPushAnimator()
    private let popAnimator = TKPNavigationPopAnimator()
    
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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
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
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return pushAnimator
        case .pop, .none:
            return popAnimator
        @unknown default:
            return nil
        }
        
    }
}


extension TKPNavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {

    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        
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
