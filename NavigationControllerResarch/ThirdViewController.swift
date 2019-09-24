
//
//  ThirdViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 14/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    var someClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barButton = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(pushVC))
        navigationItem.rightBarButtonItem = barButton
        
        view.backgroundColor = .white
        tkpNavigationItem.setTitleView(setupSearchBar())
    }
    
    private func setupSearchBar() -> UISearchBar {
           let searchBar = UISearchBar(frame: .zero)
           searchBar.placeholder = "Cari di Tokopedia"
           searchBar.sizeToFit()
           searchBar.searchBarStyle = .minimal
           searchBar.isUserInteractionEnabled = true
           searchBar.tintColor = .white
           searchBar.placeholder = "Cari Hehe"
           
           return searchBar
       }
      
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @objc func pushVC() {
        let vc = SecondViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
          dismiss(animated: true, completion: nil)
      }

}
