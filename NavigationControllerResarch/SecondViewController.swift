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
        tkpNavigationItem.subtitle = "Some title here"
//        navigationItem.titleView?.layoutIfNeeded()
        
        let barButton = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(self.pushVC))
        navigationItem.rightBarButtonItem = barButton
        
        tkpNavigationItem.backgroundStyle = .transparent
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
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
        vc.someClosure = {
            print("#1")
        }
        vc.someClosure = {
            print("#2")
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.contentView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popToRootViewController(animated: true)
    }
}
