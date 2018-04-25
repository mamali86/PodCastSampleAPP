//
//  PodCastViewController.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 22/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit
import Alamofire


class PodCastsSearchController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    let cellID = "cellID"
   
    var podcasts = [Podcast]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar(searchController.searchBar, textDidChange: "BrianVoong")
        setupTableView()
        setupSearchBar()
    }
    
    //MARK:- Setup Work
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    var timer: Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        podcasts = []
        tableView.reloadData()
    
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
        
          
            ConfigApiManager.sharedInstance.fetchPodcasts(searchtext: searchText, completionHandler: { (podcasts: [Podcast]) in
                self.podcasts = podcasts
                self.tableView.reloadData()
                
            })
        })
     
        
    }
    
    fileprivate func setupTableView() {
          tableView.register(PodcastCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }

    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please Enter a Search Term"
        label.textAlignment = .center
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return self.podcasts.isEmpty  && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPodcast = self.podcasts[indexPath.row]
        let podCastsSearchController = PodcastEpisodesController()
        podCastsSearchController.podcast = selectedPodcast
        navigationController?.pushViewController(podCastsSearchController, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 250 : 0
    }


    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndictor = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndictor.startAnimating()
        activityIndictor.color = .darkGray
        let label = UILabel()
        label.text = "Currently Searching"
        label.textColor = .purple
        label.textAlignment = .center
        let stackView = UIStackView(arrangedSubviews: [activityIndictor, label])
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 363).isActive = true
        return stackView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        
        let podcast = self.podcasts[indexPath.row]
        
        cell.podcast = podcast
        return cell
    }
    

    
    
}

