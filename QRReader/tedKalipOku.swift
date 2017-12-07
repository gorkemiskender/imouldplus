//
//  tedKalipOku.swift
//  QRReader
//
//  Created by Gorkem İskenderoglu on 15.11.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class tedKalipOku: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
  
    @IBOutlet weak var square: UIImageView!
    
    var video = AVCaptureVideoPreviewLayer()
    var chosenPlace1 = ""
    
    

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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        var destinationVC = segue.destination as! detailsVC
        destinationVC.selectedPlace1 = chosenPlace1
        
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
                            
                            self.chosenPlace1 = object.stringValue!
                            self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
                            
                            
                        }))
                        
                        present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
   
   

}
