//
//  CameraVCDummy.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import CoreImage
import Foundation
import Fusuma
import UIKit

class CameraViewControllerDummy: UIViewController, FusumaDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let api: APIClientProtocol = StubAPI()
    
    @IBAction func didTapOpenCamera(_ sender: Any) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        //        fusuma.availableModes = [.library, .camera, .video] // default is [.library, .camera].
        fusumaTintColor = .white
        fusumaBackgroundColor = .darkGray
        fusumaBaseTintColor = .lightGray
        
        
        fusuma.cropHeightRatio = 0.6 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = true // You can select multiple photos from the camera roll. The default value is false.
        present(fusuma, animated: true, completion: nil)
    }
    
    // MARK: - FusumaDelegate
    func fusumaClosed() {
        debugPrint("Closed")
    }
    
    func fusumaWillClosed() {
        debugPrint("Will close")
    }
    
    func fusumaCameraRollUnauthorized() {
        debugPrint("Not authorized")
        showError("You must enable camera access in order to use this feature. Please access your settings and enable camera for this app.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        debugPrint(#function)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        debugPrint(#function)
        
        guard let data = image.data else {
            return
        }
        
        api.qualityCheck(imageData: data) { (suc: Bool, error: Error?) in
            if error == nil {
                if suc {
                    debugPrint("valid image")
                    self.imageView.image = image
                } else {
                    self.showError("Invalid image")
                }
            } else {
                self.showError("Error checking the image! \nDetails: \(error!)")
            }
        }
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        debugPrint(#function)
        //        var faceImages = [UIImage]()
        //        images.map({faceImages.append(FaceDetector.getFaces(from: $0).flatMap($0))})
        
        guard let image = images.first, let data = image.data else {
            showError("Error generating data from image")
            return
        }
        
        api.qualityCheck(imageData: data) { (suc: Bool, error: Error?) in
            if error == nil {
                if suc {
                    debugPrint("valid image")
                    self.imageView.image = image
                } else {
                    self.showError("Invalid image")
                }
            } else {
                self.showError("Error checking the image! \nDetails: \(error!)")
            }
        }
        
    }
}

