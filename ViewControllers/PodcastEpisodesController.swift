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
    
    let cellID = "cellid"
    var podcastEpisodes = [PodcastEpisode(title: "Hello World"), PodcastEpisode(title: "See you Soon"), PodcastEpisode(title: "Morning")]
    
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
            feed.items?.forEach({ (feeItem) in
                let podcastEpisode = PodcastEpisode(title: feeItem.title ?? "")
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
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    tableView.tableFooterView = UIView()
    }

    
    
     //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastEpisodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let podcastEpisodes = self.podcastEpisodes[indexPath.row]

        cell.textLabel?.text = podcastEpisodes.title
        return cell
    }
    
    
}
