
//
//  ThirdViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 14/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import AsyncDisplayKit

class ThirdViewController: UIViewController {
    var someClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barButton = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(pushVC))
        navigationItem.rightBarButtonItem = barButton
        
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//        tkpNavigationItem.setTitleView(setupSearchBar())
        let someView = UIView()
        someView.backgroundColor = .red
        someView.frame.size = CGSize(width: 300, height: 100)
        
        tkpNavigationItem.subtitle = nil
        
        let view = UIView()
        view.backgroundColor = .red
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 100)
        self.view.addSubview(view)
    }
    
    private func setupSearchBar() -> UISearchBar {
       let searchBar = UISearchBar(frame: .zero)
       searchBar.placeholder = "Cari di Tokopedia"
       searchBar.sizeToFit()
       searchBar.searchBarStyle = .minimal
       searchBar.isUserInteractionEnabled = true
       searchBar.tintColor = .white
       
       return searchBar
    }

    @objc func pushVC() {
        let vc = FirstViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
          dismiss(animated: true, completion: nil)
      }

}
