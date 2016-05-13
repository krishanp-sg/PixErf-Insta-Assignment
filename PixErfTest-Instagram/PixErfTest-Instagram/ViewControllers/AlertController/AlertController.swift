//
//  AlertController.swift
//  PixErfTest-Instagram
//
//  Created by Krishantha Sunil Premaretna on 10/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import UIKit

class AlertController: NSObject {
    
    func showErrorAlert(errorMessage:String , callingVC:UIViewController) {
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        callingVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showFailureAlertAndExitApp(errorMessage:String , callingVC:UIViewController) {
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{(action:UIAlertAction) in
            exit(0)
        }));
        callingVC.presentViewController(alert, animated: true, completion: nil)
    }


}
