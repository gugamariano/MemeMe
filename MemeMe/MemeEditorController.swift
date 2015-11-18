//
//  MemeEditorController.swift
//  MemeMe
//
//  Created by antonio silva on 9/26/15.
//  Copyright (c) 2015 antonio silva. All rights reserved.
//

import UIKit

///Main Controller of the MemeMe app, allowing the user to get/take a picture and save and share the generated Meme.
class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
        
    ]
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var DEFAULT_TOP_TEXT:String="TOP"
    var DEFAULT_BOTTOM_TEXT:String="BOTTOM"
    
    var editMeme:Meme!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
	
        super.viewDidLoad()        
        initText(topText)
		initText(bottomText)
        reset()
        
        
    }
    
	///Setup the bottom and top input text with center, capitalized, transparent background,and fit the text size.
    func initText(inputText:UITextField){
        
        inputText.defaultTextAttributes=memeTextAttributes
        inputText.textAlignment=NSTextAlignment.Center
        inputText.autocapitalizationType=UITextAutocapitalizationType.AllCharacters
        inputText.borderStyle=UITextBorderStyle.None
        inputText.backgroundColor=UIColor.clearColor()
        inputText.sizeToFit()
        inputText.delegate=self
        
    }
    
	///Check if the camera is available, enabling/disablign the camera icon propertly.
    override func viewWillAppear(animated: Bool) {
	
        super.viewWillAppear(animated)
        
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		subscribeToKeyboardNotifications()
        
        if(editMeme != nil) {
            loadEditMeme()
        }
        
    }
    

    
    override func viewWillDisappear(animated: Bool) {
	
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
	
        super.didReceiveMemoryWarning()
        
    }
    
    
	///Subscribe to keyboardWillShow and keyboardWillHide notifications.
    func subscribeToKeyboardNotifications() {
        
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    ///Unsubscribe to keyboardWillShow and keyboardWillHide notifications.
    func unsubscribeFromKeyboardNotifications() {
	
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
	///Replace only the initial ("TOP" or "BOTTOM" text when the user begin editing.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if(textField.text == DEFAULT_TOP_TEXT || textField.text == DEFAULT_BOTTOM_TEXT){
            textField.text = "";
        }
        return true
    }
    
	///return after done
    func textFieldShouldReturn(textField: UITextField) -> Bool {
	
        textField.resignFirstResponder()
        return true
    }
    
	///Scroll up the vertical screen to show the keyboard only on bottom input text.
    func keyboardWillHide(notification: NSNotification) {

            view.frame.origin.y = 0
        
    }
    
    ///Scroll down the vertical screen when the keyboard dismiss.
    func keyboardWillShow(notification: NSNotification) {
      
        if(bottomText.isFirstResponder()){
            view.frame.origin.y-=getKeyboardHeight(notification)
        }
        
    }
    
    ///Get the keyboard height to use when need to scroll the screen.
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
	
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    /// When the user clicks the Album buttom, shows the UIImagePickerController to select an image.
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePickController = UIImagePickerController()
        
        imagePickController.delegate=self
        imagePickController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagePickController, animated:true, completion: nil)
        
    }
    
	/// When the user clicks the "share" buttom, save and generate the Meme image and shows the UIActivityViewController to share the final Meme image.
    @IBAction func showActivityView(sender: AnyObject) {
        
        let image=generateMemedImage()
        
        let nextController=UIActivityViewController(activityItems: [image] , applicationActivities:nil)
        
        nextController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.dismissViewControllerAnimated(true, completion: nil)
				self.saveImage(image)
                
            }
        }
        
        presentViewController(nextController,animated: true, completion:nil)
        
    }
    
    
    
    ///When the user clicks the Camera icon (if enabled), shows the UIImagePickerController in the camera mode to take a picture.
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePickController = UIImagePickerController()
        
        imagePickController.delegate=self
        imagePickController.sourceType=UIImagePickerControllerSourceType.Camera
        
        presentViewController(imagePickController, animated:true, completion: nil)
        
    }
    
    
    ///When the user select or take the picture, set the image and enable the cancel and share button, dismissing the UIImagePickerController.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        imagePickerView.image=image
        shareButton.enabled=true
        cancelButton.enabled=true
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    ///When the user clicks the "Cancel" buttom (if enabled),call the  reset func.
    @IBAction func cancelAction(sender: AnyObject) {
        reset()
        
        if(memes.count > 0) {
            dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
	///Reset the selected image (if selected) and set the initial up and bottom text to default values.
    func reset(){
        
        bottomText.text=DEFAULT_BOTTOM_TEXT
        topText.text=DEFAULT_TOP_TEXT
        
        shareButton.enabled=false
        imagePickerView.image=nil
    }
    
    ///hide the navbar and toolbar to generate and return an UIImage from the current screen, and them enable the navbar and toolbar again.
    func generateMemedImage() -> UIImage
    {
        
        toolBar.hidden=true
        navigationBar.hidden=true
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        toolBar.hidden=false
        navigationBar.hidden=false
        
        
        return memedImage
    }
    
	///Save the generated Meme, up and bottom text and the original image in the Meme struct.
    func saveImage(memeImage:UIImage) -> UIImage{
        
        
        let meme:Meme = Meme (topText: topText.text, bottomText:bottomText.text , image: imagePickerView.image , memedImage:memeImage)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)

        
        
        return memeImage
    }
    
    
    
	/// When the user cancel the UIImagePickerController , dismiss the view.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    ///set the meme image to be edited
    func setEditMeme(meme:Meme){
        editMeme=meme
        
    }
    
    ///load the top and bottom labels and image to be edited and set the frame origin to (0,0)
    func loadEditMeme(){
    
        bottomText.text=editMeme.bottomText
        topText.text=editMeme.topText
        imagePickerView.image=editMeme.image
        


        

    }
    
    
}

