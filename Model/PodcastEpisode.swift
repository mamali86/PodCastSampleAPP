//
//  PodcastEpisode.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 02/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit
import FeedKit

struct PodcastEpisode {
    
    let title: String?
    let pubDate: Date?
    let description: String?
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}
