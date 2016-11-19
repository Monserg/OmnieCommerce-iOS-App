//
//  SlideMenuShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol SlideMenuShowViewControllerInput {
    func displaySomething(viewModel: SlideMenuShow.Something.ViewModel)
}

protocol SlideMenuShowViewControllerOutput {
    func doSomething(request: SlideMenuShow.Something.Request)
}

class SlideMenuShowViewController: UIViewController, SlideMenuShowViewControllerInput {
    // MARK: - Properties
    var output: SlideMenuShowViewControllerOutput!
    var router: SlideMenuShowRouter!
    
    var menuItemsList = NSDictionary()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var advertisingView: UIView!
    @IBOutlet weak var textButton: UIButton!
    

    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SlideMenuShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Config VC
        textButton.setAttributedTitle(NSAttributedString(string: "Add organization name".localized(), attributes: Config.Buttons.Fonts.ubuntuRegularVeryLightOrangeUnderline12), for: .normal)
        
        // Register the Nib header/footer section views
        tableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MenuSectionHeaderView")
        tableView.register(UINib(nibName: "MenuSectionFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MenuSectionFooterView")
        
        doSomethingOnLoad()
        
        // FIXME: - REMOVE TO WORKER
        getMenuItemsFromPropertyList()
    }

    deinit {
        print("SlideMenuShowViewController deinit.")
    }

    
    // MARK: - Actions
    @IBAction func handlerAdvertisingViewTap(_ sender: UIButton) {
    }
    
    
    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = SlideMenuShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: SlideMenuShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
    
    func getMenuItemsFromPropertyList() {
        let path = Bundle.main.path(forResource: "MenuItemsList", ofType: "plist")
        menuItemsList = NSDictionary(contentsOfFile: path!)!
        
        tableView.reloadData()
    }
}


// MARK: - UITableViewDataSource
extension SlideMenuShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItemsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = menuItemsList.object(forKey: "Section \(section)") as! NSArray
        
        return (Config.Constants.isUserGuest) ? (sectionArray.count - 1) : sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuViewCell
        let sectionArray = menuItemsList.object(forKey: "Section \(indexPath.section)") as! NSArray
        let sectionDictionary = sectionArray[indexPath.row] as! NSDictionary
        
        cell.setup(menuItem: sectionDictionary)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension SlideMenuShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuViewCell
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let ordersNC = UIStoryboard(name: "OrdersShow", bundle: nil).instantiateViewController(withIdentifier: "OrdersShowNC") as! BaseNavigationController
            revealViewController().pushFrontViewController(ordersNC.viewControllers.first, animated: true)
        } else {
            // Menu section 4 (Logout)
            if indexPath.section == 4 {
                self.revealViewController().revealToggle(animated: true)
                
                let window = UIApplication.shared.windows[0]
                let signInShowStoryboard = UIStoryboard(name: "SignInShow", bundle: nil)
                let initialNC = signInShowStoryboard.instantiateViewController(withIdentifier: "SignInShowNC") as! BaseNavigationController
                window.rootViewController = initialNC
                
                self.present(initialNC, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                    //                self.revealViewController().dismiss(animated: true, completion: nil)
                })
                //window.makeKeyAndVisible()
            } else {
                self.performSegue(withIdentifier: cell.segueName, sender: self)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 12.0 : 7.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuSectionHeaderView") as? MenuSectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section != menuItemsList.count - 1) ? 7.0 : 12.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return (section != menuItemsList.count - 1) ? tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuSectionFooterView") as? MenuSectionFooterView : tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuSectionHeaderView") as? MenuSectionHeaderView
    }
}
