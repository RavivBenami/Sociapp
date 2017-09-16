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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.dataSource = self
        tbl.delegate = self
    }

    @IBAction func signOut(_ sender: UIButton) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
 
        
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tbl.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    

}
