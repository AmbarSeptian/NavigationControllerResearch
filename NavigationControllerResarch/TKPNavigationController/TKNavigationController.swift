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
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: TKPNavigationBar.self, toolbarClass: nil)
        setViewControllers([rootViewController], animated: false)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

internal class BackupTKPNavigationItem: UINavigationItem {
    init() {
        super.init(title: "sdfsdf")
        title = "asdfsdf"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

public class TKPNavigationBar: UINavigationBar {
    weak var navigationController: UINavigationController?
    
    public override var backgroundColor: UIColor? {
        get { return .blue }
        set {}  
    }

//    public override var items: [UINavigationItem]? {
//        get { return _items }
//        set {
//
//            let newItems = newValue?.map { item -> BackupTKPNavigationItem in
//                if let tkpNavigationItem = item as? BackupTKPNavigationItem {
//                    return tkpNavigationItem
//                } else {
//                    let tkpNavigationItem = BackupTKPNavigationItem()
//                    tkpNavigationItem.title = "AAA"
//                    return tkpNavigationItem
//                }
//            }
//            _items = newItems
//            super.setItems(newItems, animated: false)
//        }
//    }
    
    private var _items: [BackupTKPNavigationItem]?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        barTintColor = .blue
        commonInit()
    }
    
    private func commonInit() {
        configureBackButtonImage()
    }
    
    private func configureBackButtonImage() {
        let backImage = UIImage(named: "icon-back")
        backIndicatorImage = backImage
        backIndicatorTransitionMaskImage = backImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func pushItem(_ item: UINavigationItem, animated: Bool) {
        super.pushItem(item, animated: true)
    }
    
    public override func setItems(_ items: [UINavigationItem]?, animated: Bool) {
        let newItems = items?.compactMap { item -> BackupTKPNavigationItem in
            let newItem = BackupTKPNavigationItem()
            newItem.title = item.title
            newItem.rightBarButtonItems = item.rightBarButtonItems
            return newItem
        }
//        self._items = newItems
        items?.forEach({ item in
             let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
             item.backBarButtonItem = barButton
        })
        super.setItems(items, animated: animated)
    }
    
}

extension TKPNavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        item.backBarButtonItem = barButton

    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        
    }
}




extension UINavigationController {
    private struct TKPAssociatedKey {
        static var navBar = "NavBarAssociatedKey"
    }
    
    public var tkpNavigation: TKPNavigationBar {
        if let navbar = objc_getAssociatedObject(self, &TKPAssociatedKey.navBar) as? TKPNavigationBar {
            return navbar
        }
        let navbar = TKPNavigationBar()
        objc_setAssociatedObject(self, &TKPAssociatedKey.navBar, navbar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return navbar
    }
    
}


extension UIViewController {
    private struct TKPAssociatedKey {
           static var navBar = "NavBarAssociatedKey"
       }
    
    public var tkpNavigationItem: TKPNavigationItem {
        if let navbarItem = objc_getAssociatedObject(self, &TKPAssociatedKey.navBar) as? TKPNavigationItem {
            return navbarItem
        }
        let navbarItem = TKPNavigationItem(navigationItem)
        objc_setAssociatedObject(self,
                                 &TKPAssociatedKey.navBar,
                                 navbarItem,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return navbarItem
    }
}
