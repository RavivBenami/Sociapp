//
//  ViewController.swift
//  Sociapp
//
//  Created by Raviv Benami on 11/09/2017.
//  Copyright © 2017 Raviv Benami. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailTxt: FancyField!
    @IBOutlet weak var pwdTxt: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "toSecVC", sender: nil)
        }
    }
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) in
            if error != nil{
                print("RAVIV: Unable to authenticate with facebook - \(String(describing: error))")
            }else if result?.isCancelled == true
            {
                print("user canclled facebook auth")
                
            }
            else {
                print("successful auth")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
                
            }
            
            
            
           
    })

 }
    func firebaseAuth(_ credential:AuthCredential){
        Auth.auth().signIn(with: credential, completion: {(user,error) in
        
            if error != nil {
                print("unable to authenticate with firebase")
                
            }
            else{
                print("successfuly auth")
                if let user = user {
                    let userData = ["provider":credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        
        })
    }
    @IBAction func signInTapped(_ sender: UIButton) {
        if let email = emailTxt.text,let pwd = pwdTxt.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: {(user,error) in
            if error == nil
            {
             print("user Auth complete")
                if let user = user {
                    let userData = ["provider":user.providerID]
             self.completeSignIn(id: user.uid, userData: userData)
                }
             }
            else {
                Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user,error) in
                    if error != nil
                    {
                        print("error create user")
                    }
                    else {
                        print("user created")
                        if let user = user {
                            let userData = ["Provider":user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                
                })
                }
            
            })
        }
        
    }
    func completeSignIn(id:String,userData: Dictionary<String,String>){
        DataService.ds.createFirbaseUser(uid: id, userData: userData)
      KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data Saved to keychain")
        performSegue(withIdentifier: "toSecVC", sender: nil)
        
    }
}
