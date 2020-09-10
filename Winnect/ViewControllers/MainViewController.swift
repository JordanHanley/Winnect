//
//  HomeViewController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/14/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        UITabBar.appearance().tintColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        
        // loads all tabs
        for viewController in self.viewControllers! {
            _ = viewController.view
        }
    }
    

  

}
