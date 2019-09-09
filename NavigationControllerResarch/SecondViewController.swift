//
//  SecondViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 05/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.changeBackgroundColor(color: .blue)
        
        let barButton = UIBarButtonItem()
        barButton.title = "Sdfdsf"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "sdfsdfsd", style: .done, target: nil, action: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.changeBackgroundColor(color: .red)
    }
    
    @objc func barButton() {
        
    }
}
