//
//  CameraViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/15/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import SwiftyCam
import AVKit

class CameraViewController: SwiftyCamViewController {
    var captureButton: SwiftyCamButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEnabled = false
        defaultCamera = .front
        
        let buttonWidth: CGFloat = 80
        let buttonX = view.frame.width/2 - buttonWidth/2
        
        let buttonHeight: CGFloat = 80
        let buttonY = view.frame.height - 100
        
        let buttonFrame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        captureButton = SwiftyCamButton(frame: buttonFrame)
        captureButton.layer.cornerRadius = 40
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.borderWidth = 3
        
        captureButton.backgroundColor = UIColor.tascent
        view.addSubview(captureButton)
        view.bringSubview(toFront: captureButton)
        
        captureButton.delegate = self
        
        title = "Capture face biometric"
        
        showInstructions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func showInstructions() {
        let title = "Look at the camera with a neutral expression"
        let message = "Avoid:" +
            "\n• Wearing sunglasses or a hat" +
            "\n• Harsh lighting" +
            "\n• A very bright or busy background"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.natural
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
                NSForegroundColorAttributeName : UIColor.tascent
            ]
        )
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet )
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        
        alert.setValue(messageText, forKey: "attributedMessage")
        present(alert, animated: true)
    }
}
