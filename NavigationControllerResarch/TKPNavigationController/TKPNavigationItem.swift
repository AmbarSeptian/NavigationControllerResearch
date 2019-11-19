//
//  TKPNavigationItem.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 14/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import AsyncDisplayKit

public class TKPNavigationItem: NSObject {
    private weak var navigationItem: UINavigationItem?
    
    internal lazy var headerNode: TKPNavigationHeaderNode = {
        return TKPNavigationHeaderNode()
    }()
    
    public enum BackgroundStyle {
        case basic
        case transparent
        
        internal var color: UIColor {
            switch self {
            case .basic:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .transparent:
                return .clear
            }
        }
    }
    
    public var backgroundStyle: BackgroundStyle = .basic {
        didSet {
            didBackgroundStyleChanged?(backgroundStyle)
        }
    }
    
    internal var didBackgroundStyleChanged: ((_ backgroundStyle: BackgroundStyle) -> ())?
    
    internal init(_ navigationItem: UINavigationItem?) {
        self.navigationItem = navigationItem
        navigationItem?.leftItemsSupplementBackButton = true
        super.init()
        self.commonInit()
    }
    
    public var hidesBackButton: Bool {
        get {
            return navigationItem?.hidesBackButton ?? false
        }
        set {
            navigationItem?.hidesBackButton = newValue
        }
    }
    
    public var title: String? {
        get {
            return headerNode.title
        }
        
        set {
            setDefaultHeaderViewIfNeeded()
            headerNode.title = newValue
        }
    }
    
    public var subtitle: String? {
        get {
            return headerNode.subtitle
        }
        
        set {
            setDefaultHeaderViewIfNeeded()
            headerNode.subtitle = newValue
        }
    }
    
    public var rightBarButtonItems: [UIBarButtonItem] {
        get {
            return navigationItem?.rightBarButtonItems ?? []
        }
        
        set {
            let newBarButtons = newValue.map({ createNewBarButton($0) })
            navigationItem?.rightBarButtonItems = newBarButtons
        }
    }
    
    public var rightBarButtonItem: UIBarButtonItem? {
        get {
            return navigationItem?.rightBarButtonItem
        }
        
        set {
            navigationItem?.rightBarButtonItem = newValue
        }
    }
    
    public func setTitleView(_ view: UIView) {
        navigationItem?.titleView = view
    }
    
    private func setDefaultHeaderViewIfNeeded() {
        guard navigationItem?.titleView != headerNode.view else { return }
        configureTitleView()
    }
    
    private func commonInit() {
        configureBackButton()
        configureTitleView()
    }
    
    private func configureBackButton() {
        let emptyButton = UIView()
        emptyButton.frame = CGRect.zero
        let barButton = UIBarButtonItem(customView: emptyButton)
        barButton.title = ""
        
        navigationItem?.backBarButtonItem = barButton
    }
    
    private func configureTitleView() {
        navigationItem?.titleView = headerNode.view
        
    }
    
    private func createNewBarButton(_ barButton: UIBarButtonItem) -> UIBarButtonItem {
        /* Fix bug UIBarButton title keeps highlighted after swiped back from previous controller by creating new UIBarButton using `UIButton` as customView
         Bug report: http://www.openradar.me/35991203
         
         Already tried using this approach but doesn't work:
         https://stackoverflow.com/questions/47754472/ios-uinavigationbar-button-remains-faded-after-segue-back
        */
        if let title = barButton.title {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            if let target = barButton.target, let action = barButton.action {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
            barButton.customView = button
            return barButton
        }
        
        return barButton
    }
}


internal class TKPNavigationHeaderNode: ASDisplayNode {
    private let titleNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        return node
    }()
    
    private let subtitleNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        return node
    }()
    
    internal var title: String? {
        didSet {
            defer {
                transitionLayout()
            }
            guard let title = title else {
                titleNode.attributedText = nil
                return
            }
            titleNode.attributedText = NSAttributedString(string: title,
                                                          attributes: nil)
        }
    }
    
    internal var subtitle: String? {
        didSet {
            defer {
                transitionLayout()
            }
            
            guard let subtitle = subtitle else {
                subtitleNode.attributedText = nil
                return
            }
            subtitleNode.attributedText = NSAttributedString(string: subtitle, attributes: nil)
        }
    }
    
    internal override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = NSAttributedString(string: "Header", attributes: [:])
        subtitleNode.attributedText = nil
        subtitleNode.style.flexShrink = 1
        
        backgroundColor = .gray
        displaysAsynchronously = false
    }
    
    internal override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 2,
                                 justifyContent: .center,
                                 alignItems: .stretch,
                                 children: [titleNode, subtitleNode])
    }
    
    private func transitionLayout() {
        DispatchQueue.main.async {
            self.transitionLayout(withAnimation: false, shouldMeasureAsync: true)
        }
    }
}
