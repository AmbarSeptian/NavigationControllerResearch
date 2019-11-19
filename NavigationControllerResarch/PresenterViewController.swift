//
//  PresenterViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 16/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import AsyncDisplayKit
import UIKit
import RxCocoa
import RxSwift

class PresenterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let customNavButton = UIButton(type: .system)
        customNavButton.setTitle("Present Custom Navigation", for: .normal)
        customNavButton.addTarget(self, action: #selector(self.presentVC), for: .touchUpInside)
        view.addSubview(customNavButton)
        
        let regularNavButton = UIButton(type: .system)
        regularNavButton.setTitle("Present Regular Navigation", for: .normal)
        regularNavButton.addTarget(self, action: #selector(self.presentRegularVC), for: .touchUpInside)
        view.addSubview(regularNavButton)
        
        customNavButton.frame = CGRect(x: 100, y: 300 , width: 200, height: 100)
        regularNavButton.frame = CGRect(x: 100, y: 400 , width: 200, height: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    @objc func presentVC() {
        let vc = FirstViewController()
               
        let nav = TKPNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func presentRegularVC() {
        let vc = NavigationConfiguratorViewController()
               
        let nav = TKPNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
