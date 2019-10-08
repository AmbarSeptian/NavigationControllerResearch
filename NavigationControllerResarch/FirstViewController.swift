//
//  FirstViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 05/09/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
//        navigationItem.title = "AAAAVVVV"
        
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.backgroundColor = .clear
        
        let barButton = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(self.pushVC))
//        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-back"), style: .plain, target: self, action: #selector(self.pushVC))
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 20
        let anotherButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-back"), style: .plain, target: self, action: #selector(self.pushVC))
        navigationItem.rightBarButtonItems = [barButton, space, anotherButton]
    
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        let someView = UIView()
        someView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        someView.frame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        view.addSubview(someView)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut, .autoreverse, .repeat], animations: {
            someView.frame.origin.y = someView.frame.origin.y + someView.frame.height / 2
        }, completion: nil)
        
        tkpNavigationItem.backgroundStyle = .basic
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tkpNavigationItem.title = "Dynamic Title"
//        tkpNavigationItem.layout()
    }
    

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func pushVC() {
        let vc = SecondViewController()
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
}

extension UINavigationController {
    func changeBackgroundColor(color: UIColor) {
//        navigationBar.isTranslucent = false
//        navigationBar.backgroundColor = .clear
//        navigationController?.view.backgroundColor = .clear
//        navigationBar.shadowImage = UIImage()
//        let backgroundImage = UIImage(color: color)
//        self.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        
    }
}


extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
