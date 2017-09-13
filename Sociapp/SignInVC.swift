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
class SignInVC: UIViewController {
    @IBOutlet weak var emailTxt: FancyField!
    @IBOutlet weak var pwdTxt: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        
        })
    }
    @IBAction func signInTapped(_ sender: UIButton) {
        if let email = emailTxt.text,let pwd = pwdTxt.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: {(user,error) in
            if error == nil
            {
             print("user Auth complete")
                
             }
            else {
                Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user,error) in
                    if error != nil
                    {
                        print("error create user")
                    }
                    else {
                        print("user created")
                    }
                
                })
                }
            
            })
        }
        
    }

}
