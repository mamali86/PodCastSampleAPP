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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(FavouritesCell.self, forCellWithReuseIdentifier: cellID)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavouritesCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 16 * 3) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(16, 16, 16, 16)
    }
    

}

