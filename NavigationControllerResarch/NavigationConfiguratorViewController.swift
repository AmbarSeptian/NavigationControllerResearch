//
//  NavigationConfiguratorViewController.swift
//  NavigationControllerResarch
//
//  Created by Ambar Septian on 11/10/19.
//  Copyright © 2019 Ambar Septian. All rights reserved.
//

import UIKit

class NavigationConfiguratorViewController: UIViewController {
    
    let titleTextField = UITextField()
    let subtitleTextField = UITextField()
    let backgroundStyleSwitcher = UISwitch()
    let useCustomTitleViewSwitcher = UISwitch()
    let hidesBackButtonSwitcher = UISwitch()
    lazy var addBarButtonStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.addTarget(self,
                          action: #selector(self.barButtonStepperValueChanged(_:)),
                          for: .valueChanged)
        return stepper
    }()
    lazy var barButtonCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    let currentConfigurator: NavigatorConfigurator
    let tableView = UITableView()
    
    init(currentConfigurator: NavigatorConfigurator = .defaultValue) {
        self.currentConfigurator = currentConfigurator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        configureNavigator(configurator: currentConfigurator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigator(configurator: NavigatorConfigurator) {
        tkpNavigationItem.backgroundStyle = configurator.backgroundStyle
        
        if configurator.useCustomTitleView {
            
        } else {
            tkpNavigationItem.title = configurator.title
            tkpNavigationItem.subtitle = configurator.subtitle
        }
        
        tkpNavigationItem.hidesBackButton = configurator.hidesBackButton
        let barButtons = configurator.barButtons
        barButtons.forEach { [weak self] button in
            button.target = self
            button.action = #selector(self?.pushViewController)
        }
        tkpNavigationItem.rightBarButtonItems = barButtons
    }
    
    @objc func pushViewController() {
        let backgroundStyle: TKPNavigationItem.BackgroundStyle = backgroundStyleSwitcher.isOn ? .transparent : .basic
        let title = titleTextField.text
        let subtitle = subtitleTextField.text
        let useCustomTitleView = useCustomTitleViewSwitcher.isOn
        let hidesBackButton = hidesBackButtonSwitcher.isOn
        let barButtons = (0..<Int(addBarButtonStepper.value)).map { _ -> UIBarButtonItem in
            return UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        }
        
        let nextConfigurator = NavigatorConfigurator(backgroundStyle: backgroundStyle,
                                                     title: title,
                                                     subtitle: subtitle,
                                                     useCustomTitleView: useCustomTitleView,
                                                     hidesBackButton: hidesBackButton,
                                                     barButtons: barButtons)
        
        let nextVC = NavigationConfiguratorViewController(currentConfigurator: nextConfigurator)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func barButtonStepperValueChanged(_ stepper: UIStepper) {
        let value = max(0, Int(stepper.value))
        barButtonCountLabel.text = String(value)
    }
}


extension NavigationConfiguratorViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return NavigatorConfiguratorList.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        cell.selectionStyle = .none
        
        let contentFrame = CGRect(x: 10, y: 10, width: cell.contentView.bounds.width - 20, height: cell.contentView.bounds.height - 20)
        switch NavigatorConfiguratorList.allCases[indexPath.section] {
        case .title:
            cell.contentView.addSubview(titleTextField)
            titleTextField.placeholder = "Change Title"
            titleTextField.frame = contentFrame
        case .subtitle:
            cell.contentView.addSubview(subtitleTextField)
            subtitleTextField.placeholder = "Change Subtitle"
            subtitleTextField.frame = contentFrame
        case .backgroundStyle:
            cell.contentView.addSubview(backgroundStyleSwitcher)
            backgroundStyleSwitcher.frame = contentFrame
        case .hidesBackButton:
            cell.contentView.addSubview(hidesBackButtonSwitcher)
            hidesBackButtonSwitcher.frame = contentFrame
        case .useCustomTitleView:
            cell.contentView.addSubview(useCustomTitleViewSwitcher)
            useCustomTitleViewSwitcher.frame = contentFrame
        case .addBarButton:
            cell.contentView.addSubview(addBarButtonStepper)
            cell.contentView.addSubview(barButtonCountLabel)
            addBarButtonStepper.frame = CGRect(x: 10 ,
                                               y: 10,
                                               width: 100,
                                               height: 100)
            barButtonCountLabel.frame = CGRect(x: addBarButtonStepper.frame.maxX + 20,
                                               y: addBarButtonStepper.center.y - 10,
                                               width: 50,
                                               height: 20)
            
        case .pushViewController:
            cell.textLabel?.text = "Push"
            cell.textLabel?.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            cell.selectionStyle = .default
        }
        
        return cell
    }
}

extension NavigationConfiguratorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NavigatorConfiguratorList.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == NavigatorConfiguratorList.pushViewController.rawValue else { return }
        pushViewController()
    }
}
