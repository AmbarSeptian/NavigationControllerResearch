//
//  TKPNavigationHeader.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 20/11/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import AsyncDisplayKit

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
