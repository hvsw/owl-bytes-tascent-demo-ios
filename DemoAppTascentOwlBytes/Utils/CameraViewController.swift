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
        let buttonY = view.frame.height - buttonHeight*2
        
        let buttonFrame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        captureButton = SwiftyCamButton(frame: buttonFrame)
        captureButton.layer.cornerRadius = 40
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.borderWidth = 3
        
        captureButton.backgroundColor = UIColor.tascent
        view.addSubview(captureButton)
        view.bringSubview(toFront: captureButton)
        
        captureButton.delegate = self
    }
}
