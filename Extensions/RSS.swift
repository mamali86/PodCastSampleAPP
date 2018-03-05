//
//  RSS.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 05/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import Foundation
import UIKit
import FeedKit

extension RSSFeed {
    
    
    func toEpisodes() -> [PodcastEpisode] {
    var podcastEpisodes = [PodcastEpisode]()
    let image_Url = iTunes?.iTunesImage?.attributes?.href
    
    items?.forEach({ (feedItem) in
    var podcastEpisode = PodcastEpisode(feedItem: feedItem)
    
    if podcastEpisode.imageUrl == nil {
    podcastEpisode.imageUrl = image_Url
    }
    podcastEpisodes.append(podcastEpisode)
    })
        
        return podcastEpisodes

    }
    
}
