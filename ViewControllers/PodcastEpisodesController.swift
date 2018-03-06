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
        
        ConfigApiManager.sharedInstance.fetchEpisoides(podcastFeedURL: podcastFeedURL) { (podcastEpisodes) in

                        self.podcastEpisodes = podcastEpisodes
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
        }
    
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcastEpisodes = self.podcastEpisodes[indexPath.row]
        let window = UIApplication.shared.keyWindow
        let PodcastDetailedEpisode = Bundle.main.loadNibNamed("PodcastDetailedEpisode", owner: self, options: nil)?.first as! PodcastDetailedEpisode
        PodcastDetailedEpisode.podcastEpisode = podcastEpisodes

        PodcastDetailedEpisode.frame = self.view.frame
    
        window?.addSubview(PodcastDetailedEpisode)
        
 
    }
    
    
}
