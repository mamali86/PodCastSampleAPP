//
//  PodcastEpisodesController.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 02/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit
import FeedKit

class PodcastEpisodesController: UITableViewController {
    
    fileprivate let epiCellID = "epvarllid"
    var podcastEpisodes = [PodcastEpisode]()
    
    var podcast: Podcast? {
        
        didSet{
            
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        
        guard let podcastFeedURL = podcast?.feedUrl else {return}
        
        let secureFeedURL = podcastFeedURL.contains("https") ? podcastFeedURL :
            podcastFeedURL.replacingOccurrences(of: "http", with: "https")
        
        
    guard let url = URL(string: secureFeedURL) else {return}
    let parser = FeedParser(URL: url)
    parser?.parseAsync(result: { (result) in
    print("Successfully parse feed", result.isSuccess)
        switch result {
        case let .rss(feed):
            var podcastEpisodes = [PodcastEpisode]()
            let image_Url = feed.iTunes?.iTunesImage?.attributes?.href

            feed.items?.forEach({ (feedItem) in
                var podcastEpisode = PodcastEpisode(feedItem: feedItem)
                
                if podcastEpisode.imageUrl == nil {
                    podcastEpisode.imageUrl = image_Url
                }
                podcastEpisodes.append(podcastEpisode)
            })
            self.podcastEpisodes = podcastEpisodes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        break        // Really Simple Syndication Feed Model
        case let .failure(error):
            print("An error in call", error)
        default:
            print("found a Feed...")
        }
        
        
        
    })
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWork()
     
    }
    
    
    //MARK:- SetUp Work
    
    fileprivate func setUpWork() {
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
     tableView.register(nib, forCellReuseIdentifier: epiCellID)
    tableView.tableFooterView = UIView()
    }

    
    
     //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastEpisodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: epiCellID, for: indexPath) as!EpisodeCell
        let podcastEpisodes = self.podcastEpisodes[indexPath.row]
        cell.podcastEpisode = podcastEpisodes
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
}
