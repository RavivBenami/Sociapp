//
//  PostCell.swift
//  Sociapp
//
//  Created by Raviv Benami on 16/09/2017.
//  Copyright © 2017 Raviv Benami. All rights reserved.
//

import UIKit
import Firebase
class PostCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!

    var post:Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func congigureCell(post:Post, img:UIImage? = nil){
        self.post = post
        self.caption.text = post.caption
        self.likes.text = String(post.likes)
        
        if img != nil{
            self.postImg.image = img
        }
        else{
                let ref =  Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2*1024*1024, completion: {(data,error) in
                
                
                if error != nil
                {
                    print("RAVIV: Unable to download image from firstorage")
                }
                else {
                    print("RAVIV:Image downloaded from firbasestorage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
                
                
            })
           
              }
        
                
    
            }
        }
