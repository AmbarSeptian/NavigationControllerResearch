
//
//  ThirdViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 14/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let barButton = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(pushVC))
        navigationItem.rightBarButtonItem = barButton
        
    }
    

    @objc func pushVC() {
        let vc = FirstViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
