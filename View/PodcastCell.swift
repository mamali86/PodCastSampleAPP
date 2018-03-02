//
//  PodcastCell.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 27/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//
import UIKit
import SDWebImage


class PodcastCell: UITableViewCell {
    
    var podcast: Podcast?{
        
        didSet{
            trackLabel.text = podcast?.trackName
            artistnameLabel.text = podcast?.artistName
//            podcastImage.image = podcast?.podcastImage
            
            episodecountLabel.text = "\(podcast?.trackCount ?? 0) Episodes"
            
        
                    guard let url = URL(string: podcast?.artworkUrl600 ?? "") else {return}
//
//                        URLSession.shared.dataTask(with: url) { (data, _, _) in
//                            guard let data = data else {return}
//                            let imageToCache = UIImage(data: data)
//
//                            DispatchQueue.main.async {
//                                self.podcastImage.image = imageToCache
//                            }
//                        }.resume()
            
            podcastImage.sd_setImage(with: url, completed: nil)
        
        }
        
}
    
    let podcastImage: UIImageView =  {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "appicon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    
    let trackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .black
        return label
    }()
    
    let artistnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    
    let episodecountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Episode Count"
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .gray
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(podcastImage)
        podcastImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        podcastImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        podcastImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        podcastImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0) .isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [artistnameLabel, trackLabel, episodecountLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = -12
        
        addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: podcastImage.rightAnchor, constant: 5).isActive = true
        stackView.topAnchor.constraint(equalTo: podcastImage.topAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
