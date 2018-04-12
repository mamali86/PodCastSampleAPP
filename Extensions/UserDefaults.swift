//
//  UserDefaults.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 12/04/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favouritedPodcastKey = "favouritedPodcastKey"

    static func toSaveFavouritePodcasts() -> [Podcast] {
        
        guard let savedPodacstData = UserDefaults.standard.data(forKey: favouritedPodcastKey) else {return []}
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodacstData) as? [Podcast] else {return []}
        
        
        return savedPodcasts
        
    }
    
}
