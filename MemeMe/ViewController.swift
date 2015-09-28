//
//  ViewController.swift
//  MemeMe
//
//  Created by antonio silva on 9/26/15.
//  Copyright (c) 2015 antonio silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.whiteColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 2
    ]
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var DEFAULT_TOP_TEXT:String="TOP";
    var DEFAULT_BOTTOM_TEXT:String="BOTTOM";
    
    var meme:Meme!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initText()
        
    }
    
    func initText(){
        
        topText.defaultTextAttributes=memeTextAttributes
        topText.textAlignment=NSTextAlignment.Center
        topText.autocapitalizationType=UITextAutocapitalizationType.AllCharacters
        topText.borderStyle=UITextBorderStyle.None
        topText.backgroundColor=UIColor.clearColor()
        topText.sizeToFit()
        topText.delegate=self
        
        
        bottomText.defaultTextAttributes=memeTextAttributes
        bottomText.textAlignment=NSTextAlignment.Center
        bottomText.autocapitalizationType=UITextAutocapitalizationType.AllCharacters
        bottomText.borderStyle=UITextBorderStyle.None
        bottomText.backgroundColor=UIColor.clearColor()
        bottomText.sizeToFit()
        bottomText.delegate=self
        
        reset()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if(textField.text == DEFAULT_TOP_TEXT || textField.text == DEFAULT_BOTTOM_TEXT){
            textField.text = "";
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if(bottomText.isFirstResponder()){
            
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if(bottomText.isFirstResponder()){
            
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePickController = UIImagePickerController()
        
        imagePickController.delegate=self
        imagePickController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePickController, animated:true, completion: nil)
        
    }
    
    @IBAction func showActivityView(sender: AnyObject) {
        
        let image=self.saveImage()
        
        let nextController=UIActivityViewController(activityItems: [image] , applicationActivities:nil)
        
        nextController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            if ok {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(nextController,animated: true, completion:nil)
        
    }
    
    
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePickController = UIImagePickerController()
        
        imagePickController.delegate=self
        imagePickController.sourceType=UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePickController, animated:true, completion: nil)
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        reset()
        
    }
    
    func reset(){
        
        bottomText.text=DEFAULT_BOTTOM_TEXT
        topText.text=DEFAULT_TOP_TEXT
        
        shareButton.enabled=false
        imagePickerView.image=nil
    }
    
    
    func generateMemedImage() -> UIImage
    {
        
        toolBar.hidden=true
        navigationBar.hidden=true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        
        let memedImage : UIImage =
        
        UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        toolBar.hidden=false
        navigationBar.hidden=false
        
        
        return memedImage
    }
    
    func saveImage() -> UIImage{
        
        let memeImage=generateMemedImage()
        self.meme = Meme (topText: topText.text, bottomText:bottomText.text , image: imagePickerView.image , memedImage:memeImage)
        
        return memeImage
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        
        
        self.imagePickerView.image=image
        self.shareButton.enabled=true
        self.cancelButton.enabled=true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    
}

