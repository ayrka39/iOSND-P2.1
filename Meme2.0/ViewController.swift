//
//  ViewController.swift
//  Meme2.0
//
//  Created by David on 6/28/16.
//  Copyright © 2016 David. All rights reserved.
//


import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var selectLabel: UILabel!
    
    var meme: Meme!
    var memedImage: UIImage!
    var editMemedImage = false
    var image: UIImage!
    var topText: String!
    var bottomText: String!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber.init(float: -3.0)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
        
        topTextField.hidden = true
        bottomTextField.hidden = true
        topNavigationBar.hidden = true
        
        if editMemedImage == true {
            editMeme()
            topTextField.text = topText
            bottomTextField.text = bottomText
            imagePickerView.image = image
            bottomToolBar.hidden = true
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable (UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        pickAnImage(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        pickAnImage(.Camera)
    }
    
    @IBAction func shared(sender: AnyObject) {
        
        shareAMemedImage(generateMemedImage())
    }
    
    @IBAction func memeCancelled(sender: AnyObject) {
        calcel()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = pickedImage
            imagePickerView.contentMode = .ScaleAspectFit
            editMeme()
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Text Field
    func setupTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.backgroundColor = UIColor.clearColor()
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        } else if topTextField.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder() {
                view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Generate Meme Image
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topNavigationBar.hidden = true
        bottomToolBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topNavigationBar.hidden = false
        bottomToolBar.hidden = false
        
        return memedImage
    }
    
    // Save Meme Image
    func save() {
        guard let topText = topTextField.text else { fatalError("top is nil") }
        guard let bottomText = bottomTextField.text else { fatalError("bottom is nil") }
        guard let image = imagePickerView.image else { fatalError("image is nil") }
        
        meme = Meme(topTextField: topText, bottomTextField: bottomText, originalImage: image, memedImage: memedImage)
        
        // Add it to memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    
    // share Meme Image
    func shareAMemedImage(image: UIImage) {
        memedImage = image
        
        // Apply saved image to the view controller
        let ActivityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Setup view controller dismissal
        ActivityVC.completionWithItemsHandler = { activity, completed, items, error in
            
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        // Present activity view controller
        presentViewController(ActivityVC, animated: true, completion: nil)
    }
    
    // edit Meme Image
//    func initForEditing() {
//        topTextField.text = "TOP"
//        bottomTextField.text = "BOTTOM"
//    }
    
    func editMeme() {
        topTextField.hidden = false
        bottomTextField.hidden = false
        topNavigationBar.hidden = false
        selectLabel.hidden = true
    }
    
    func calcel() {
        topTextField.hidden = true
        bottomTextField.hidden = true
        imagePickerView.image = nil
    }
}

