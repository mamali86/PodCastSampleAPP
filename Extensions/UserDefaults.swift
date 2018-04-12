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
    
    static func toDeletePodcast(podcast: Podcast) {
        
        let PodcastList = toSaveFavouritePodcasts()
        
        let filteredpodcasts = PodcastList.filter { (pod) -> Bool in
            return pod.artistName != podcast.artistName && pod.trackName != podcast.trackName
        }
     
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredpodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favouritedPodcastKey)

        
    }
    
}
