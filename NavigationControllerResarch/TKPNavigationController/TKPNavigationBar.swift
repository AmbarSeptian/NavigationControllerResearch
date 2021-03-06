//
//  TKPNavigationBar.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 16/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

public class TKPNavigationBar: UINavigationBar {
    // The view that we used for replacement background view of navigationBar
    // We can use native background navigationBar and use `setBackgroundImage` for backgroundColor but we need to achive smooth transition when navigation pushed or popped so use a customView is better approach
    // Another approach is use private api `valueForKey(_backgroundView)` to get `UIView` from navigationBar but it's hacky way and unsafe
    private let navigationView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.clipsToBounds = false
        view.autoresizingMask = [.flexibleWidth]
        return view
    }()
    
    // The view that we used for replacement `shadowImage` of navigationBar
    // Because `shadowImage` property of navigationBar doesn't work properly if you want toggle show or hide with `isTranslucent` property value is `true`.
    // We can use `navigationView.layer.shadow(s)` property to achive this, but it will show glitch whenever navigation push or popped because animate layer we need `Core Animation`
    // So we use regular UIView then if we need animate it, then just animate the `alpha` use `UIView.animateWithDuration`
    private let shadowView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowRadius = 0.5
        view.autoresizingMask = [.flexibleWidth]
        return view
    }()
    
    internal var backgroundStyle: TKPNavigationItem.BackgroundStyle = .basic {
        didSet {
            changeBackgroundColor(with: backgroundStyle)
        }
    }
    
    internal var isSeparatorHidden: Bool = false {
        didSet {
            toggleHideSeparator(isSeparatorHidden)
        }
    }
    
    public override var items: [UINavigationItem]? {
        didSet {
            items?.forEach({ item in
                item.tkpNavigationItem.delegate = self
            })
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.layer.zPosition = -2
        navigationView.layer.zPosition = -1
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        navigationView.frame = CGRect(x: 0,
                                      y: -statusBarHeight,
                                      width: bounds.width,
                                      height: bounds.height + statusBarHeight)
        
        shadowView.frame = CGRect(x: 0,
                                  y: bounds.height,
                                  width: navigationView.bounds.width, height: 0.5)
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        
        guard let topItem = topItem else { return }
        updateNavigationItemLayout(topItem)
    }
    
    public override func pushItem(_ item: UINavigationItem, animated: Bool) {
        updateNavigationItemLayout(item)
        super.pushItem(item, animated: true)
    }
    
    
    private func commonInit() {
        configureBackButtonImage()
        
        // we need to set translucent to `true` and set empty UIImage so we can set transparent navigationbar
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        
        // override shadowImage because in iOS 13 we can't toggle show `shadowImage`
        // property by set to nil, so we need to hide `shadowImage` and use our custom shadow on `shadowView` property
        shadowImage = UIImage()
        
        insertSubview(navigationView, at: 0)
        insertSubview(shadowView, belowSubview: navigationView)
        changeBackgroundColor(with: backgroundStyle)
    }
    
    private func configureBackButtonImage() {
        guard let backButtonImage = UIImage(named: "icon-back") else {
            assertionFailure("Custom back button image not found")
            return
        }
        backIndicatorImage = backButtonImage
        backIndicatorTransitionMaskImage = backButtonImage
    }
    
    private func changeBackgroundColor(with backgroundStyle: TKPNavigationItem.BackgroundStyle) {
        navigationView.backgroundColor = backgroundStyle.color
        toggleHideSeparator(isSeparatorHidden)
    }
    
    private func toggleHideSeparator(_ isHidden: Bool) {
        switch backgroundStyle {
        case .transparent:
            // We only need to hide / show the separator if backgroundStyle is not transparent
            // Ignore `isHidden` value
            shadowView.alpha = 0
        case .basic:
            // if the backgroundStyle is transparent, we need to set `shadowOpacity` to `zero`
            let shadowOpacity: CGFloat = isHidden ? 0 : 1
            shadowView.alpha = shadowOpacity
        case .automatic:
            let shadowOpacity: CGFloat = isHidden ? 0 : 1
            shadowView.alpha = shadowOpacity
        }
    }
    
    private func updateNavigationItemLayout(_ item: UINavigationItem) {
        guard let titleView = item.titleView else { return }
        titleView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: titleView.frame.width,
                                 height: bounds.height)
    }
    
}

extension TKPNavigationBar: TKPNavigationItemDelegate {
    public func didBackgroundStyleChanged(_ backgroundStyle: TKPNavigationItem.BackgroundStyle) {
        self.backgroundStyle = backgroundStyle
    }
    
    public func didToggleHideSeparator(_ isHidden: Bool) {
        isSeparatorHidden = isHidden
    }
    
    public func didScroll(yOffset: CGFloat) {
        let navBarHeight = bounds.height
        let alpha = min(yOffset / navBarHeight, 1)
        
        let basicColor = TKPNavigationItem.BackgroundStyle.basic.color
        navigationView.backgroundColor = basicColor.withAlphaComponent(alpha)
    }
}
