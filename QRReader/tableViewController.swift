//
//  tableViewController.swift
//  QRReader
//
//  Created by Gorkem İskenderoglu on 15.11.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import Parse

class tableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var MouldArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getData()
    }
    
    func getData() {
        let query = PFQuery(className: "tadilat")
        query.findObjectsInBackground  { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
            } else {
                self.MouldArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.MouldArray.append(object.object(forKey: "name") as! String)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MouldArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MouldArray[indexPath.row]
        return cell
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
         performSegue(withIdentifier: "toYeniKalipOkut", sender: nil)
    }
}
