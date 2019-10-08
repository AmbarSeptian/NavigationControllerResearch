//
//  PresenterViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 16/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class PresenterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.setTitle("Present", for: .normal)
        button.addTarget(self, action: #selector(self.presentVC), for: .touchUpInside)
        view.addSubview(button)
        
        button.frame = CGRect(x: 100, y: 300 , width: 100, height: 100)
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
}
