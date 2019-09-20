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
        super.init()
        self.commonInit()
    }
    
    internal func commonInit() {
        configureBackButton()
        configreTitleView()
    }
    
    private func configureBackButton() {
        let emptyButton = UIView()
        emptyButton.frame = CGRect.zero
        let barButton = UIBarButtonItem(customView: emptyButton)
        navigationItem?.backBarButtonItem = barButton
    }
    
    private func configreTitleView() {
        navigationItem?.titleView = headerNode.view
    }
    
    public var hidesBackButton: Bool {
        get {
            navigationItem?.hidesBackButton ?? false
        }
        set {
            navigationItem?.hidesBackButton = newValue
        }
    }
    
    public var title: String? {
        get {
            headerNode.title
        }
        
        set {
            headerNode.title = newValue
        }
    }
    
    public var subtitle: String? {
       get {
           headerNode.subtitle
       }
       
       set {
           headerNode.subtitle = newValue
       }
    }
    
    
    internal func layout(_ height: CGFloat) {
        headerNode.setNeedsLayout()
        headerNode.layoutIfNeeded()
    }
}


class TKPNavigationHeaderNode: ASDisplayNode {
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
              guard let subtitle = subtitle else {
                  subtitleNode.attributedText = nil
                  return
              }
              subtitleNode.attributedText = NSAttributedString(string: subtitle, attributes: nil)
          }
      }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        titleNode.attributedText = NSAttributedString(string: "Header", attributes: [:])
        subtitleNode.attributedText = NSAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam", attributes: [:])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 2,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: [titleNode, subtitleNode])
    }
}
