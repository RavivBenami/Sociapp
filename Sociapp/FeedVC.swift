//
//  FeedVC.swift
//  Sociapp
//
//  Created by Raviv Benami on 14/09/2017.
//  Copyright © 2017 Raviv Benami. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tbl: UITableView!
    var imgPicker: UIImagePickerController!
    @IBOutlet weak var imgAdd: CircleView!
    @IBOutlet weak var captionLbl: FancyField!
    
    var posts = [Post]()
    static var imageCache: NSCache<NSString,UIImage> = NSCache()
     var imgSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.dataSource = self
        tbl.delegate = self
        imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.delegate = self

        
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            self.tbl.reloadData()
        })
        
    }

    @IBAction func signOut(_ sender: UIButton) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
 
        
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tbl.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.congigureCell(post: post, img: img)
                return cell
            }
            else{
                cell.congigureCell(post: post)
                return cell
            }
        }
        else {
            return PostCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imgSelected = true
            imgAdd.image = img
        }
        else{
            print("Raviv: A vaild image wasnt selected")
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func postBtnTapped(_ sender: RoundedBTN) {
        guard let caption = captionLbl.text , caption != "" else {
            print("Caption must be entered")
            return
        }
        guard let img = imgAdd.image, imgSelected == true else {
            print("img must be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid  = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) {(metadata,error) in
                if error != nil {
                    print("RAVIV: unable to upload image to firebase storage")
                }
                else {
                    print("RAVIV: Successfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imgUrl: downloadURL!)
                }
                
            }}
    }
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String,AnyObject> = ["caption": captionLbl.text! as AnyObject,"imageUrl": imgUrl as AnyObject,"likes": 0 as AnyObject]
        let firebasePost  = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        captionLbl.text = ""
        imgSelected = false
        imgAdd.image = UIImage(named: "add-image")
        tbl.reloadData()
    }
    
    @IBAction func addImgTapped(_ sender: AnyObject) {
        present(imgPicker, animated: true, completion: nil)
    }
    

}
