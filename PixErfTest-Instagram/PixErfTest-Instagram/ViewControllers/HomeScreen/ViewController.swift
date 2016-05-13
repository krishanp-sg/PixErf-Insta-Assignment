//
//  ViewController.swift
//  PixErfTest-Instagram
//
//  Created by Krishantha Sunil Premaretna on 9/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {

    var instagramDictionary : NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let commonUtility = CommonUtility();
        self.instagramDictionary = commonUtility.readVlueFromServicePlist("Instagram");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func instagramLoginButtonClicked(sender: AnyObject) {
        
        // Instagram Clint Info
        let clientID:String = self.instagramDictionary.objectForKey("ClientId") as! String;
        let clientSecret:String = self.instagramDictionary.objectForKey("ClientSecret") as! String;
        let redirectUrl:String  = self.instagramDictionary.objectForKey("RedirectUri") as! String;
        
        let oauthswift = OAuth2Swift(
            consumerKey:clientID,
            consumerSecret:clientSecret,
            authorizeUrl:   InstagramConstants.INSTA_AUTH,
            responseType:   "token"
        )
        
        oauthswift.authorizeWithCallbackURL(
            NSURL(string: redirectUrl)!,
            scope: "basic", state:"INSTAGRAM",
            success: { credential, response, parameters in
               
                NSUserDefaults.standardUserDefaults().setValue(credential.oauth_token, forKey: "ClientToken")
                NSUserDefaults.standardUserDefaults().synchronize()
                
               // Setup MyPictures VC
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.setupMyPicturesViewController()
            },
            failure: { error in
                print(error.localizedDescription)
                let alertController = AlertController();
                alertController.showErrorAlert(error.localizedDescription, callingVC: self)
            }
        )
        
    }
}

