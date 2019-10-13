//
//  RegularViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 08/10/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class RegularViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Regular Navbar"
        let someView = UIView()
        someView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        someView.frame = CGRect(x: view.center.x - 50, y: 0, width: 100, height: 100)
        view.addSubview(someView)
    }
}
