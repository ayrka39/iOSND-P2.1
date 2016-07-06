//
//  DetailViewController.swift
//  Meme2.0
//
//  Created by David on 6/28/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var meme: Meme!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memedImageView.image = meme.originalImage
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        
        
        let editMemeNavigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! UINavigationController
        
        let editMemeVC = editMemeNavigation.topViewController as! ViewController
        
        editMemeVC.meme = meme
        
        dismissViewControllerAnimated(true, completion: nil)
        navigationController?.presentViewController(editMemeNavigation, animated: true, completion: nil)
    }
}
