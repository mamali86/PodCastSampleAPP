//
//  ConfigApiManager.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 26/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import Alamofire
import UIKit


class ConfigApiManager: NSObject {
    
 static let sharedInstance = ConfigApiManager()
    
    func fetchPodcasts(searchtext: String, completionHandler: @escaping ([Podcast]) -> ()) {

        let parameters = ["term": searchtext, "media": "podcast"]

    let url = "https://itunes.apple.com/search?term"

Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
    
    if let err = dataResponse.error {
        print("Failed to contact Yahoo", err)
    }
    
    guard let data = dataResponse.data else {return}
//                let dummyString = String(data: data, encoding: .utf8)

    
    do {
        let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
        completionHandler(searchResult.results)
    
    } catch let decodeError {
        print("Failed to parse JSON properly:", decodeError)
    }
}
    }
    
}
