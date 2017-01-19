//
//  LevelButtonViewController.swift
//  AppsComps
//
//  Created by appscomps on 1/18/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit


class LevelButtonViewController: UICollectionViewController {
    //Code referenced from https://www.youtube.com/watch?v=UH3HoPar_xg
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "levelCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath) as UICollectionViewCell
        
        cell.backgroundColor = UIColor.darkGray
        
        return cell
    }
}
//
///*Code referenced from https://www.raywenderlich.com/136159/uicollectionview-tutorial-getting-started
// */
//extension LevelButtonViewController : UICollectionViewDelegateFlowLayout {
//    
//    //1
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //2
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
//    
//    //3
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//    
//    // 4
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}
