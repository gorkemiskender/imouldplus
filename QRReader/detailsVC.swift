//
//  detailsVC.swift
//  QRReader
//
//  Created by Gorkem İskenderoglu on 15.11.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import Parse

class detailsVC: UIViewController {
    
    
  
    
    
    @IBOutlet weak var kalipadi: UILabel!
    @IBOutlet weak var status: UITextField!
    @IBOutlet weak var tadilat: UITextField!
    
    var selectedPlace1 = String()
    var selectedDurum = String()
    var selectedTadilat = String()
    
    let durums = ["Yapılıyor","Yapıldı","Beklemede"]

   
    
     var statusArray = [String]()

   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        kalipadi?.text = selectedPlace1
        
        
        findPlacefromServer()
        
        createDurumPicker()
        
        createToolbar()
        
     
     
    }
    
    func findPlacefromServer() {
        
        let query = PFQuery(className: "tadilat")
        query.whereKey("name", equalTo: self.selectedPlace1)
        query.findObjectsInBackground  {  (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
                
            }  else {
                
                self.statusArray.removeAll(keepingCapacity: false)
                
                
                
                for object in objects! {
                    
                    self.statusArray.append(object.object(forKey: "durum") as! String)
                    
                    
                    self.status.text = "\(self.statusArray.last!)"
                          }
            }
        }
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
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(detailsVC.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        status.inputAccessoryView = toolBar
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
        
    }
    
    @IBAction func kaydet(_ sender: Any) {
        
        let object = PFObject(className: "Tadilat")
        object["name"] = self.selectedPlace1
        object["durum"] = self.selectedDurum
        self.selectedTadilat = (tadilat?.text)!
        object["tadilat"] = self.selectedTadilat
        
        
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
                
                
            } else {
                
                self.performSegue(withIdentifier: "finishnewtadilat", sender: nil)
                
                
            }
            
            
            
            
        }
        
        
    
    
    
    
    
    
}
    
}



        
    
extension detailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
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



