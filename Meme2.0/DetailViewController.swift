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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "Edit",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(DetailViewController.editMeme))
        
        memedImageView.image = meme.originalImage
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memedImageView!.image = meme.memedImage
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    func editMeme() {
        
        var controller: MemeViewController
        
        controller = storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        controller.editMemedImage = true
        controller.topText = meme.topTextField
        controller.bottomText = meme.bottomTextField
        controller.image = meme.originalImage
        
        presentViewController(controller, animated: true, completion: nil)
    }
}
