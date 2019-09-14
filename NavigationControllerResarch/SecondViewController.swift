//
//  SecondViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 05/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    
        tkpNavigationItem.title = "Second"
        navigationItem.titleView?.layoutIfNeeded()
        
        let barButton = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(self.pushVC))
        navigationItem.rightBarButtonItem = barButton
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.changeBackgroundColor(color: .blue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func pushVC() {
        let vc = ThirdViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.contentView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return cell
    }
}
