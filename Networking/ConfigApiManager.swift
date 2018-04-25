//
//  ConfigApiManager.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 26/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import Alamofire
import UIKit
import FeedKit


class ConfigApiManager: NSObject {
    
 static let sharedInstance = ConfigApiManager()
    
    func downloadPodcastEpisodes(episode: PodcastEpisode) {
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.podCastUrl, to: downloadRequest).downloadProgress { (progress) in
//            print(progress.fractionCompleted)
            }.response { (resp) in
                // Updating UserDefaults with the temp file
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.index(where: {$0.title == episode.title && $0.author == episode.author}) else {return}
                downloadedEpisodes[index].filedUrl = resp.destinationURL?.absoluteString ?? ""
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeKey)
                    
                } catch let err {
                    print("problem in enconding downloaded Episode with fileUrl update", err)
                }
        }
    }
    
    
    func fetchEpisoides(podcastFeedURL: String, completionHandler: @escaping ([PodcastEpisode]) -> ()) {
        
        
        
        let secureFeedURL = podcastFeedURL.contains("https") ? podcastFeedURL :
            podcastFeedURL.replacingOccurrences(of: "http", with: "https")
        
        
        guard let url = URL(string: secureFeedURL) else {return}
        
        
        DispatchQueue.global(qos: .background).async {
            
            
            let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { (result) in
            print("Successfully parse feed", result.isSuccess)
            
            if let err = result.error {
                
                print("Error parsing feed", err)
            }
            
            guard let feed = result.rssFeed else {return}
    
            completionHandler(feed.toEpisodes())
            
        })
        
    }
    }
    
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
