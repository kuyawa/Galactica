//
//  QRCode.swift
//  Galactica
//
//  Created by Laptop on 2/8/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import Foundation

class QRCode {
    
    static func generate(text: String, size: Int) -> NSImage? {
        let data = text.data(using: .utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            //filter.setValue("L", forKey: "inputCorrectionLevel") // L low, M med, Q quality, H high
            
            if let output = filter.outputImage {
                let ratioW = size / Int(output.extent.size.width)
                let ratioH = size / Int(output.extent.size.height)
                let transform = CGAffineTransform(scaleX: CGFloat(ratioW), y: CGFloat(ratioH))
                
                if let result = filter.outputImage?.applying(transform) {
                    let imageRep = NSCIImageRep(ciImage: result)
                    let image = NSImage(size: NSSize(width: size, height: size))
                    image.addRepresentation(imageRep)
                    return image
                }
            }
        }
        
        return nil
    }
}
