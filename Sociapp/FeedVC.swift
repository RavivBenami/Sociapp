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
class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbl: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.dataSource = self
        tbl.delegate = self
        
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
        print("RAVIV: \(post.caption)")
        return tbl.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    

}
