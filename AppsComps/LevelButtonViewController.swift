//
//  LevelButtonViewController.swift
//  AppsComps
//
//  Created by appscomps on 1/18/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit


class LevelButtonViewController: UICollectionViewController {
    /*Code referenced from https://www.youtube.com/watch?v=UH3HoPar_xg
      Got tips about labeling the cell from http://stackoverflow.com/questions/31735228/how-to-make-a-simple-collection-view-with-swift
     */
    

    var levelLabels = ["Level 1", "Level 2", "Level 3", "Level 4"]
    var levels = [1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath) as! LevelButtonCollectionCell
        
        //Got help for indexing at: http://stackoverflow.com/questions/36074827/swift-2-1-how-to-pass-index-path-row-of-collectionview-cell-to-segue
        
        cell.levelButton?.setTitle(self.levelLabels[indexPath.row], for: .normal)
        cell.levelButton?.setTitleColor(UIColor.white, for: .normal)
        cell.levelButton?.setLevel(lev: self.levels[indexPath.row])
        cell.backgroundColor = UIColor.darkGray
        cell.layer.cornerRadius = 20
        
        return cell
    }
}
