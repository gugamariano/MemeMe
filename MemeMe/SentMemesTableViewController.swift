//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by antonio silva on 10/20/15.
//  Copyright © 2015 antonio silva. All rights reserved.
//

import UIKit


class SentMemesTableViewController: UITableViewController{

    ///shourtcut to meme model defined in AppDelegate
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    ///add the Add button to the top navbar before the view appear
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addMeme")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.hidden=false
        tableView!.reloadData()
    }
    
    
    ///show the meme editor
    func addMeme(){
        
        let viewController=self.storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! MemeEditorController

        presentViewController(viewController, animated: true, completion: nil)
        
        
    }
    
    ///get the total memes coutn
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    ///set the image, top and bottom labels to current row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.memeImageView.image=meme.memedImage
        
        return cell
    }
    
    ///when select a row, show the MemeDetailsViewController with the selected meme
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        
        
        detailController.meme=memes[indexPath.item]
        
        navigationController!.pushViewController(detailController, animated: true)
        
        
    }
    
    ///delete the seleted meme from the model and update the tableView. If the meme model is empty, shows the meme editor
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle==UITableViewCellEditingStyle.Delete){
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            self.tableView!.reloadData()
            
            if(memes.count==0){
                addMeme()
            }

            
        }
    }


}
