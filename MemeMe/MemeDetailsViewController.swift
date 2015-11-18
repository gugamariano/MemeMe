//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by antonio silva on 10/20/15.
//  Copyright © 2015 antonio silva. All rights reserved.
//

import UIKit


class MemeDetailsViewController: UIViewController{


    @IBOutlet weak var memeImage:UIImageView!
    
    var meme:Meme!
    
    ///add a Edit button to the top navbar
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editMeme")
        
    }
    
    ///set the image and hiddes the tabbar before the view appears
    override func viewWillAppear(animated: Bool) {
        memeImage.image=meme!.memedImage
        tabBarController?.tabBar.hidden=true
    }
    
    ///shows the MemeEditorController when the user clicks the Edit button
    func editMeme(){
        
        let viewController=self.storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! MemeEditorController
        viewController.modalPresentationStyle=UIModalPresentationStyle.Popover
        viewController.setEditMeme(meme)
        
        presentViewController(viewController, animated: true, completion: nil)

    
    }
    

    
    
}
