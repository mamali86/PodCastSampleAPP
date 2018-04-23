//
//  UserDefaults.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 12/04/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favouritedPodcastKey = "favouritedPodcastKey"
    static let downloadEpisodeKey = "downloadEpisodeKey"

    static func toSaveFavouritePodcasts() -> [Podcast] {
        
        guard let savedPodacstData = UserDefaults.standard.data(forKey: favouritedPodcastKey) else {return []}
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodacstData) as? [Podcast] else {return []}
        
        return savedPodcasts
        
    }
    
     func downloadEpisodes(episode: PodcastEpisode) {
        do {
            var episodesDownload = downloadedEpisodes ()
            episodesDownload.append(episode)
            let data = try JSONEncoder().encode(episodesDownload)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeKey)

        } catch let err {
            print("error", err)
        }
            }
    
    
    func downloadedEpisodes() -> [PodcastEpisode] {
        
        do {
            guard let episodesData = UserDefaults.standard.data(forKey: UserDefaults.downloadEpisodeKey) else {return []}
            let episodes = try JSONDecoder().decode([PodcastEpisode].self, from: episodesData)
            return episodes

        } catch let err {
            print("error decoding", err)
        }
        
        return []
    }
    
    
    
    static func toDeletePodcast(podcast: Podcast) {
        
        let PodcastList = toSaveFavouritePodcasts()
        
        let filteredpodcasts = PodcastList.filter { (pod) -> Bool in
            return pod.artistName != podcast.artistName && pod.trackName != podcast.trackName
        }
     
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredpodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favouritedPodcastKey)

        
    }
    
    
    
    static func toDeletePodcastEpisode(podcastEpisode: PodcastEpisode) {
        
        let episodesDownload = UserDefaults.standard.downloadedEpisodes()
        let filteredPodcastEpisodes = episodesDownload.filter { (pod) -> Bool in
            return pod.title != podcastEpisode.title && pod.author != podcastEpisode.author
        }
        do {
           
            let data = try JSONEncoder().encode(filteredPodcastEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeKey)
            

        } catch let err {
            print("error", err)
        }
        
        
    }
    
}
