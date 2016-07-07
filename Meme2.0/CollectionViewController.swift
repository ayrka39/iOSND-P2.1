//
//  CollectionViewController.swift
//  Meme2.0
//
//  Created by David on 6/28/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
   
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 2.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = space / 3.0
        flowLayout.minimumInteritemSpacing = space / 3.0
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(collecionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let meme = memes[indexPath.item]
        
        let cell = collecionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.memedImage.image = meme.memedImage

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailController.meme = memes[indexPath.row] 
        
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}
