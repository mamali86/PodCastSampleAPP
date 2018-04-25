//
//  DownloadController.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 22/04/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class DownloadController: UITableViewController {
    fileprivate let cellID = "cellID"
    var episodes = UserDefaults.standard.downloadedEpisodes()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabelView()
        setUpObservers()
    }
    
    fileprivate func setUpTabelView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func setUpObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification){
        
        
        guard let userInfo = notification.userInfo as? [String: Any] else {return}
        
        guard let progress = userInfo["progress"] as? Double else {return}
        
          guard let title = userInfo["title"] as? String else {return}
        
    
        guard let index = self.episodes.index(where: {$0.title == title }) else {return}
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EpisodeCell
        cell.progressLabel.isHidden = false
        cell.progressLabel.text = "\(Int(progress * 100))%"
        
        if progress == 1 {
            
            cell.progressLabel.isHidden = true
        }
        
            }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
        
    }
    
  
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            print("Delete the Podcast")
            let episodeDownloaded = self.episodes[indexPath.item]
            self.episodes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            UserDefaults.toDeletePodcastEpisode(podcastEpisode: episodeDownloaded)
        }
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.item]
        
        if episode.filedUrl != nil {
             UIApplication.mainTabBarController()?.maximisePlayerDetails(podcastEpisode: episode, podcastPlayListEpisodes: self.episodes)
        }
        
        else{
            
            let alertController = UIAlertController(title: "FileUrl Not Found", message: "Can not file local file, play using podcastEpisode stream url instead", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                 UIApplication.mainTabBarController()?.maximisePlayerDetails(podcastEpisode: episode, podcastPlayListEpisodes: self.episodes)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
        
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        cell.podcastEpisode = self.episodes[indexPath.item]
        return cell
    }
}
