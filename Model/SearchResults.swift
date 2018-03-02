//
//  File.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 26/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import Foundation
import UIKit

struct SearchResults: Decodable {
    let resultCount: Int?
    let results: [Podcast]
}
