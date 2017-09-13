//
//  FaceDetector.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit.UIImage

class FaceDetector {
//    static func getFaces(from image: UIImage) -> [UIImage]? {
//        guard let personciImage = CIImage(image: image) else {
//            return nil
//        }
//        
//        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//        guard let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy) else {
//            return nil
//        }
//        
//        guard let faces = faceDetector.features(in: personciImage) as? [CIFaceFeature] else {
//            return nil
//        }
//        
//        // For converting the Core Image Coordinates to UIView Coordinates
//        let ciImageSize = personciImage.extent.size
//        var transform = CGAffineTransform(scaleX: 1, y: -1)
//        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
//        
////        let facesImages = faces.map({image.crop(to: $0.bounds)})
////        return facesImages
//        for face in faces {
//            print("Found bounds are \(face.bounds)")
//            
//            // Apply the transform to convert the coordinates
//            var faceViewBounds = face.bounds.applying(transform)
//            
//            // Calculate the actual position and size of the rectangle in the image view
//            let viewSize = personPic.bounds.size
//            let scale = min(viewSize.width / ciImageSize.width,
//                            viewSize.height / ciImageSize.height)
//            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
//            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
//            
//            faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale))
//            faceViewBounds.origin.x += offsetX
//            faceViewBounds.origin.y += offsetY
//            
//            let faceBox = UIView(frame: faceViewBounds)
//            
//            faceBox.layer.borderWidth = 3
//            faceBox.layer.borderColor = UIColor.red.cgColor
//            faceBox.backgroundColor = UIColor.clear.cgColor
//            personPic.addSubview(faceBox)
//            
//            if face.hasLeftEyePosition {
//                print("Left eye bounds are \(face.leftEyePosition)")
//            }
//            
//            if face.hasRightEyePosition {
//                print("Right eye bounds are \(face.rightEyePosition)")
//            }
//        }
//    }
}

extension UIImage {
    func crop(to rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
