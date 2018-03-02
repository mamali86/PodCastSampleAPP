//
//  PodcastEpisodesController.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 02/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class PodcastEpisodesController: UITableViewController {
    
    let cellID = "cellid"
    let podcastEpisodes = [PodcastEpisode(title: "Hello World"), PodcastEpisode(title: "See you Soon"), PodcastEpisode(title: "Morning")]
        
    var podcast: Podcast? {
        
        didSet{
            
            navigationItem.title = podcast?.trackName
            
        }
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
