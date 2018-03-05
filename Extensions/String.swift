//
//  String.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 05/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import Foundation
import FeedKit

extension String {
    
    func toSecureHTTPS () -> String {
        
        return self.contains("https") ? self :
            self.replacingOccurrences(of: "http", with: "https")
        
        
    }
}
