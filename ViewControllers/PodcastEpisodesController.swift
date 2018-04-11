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
    
    let favouritedPodcastKey = "favouritedPodcastKey"
    
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
    
    fileprivate func setupNavigationBarItems() {
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Favourites", style: .plain, target: self, action: #selector(handleSaveFavourite)), UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))]
    }
    
    @objc fileprivate func handleSaveFavourite() {
        guard let podcast = self.podcast else {return}

         let data = NSKeyedArchiver.archivedData(withRootObject: podcast)
        
        UserDefaults.standard.set(data, forKey: favouritedPodcastKey)
        
            }
    
    @objc fileprivate func handleFetchSavedPodcasts() {
        
        guard let data = UserDefaults.standard.data(forKey: favouritedPodcastKey) else {return}
        
        let podcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? Podcast
        print(podcast?.trackName)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWork()
        setupNavigationBarItems()
     
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.color = .darkGray
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcastEpisodes.isEmpty ? 200 : 0
    }
    
    
    static func loadNib() -> PodcastDetailedEpisode {
        return  Bundle.main.loadNibNamed("PodcastDetailedEpisode", owner: self, options: nil)?.first as! PodcastDetailedEpisode
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        let PodcastDetailedEpisode = mainTabBarController?.podcastEpisodePlay
        let podcastEpisode = self.podcastEpisodes[indexPath.row]

        PodcastDetailedEpisode?.podcastEpisode = podcastEpisode

        mainTabBarController?.maximisePlayerDetails(podcastEpisode: podcastEpisode, podcastPlayListEpisodes: podcastEpisodes)
//        let window = UIApplication.shared.keyWindow
//        let PodcastDetailedEpisode = PodcastEpisodesController.loadNib()
//        PodcastDetailedEpisode.frame = self.view.frame
//        window?.addSubview(PodcastDetailedEpisode)
        
        
 
    }
    
    
}
