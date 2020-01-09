//
//  TKPNavigationItem.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 14/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

internal protocol TKPNavigationItemDelegate: AnyObject {
    func didBackgroundStyleChanged(_ backgroundStyle: TKPNavigationItem.BackgroundStyle)
    func didToggleHideSeparator(_ isHidden: Bool)
    func didScroll(yOffset: CGFloat)
}

public class TKPNavigationItem: NSObject {
    private weak var navigationItem: UINavigationItem?
    
    internal lazy var headerNode: TKPNavigationHeaderNode = {
        return TKPNavigationHeaderNode()
    }()
    
    public enum BackgroundStyle {
        case basic
        case transparent
        case automatic
        
        internal var color: UIColor {
            switch self {
            case .basic:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .automatic:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .transparent:
                return .clear
            }
        }
    }
    
    public var backgroundStyle: BackgroundStyle = .basic {
        didSet {
            delegate?.didBackgroundStyleChanged(backgroundStyle)
        }
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
    
    public var isSepatorHidden: Bool = true {
        didSet {
            delegate?.didToggleHideSeparator(isSepatorHidden)
        }
    }
    
    public weak var scrollView: UIScrollView? {
        didSet {
            guard let scrollView = scrollView else { return }
            setupScrollListener(scrollView)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    internal weak var delegate: TKPNavigationItemDelegate?
    
    internal init(_ navigationItem: UINavigationItem?) {
        self.navigationItem = navigationItem
        navigationItem?.leftItemsSupplementBackButton = true
        super.init()
        self.commonInit()
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
    
    private func setupScrollListener(_ scrollView: UIScrollView) {
        scrollView.rx.observeWeakly(CGPoint.self, "contentOffset")
            .filter { [weak self] _ -> Bool in
//                return self?.backgroundStyle == .automatic
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
            .map({ $0?.y ?? .zero}) // TODO: filterNIl()
            .drive(onNext: { [weak self] yOffset in
                self?.adjustNavigationOnScroll(by: yOffset)
            }).disposed(by: disposeBag) // TODO: rx_disposeBag
    }
    
    private func adjustNavigationOnScroll(by yOffset: CGFloat) {
        if yOffset > 44 {
            print("::PUTIH")
        } else {
            print("::TRANSPARENT")
        }// TODO
        delegate?.didScroll(yOffset: yOffset)
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
