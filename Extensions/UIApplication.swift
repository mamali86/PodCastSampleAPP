//
//  UIApplication.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 23/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        
        return shared.keyWindow?.rootViewController as? MainTabBarController
        
    }
    
}
