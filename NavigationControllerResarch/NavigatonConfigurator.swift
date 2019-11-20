//
//  NavigatonConfigurator.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 27/10/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

struct NavigatorConfigurator {
    var backgroundStyle: TKPNavigationItem.BackgroundStyle
    var title: String?
    var subtitle: String?
    var useCustomTitleView: Bool
    var hidesBackButton: Bool
    var hidesSeparator: Bool
    var barButtons: [UIBarButtonItem]
    
    static let defaultValue: NavigatorConfigurator = {
          return NavigatorConfigurator(backgroundStyle: .basic,
                                       title: "Title Goes here",
                                       subtitle: "Subtitle Goes Here",
                                       useCustomTitleView: false,
                                       hidesBackButton: false,
                                       hidesSeparator: false,
                                       barButtons: [UIBarButtonItem(title: "Button",
                                                                    style: .plain,
                                                                    target: nil,
                                                                    action: nil)])
      }()
}

enum NavigatorConfiguratorList: Int, CaseIterable {
    case backgroundStyle = 0
    case title
    case subtitle
    case useCustomTitleView
    case hidesBackButton
    case hidesSeparator
    case addBarButton
    case pushViewController
    
    var title: String {
        switch self {
        case .backgroundStyle:
            return "Set Background Transparent"
        case .title:
            return "Change Title"
        case .subtitle:
            return "Subtitle"
        case .useCustomTitleView:
            return "Use Custom TitleView"
        case .hidesBackButton:
            return "Hide Back Button"
        case .hidesSeparator:
            return "Hide Separator"
        case .addBarButton:
            return "Add Right Bar Button"
        case .pushViewController:
            return "Push ViewController"
        }
    }
}
