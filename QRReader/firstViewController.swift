//
//  firstViewController.swift
//  QRReader
//
//  Created by Gorkem İskenderoglu on 14.11.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import Parse
class firstViewController: UIViewController {
    
    
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
                }
                
    



@IBAction func signInClicked(_ sender: Any){
    if userNameText.text != "" && passwordText.text != "" {
    
    PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!, block: { (user, error) in
        if error != nil{
            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            UserDefaults.standard.set(self.userNameText.text!, forKey: "username")
            UserDefaults.standard.synchronize()
            
            let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            delegate.rememberUser()
            
            
            
        }

    })


    }else{
        let alert = UIAlertController(title: "Error", message: "Username Needed!", preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
}

