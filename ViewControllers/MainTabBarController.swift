//
//  MainTabBarController.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 21/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var routeManager: RouteManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewControllers()
    }
    
    //MARK:- Setup Functions
    
    func setupViewControllers() {
        
        viewControllers = [generateNavigationController(for: PodCastsSearchController(), image: #imageLiteral(resourceName: "favorites"), title: "Favourites"),generateNavigationController(for: ViewController(), image: #imageLiteral(resourceName: "search"), title: "Search"), generateNavigationController(for: ViewController(), image: #imageLiteral(resourceName: "downloads"), title: "Downloads")]
        
    }
    
    
    //MARK:- Helper Functions
    
    fileprivate func generateNavigationController(for rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let NavController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        NavController.tabBarItem.title = title
        NavController.tabBarItem.image = image
        return NavController
        
    }
    
    
    
}
