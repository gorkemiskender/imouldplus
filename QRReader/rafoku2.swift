//
//  rafoku2.swift
//  QRReader
//
//  Created by serdar macbook on 12.11.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class rafoku2: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var square: UIImageView!
    
    
    var video = AVCaptureVideoPreviewLayer()
    var selectedPlace = ""
    var yeniRaf = ""
    var konumArray = [String]()
    
    
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
        
       
    }
    

    
    
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObjectTypeQRCode
                {
                    let alert = UIAlertController(title: "Raf numarası doğru mu?", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Hayır", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (nil) in
                        
                        self.yeniRaf = object.stringValue!
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
                                    
                                    
                                    
                                    object["raf"]=self.yeniRaf
                                    object.saveInBackground()
                                    
                                    
                                }
                            }
                        }
                        self.performSegue(withIdentifier: "4to5", sender: nil)
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}

