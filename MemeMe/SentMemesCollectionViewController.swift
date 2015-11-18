//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by antonio silva on 10/20/15.
//  Copyright © 2015 antonio silva. All rights reserved.
//

import UIKit


class SentMemesCollectionViewController: UICollectionViewController{

    ///shourtcut to meme model defined in AppDelegate
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }


    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let space: CGFloat = 0.1
        
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        flowLayout.minimumLineSpacing=space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(width, height)
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Add Meme", style: .Plain, target: self, action: "addMeme")
        
        if(memes.count == 0){
            addMeme()
            
        }
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.hidden=false
        collectionView?.reloadData()
    }
    

    ///show the meme editor
    func addMeme(){
        
        let viewController=self.storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! MemeEditorController

        presentViewController(viewController, animated: true, completion: nil)


    
    }
    
    ///get the meme count from the model
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
        
        
    }
    
    //set the current cell labels and image
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath)as! MemeCollectionViewCell
        
        let meme=memes[indexPath.item]
        
        cell.memeImageView.image=meme.memedImage
        cell.topText.text=meme.topText
        cell.bottomText.text=meme.bottomText
        
        return cell
        

    }
    
    ///show the MemeDetailsViewController when the user tap a meme
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
    
    
        detailController.meme=memes[indexPath.item]
        
        
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
}
