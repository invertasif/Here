////
//  LoginViewController.swift
//  Here
//
//  Created by Zackery leman on 8/2/14.
//  Copyright (c) 2014 Zackery leman. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
   private let meteor = (UIApplication.sharedApplication().delegate as AppDelegate).meteorClient
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUp: UIButton!
    var nickname: String!

    
    struct StoryBoard {
        static let loggingInSegue = "loggingIn"
    }
    
    // MARK: VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.meteor.addObserver(self, forKeyPath: "websocketReady", options: NSKeyValueObservingOptions.New, context: nil)
        self.confirmPassword.hidden = true 
    }
   
    
    override func viewWillAppear(animated: Bool) {
        var observingOption = NSKeyValueObservingOptions.New
        meteor.addObserver(self, forKeyPath:"websocketReady", options: observingOption, context:nil)
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        
        if (keyPath == "websocketReady" && meteor.websocketReady) {

        }
    }
    
    
    @IBAction func didTapLoginButton(sender: AnyObject) {
        
        if !meteor.websocketReady {
            let notConnectedAlert = UIAlertView(title: "Connection Error", message: "Can't find the server, try again", delegate: nil, cancelButtonTitle: "OK")
            notConnectedAlert.show()
            return
        }
        
        meteor.logonWithEmail(self.email.text, password: self.password.text) {(response, error) -> Void in
            
            if error != nil {
                self.handleFailedAuth(error)
                return
            }
            self.handleSuccessfulAuth()
        }
    }
    
    func handleSuccessfulAuth() {
     performSegueWithIdentifier(StoryBoard.loggingInSegue, sender: nil)
  
    }
    
    func handleFailedAuth(error: NSError) {
        UIAlertView(title: "Here", message:error.localizedDescription, delegate: nil, cancelButtonTitle: "Try Again").show()
    }
    

    
}


