//
//  LevelButtonViewController.swift
//  AppsComps
//
//  Created by appscomps on 1/18/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit


class LevelButtonViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    /*Code referenced from https://www.youtube.com/watch?v=UH3HoPar_xg
      Got tips about labeling the cell from http://stackoverflow.com/questions/31735228/how-to-make-a-simple-collection-view-with-swift
     */
    var levelLabels = ["Level 1", "Level 2", "Level 3", "Level 4"]
    var levels = [1,2,3,4]
    let screen: CGRect = UIScreen.main.bounds
    
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
    
    /*Referenced from http://stackoverflow.com/questions/40019875/set-collectionview-size-sizeforitematindexpath-function-is-not-working-swift 
     This method should control the size and layout of the cells
     
     Check here for FlowLayout tut: https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/UsingtheFlowLayout/UsingtheFlowLayout.html
     https://developer.apple.com/reference/coregraphics/cgsize
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = screen.width
        
        let unit: CGFloat = width/100
        
        let size = CGSize(width: unit*20, height: unit*30)
        return size
    }
    
    //Setting the padding between the level cells. Currently set up so that 4 buttons are vertically centered.
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 insetForSectionAt section: Int) -> UIEdgeInsets{
        let height: CGFloat = screen.height
        let hUnit: CGFloat = height/100
        return UIEdgeInsets(top: hUnit*20, left: 5, bottom: hUnit*20, right: 5)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath) as! LevelButtonCollectionCell
        
        //Got help for indexing at: http://stackoverflow.com/questions/36074827/swift-2-1-how-to-pass-index-path-row-of-collectionview-cell-to-segue
        
        cell.levelButton?.setTitle(self.levelLabels[indexPath.row], for: .normal)
        cell.levelButton?.setTitleColor(UIColor.white, for: .normal)
        cell.levelButton?.setLevel(lev: self.levels[indexPath.row])
        let locked: Bool = (cell.levelButton?.checkAccess(curLev: 2))!
        let width: CGFloat = screen.width
        
        let unit: CGFloat = width/100
        cell.levelButton?.frame.size = CGSize(width: unit*20, height: unit*20)
        cell.levelButton?.layer.cornerRadius = CGFloat(roundf(Float(cell.frame.size.width/2.0)))
        
//        cell.levelView?.frame.origin.x = cell.frame.origin.x + unit
//        cell.levelView?.frame.origin.y = (cell.levelButton?.frame.origin.y)! + unit*20
        var image : String = "emptystars"
        
        if (!locked) {
            image = "threestars"
            
        }
        cell.levelView.image = UIImage(named: image)
        
        return cell
    }
    

}
