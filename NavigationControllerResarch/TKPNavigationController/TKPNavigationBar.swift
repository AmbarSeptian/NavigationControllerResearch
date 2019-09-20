//
//  TKPNavigationBar.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 16/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

public class TKPNavigationBar: UINavigationBar {
    private let navigationView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowRadius = 2
        return view
    }()
    
    internal var backgroundStyle: TKPNavigationItem.BackgroundStyle = .basic {
        didSet {
            changeBackgroundColor(with: backgroundStyle)
        }
    }
    
    public override var items: [UINavigationItem]? {
        didSet {
            items?.forEach({ item in
                self.setupNavigationItemListener(item.tkpNavigationItem)
            })
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        navigationView.layer.zPosition = -1
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        navigationView.frame = CGRect(x: 0,
                                      y: -statusBarHeight,
                                      width: bounds.width,
                                      height: bounds.height + statusBarHeight)
        
        let shadowRect = CGRect(x: 0,
                                y: navigationView.bounds.height,
                                width: navigationView.bounds.width,
                                height: 1)
        navigationView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        
        guard let topTitleView = topItem?.titleView else { return }
        topTitleView.frame = CGRect(x: topTitleView.frame.origin.x,
                                    y: 0,
                                    width: topTitleView.frame.width,
                                    height: bounds.height)
        print(topTitleView.frame)
        
     }
    
    
    private func commonInit() {
        configureBackButtonImage()
        
        // we need to set translucent to `true` and set empty UIImage so we can set transparent navigationbar
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        
        // override shadowImage because in iOS 13 we can't toggle show `shadowImage`
        // property by set to nil, so we need to hide `shadowImage` and use our custom shadow on `navigationView` property
        shadowImage = UIImage()
        
        
        insertSubview(navigationView, at: 0)
        changeBackgroundColor(with: backgroundStyle)
    }
    
    private func configureBackButtonImage() {
        guard let backButtonImage = UIImage(named: "left_arrow") else {
            assertionFailure("Custom back button image not found")
            return
        }
        
        backIndicatorImage = backButtonImage
        backIndicatorTransitionMaskImage = backButtonImage
    }
    
    private func setupNavigationItemListener(_ item: TKPNavigationItem) {
        item.didBackgroundStyleChanged =  { [weak self] newStyle in
            self?.backgroundStyle = newStyle
        }
    }
    
    private func changeBackgroundColor(with backgroundStyle: TKPNavigationItem.BackgroundStyle) {
        // if the backgroundStyle is transparent, we need to set `shadowOpacity` to `zero`
        let shadowOpacity: Float = backgroundStyle == .transparent ? 0 : 1
        navigationView.layer.shadowOpacity = shadowOpacity
        navigationView.backgroundColor = backgroundStyle.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func pushItem(_ item: UINavigationItem, animated: Bool) {
        super.pushItem(item, animated: true)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public override func setItems(_ items: [UINavigationItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
    }
    
}
