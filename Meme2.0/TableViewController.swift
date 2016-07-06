//
//  TableViewController.swift
//  Meme2.0
//
//  Created by David on 6/28/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.memedImage.image = meme.memedImage
        cell.combinedLabel.text = meme.topTextField! + " " + meme.bottomTextField!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailController.meme = memes[indexPath.row]
        
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            (UIApplication.sharedApplication().delegate as!AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
}
