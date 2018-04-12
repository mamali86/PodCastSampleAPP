//
//  ViewController.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 21/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class FavouritesViewController:  UICollectionViewController, UICollectionViewDelegateFlowLayout {
let cellID = "cellID"
    
    var podcasts = UserDefaults.toSaveFavouritePodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(FavouritesCell.self, forCellWithReuseIdentifier: cellID)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        collectionView?.addGestureRecognizer(gesture)
    }
    

    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer){
        print("HelloHandle")
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView?.indexPathForItem(at: location) else {return}
        
        let alertController = UIAlertController(title: "Remove podcast?", message: "Remove podcast?", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            let selectedPodcast = self.podcasts[selectedIndexPath.item]
            self.podcasts.remove(at: selectedIndexPath.item)
            
            // also remove your favorited podcast from UserDefaults
            // The simulator doesn't delete immediately, test with your physical iPhone devices
            self.collectionView?.deleteItems(at: [selectedIndexPath])
            UserDefaults.toDeletePodcast(podcast: selectedPodcast)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "no", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
            }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavouritesCell
        cell.savedPodcast = podcasts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 16 * 3) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(16, 16, 16, 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    

}

