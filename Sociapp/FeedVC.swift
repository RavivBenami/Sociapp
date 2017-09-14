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
class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOut(_ sender: UIButton) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
 
        
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }

}
