//
//  Podcast.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 22/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit
import Foundation

struct Podcast: Decodable {
    let trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}

