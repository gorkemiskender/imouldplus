//
//  kalipdetay.swift
//  QRReader
//
//  Created by serdar macbook on 31.10.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import Parse

class kalipdetay: UIViewController {

    var selectedPlace = ""
    var selectedDurum = String()
    
    let durums = ["Hazır","Pasif","Hazırlanacak","Tadilat"]

    
    
    @IBOutlet weak var maxion1: UIImageView!
    @IBOutlet weak var maxion2: UIImageView!
    @IBOutlet weak var status: UITextField!
    @IBOutlet weak var placename: UILabel!
    @IBOutlet weak var placedesc: UILabel!
    @IBOutlet weak var konum: UILabel!
    
    var nameArray = [String]()
    var descArray = [String]()
    var statusArray = [String]()
    var konumArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLayoutSubviews()
       
        status.layer.backgroundColor = UIColor.white.cgColor
        status.layer.borderColor = UIColor.white.cgColor
        status.layer.borderWidth = 0.0
        status.layer.cornerRadius = 5
        status.layer.masksToBounds = false
        status.layer.shadowRadius = 2
        status.layer.shadowColor = UIColor.white.cgColor
        status.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        status.layer.shadowOpacity = 1.0
        status.layer.shadowRadius = 1.0
        
        
        
        findPlacefromServer()
        
        createDurumPicker()
        
        createToolbar()
    }
    
    
    
    func findPlacefromServer() {
        
        let query = PFQuery(className: "Places")
        query.whereKey("name", equalTo: self.selectedPlace)
        query.findObjectsInBackground  {  (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
                
            }  else {
                
                self.nameArray.removeAll(keepingCapacity: false)
                self.descArray.removeAll(keepingCapacity: false)
                self.statusArray.removeAll(keepingCapacity: false)
                self.konumArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.nameArray.append(object.object(forKey: "name") as! String)
                    self.descArray.append(object.object(forKey: "description") as! String)
                    self.statusArray.append(object.object(forKey: "durum") as! String)
                    self.konumArray.append(object.object(forKey: "raf") as! String )
                    
                    self.placename.text = "\(self.nameArray.last!)"
                    self.placedesc.text = "\(self.descArray.last!)"
                    self.status.text = "\(self.statusArray.last!)"
                    self.konum.text = "\(self.konumArray.last!)"
                    
                    
                }
            }
        }
    }
    
   
        
    @IBAction func raf_degistir(_ sender: Any) {
        
       
        self.performSegue(withIdentifier: "2to3", sender: nil)
        
        
        
  }
  
    func createDurumPicker() {
        
        let durumPicker = UIPickerView()
        durumPicker.delegate = self
        
        status.inputView = durumPicker
        
        durumPicker.backgroundColor = .black
        
    }

    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(kalipdetay.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        status.inputAccessoryView = toolBar

    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
        
    }
        
  
    @IBAction func logoutClicked(_ sender: Any) {
        
        PFUser.logOutInBackground { (error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
                
            } else {
                
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! firstViewController
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = signIn
                delegate.rememberUser()
                
            }
        }

    }
}

extension kalipdetay: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durums[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDurum = durums[row]
        status.text = selectedDurum
        
        let query = PFQuery(className: "Places")
        query.whereKey("name", equalTo: self.selectedPlace)
        query.findObjectsInBackground  {  (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
                
            }  else {
                
                for object in objects! {
                    object["durum"] = self.selectedDurum
                    object.saveInBackground()

                }
            }
        }
 
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label=view
        } else {
            label = UILabel()
            

        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "System", size: 10)
        label.text = durums[row]
        
        return label
  
    }
 
}





