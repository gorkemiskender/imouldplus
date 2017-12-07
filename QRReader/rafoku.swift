//
//  rafoku.swift
//  QRReader
//
//  Created by serdar macbook on 1.11.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class rafoku: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    
    @IBOutlet weak var square: UIImageView!
    
    var video = AVCaptureVideoPreviewLayer()
    var placeNameArray = [String]()
    var chosenPlace = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
        getData()
    }
    
    func getData() {
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground  { (objects, error) in
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion:nil)
                
                
            } else {
                
                self.placeNameArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    
                    self.placeNameArray.append(object.object(forKey: "name") as! String)
                    
                }
                
                
            }
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        let destinationVC = segue.destination as! rafoku2
        destinationVC.selectedPlace = chosenPlace
        
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObjectTypeQRCode
                {
                    let alert = UIAlertController(title: "Değiştirmek istediğiniz kalıp numarası doğru mu?", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Hayır", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (nil) in
                        
                        self.chosenPlace = object.stringValue!
                        self.performSegue(withIdentifier: "3to1", sender: nil)
                        
                        
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}
