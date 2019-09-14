//
//  TKPNavigationItem.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 14/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import AsyncDisplayKit

public class TKPNavigationItem: NSObject {
    private let navigationItem: UINavigationItem
    private lazy var titleNode: TKPNavigationTitleNode = {
      return TKPNavigationTitleNode()
    }()
    
    init(_ navigationItem: UINavigationItem) {
        self.navigationItem = navigationItem
        super.init()
        self.configure()
    }
    
    internal func configure() {
        configureBackButton()
        configreTitleView()
    }
    
    private func configureBackButton() {
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = barButton
    }
    
    private func configreTitleView() {
        navigationItem.titleView = titleNode.view
    }
    
    public var hidesBackButton: Bool {
        get {
            navigationItem.hidesBackButton
        }
        set {
            navigationItem.hidesBackButton = newValue
        }
    }
    
    public var title: String? {
        get {
            navigationItem.title
        }
        
        set {
            navigationItem.title = newValue
        }
    }
    
    public func layout() {
        navigationItem.titleView?.layoutIfNeeded()
    }
}



class TKPNavigationTitleNode: ASDisplayNode {
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
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        titleNode.attributedText = NSAttributedString(string: "Header", attributes: [:])
        subtitleNode.attributedText = NSAttributedString(string: "Subtitle", attributes: [:])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 2,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: [titleNode, subtitleNode])
    }
    
    func setTitle(_ title: String) {
        
    }
}
