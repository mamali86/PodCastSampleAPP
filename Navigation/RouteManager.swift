//
//  RouteManager.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 21/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class RouteManager {

    var window: UIWindow?
    
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    func LoadViewController<A: UIViewController>(type: A.Type) -> A {
        guard let viewController = MainTabBarController() as? A else {
             fatalError("ViewController identifier incorrect")
        }
        return viewController
    }
    
    
    func setRootViewController(_ viewController: UITabBarController) {
        window?.rootViewController =  viewController
        window?.makeKeyAndVisible()
    }
    
    
    func startWithMainNavigationBarController() {
        setRootViewController(instantiateMainTabBarController())
    }
    
    func instantiateMainTabBarController() -> MainTabBarController {
        
        let viewController = LoadViewController(type: MainTabBarController.self)
        
        return viewController
        
    }
    
    
    
    
}
