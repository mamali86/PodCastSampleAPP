//
//  EpisodeCell.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 04/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var episodeImageView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel! {
    
    didSet {
    descriptionLabel.numberOfLines = 2
    
    }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        
        didSet {
            titleLabel.numberOfLines = 2
            
        }
    }
    
    @IBOutlet weak var pubDateLabel: UILabel!
    
    var podcastEpisode: PodcastEpisode! {
        didSet{
            
            titleLabel.text = podcastEpisode?.title
//            pubDateLabel.text = podcastEpisode?.pubDate?.description
            descriptionLabel.text = podcastEpisode?.description
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            pubDateLabel.text = dateFormatter.string(from: (podcastEpisode?.pubDate!)!)
            
        }
    }
    
    
}
