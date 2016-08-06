//
//  ViewController.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/25/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func displayErrorAlert(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK pressed for error message: " + message)
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func goToMainThread(handler: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            handler()
        }
    }

}

