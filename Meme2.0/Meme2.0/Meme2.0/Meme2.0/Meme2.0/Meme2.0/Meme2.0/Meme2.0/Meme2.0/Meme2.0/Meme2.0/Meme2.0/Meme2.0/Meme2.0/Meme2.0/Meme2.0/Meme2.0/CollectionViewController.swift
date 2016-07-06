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
        
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / space
        let heightDimension = (view.frame.size.height - (2 * space)) / space / 2
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
        collectionView?.hidden = false
        tabBarController!.tabBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        collectionView?.hidden = true
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(collecionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collecionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.item]
       
        cell.memedImage.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailController.meme = memes[indexPath.row] 
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if (segue.identifier == "segueFromCollection") {
//            tabBarController?.tabBar.hidden = true
//        }
//    }
//    
//    @IBAction func addMeme(sender: AnyObject) {
//        
//        performSegueWithIdentifier("segueFromCollection", sender: "addMeme")
//    }
//
}
