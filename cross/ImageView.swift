//
//  ImageView.swift
//  cross
//
//  Created by Null on 7/19/19.
//  Copyright © 2019 shaidin. All rights reserved.
//

import UIKit

class ImageView : UIImageView
{
    var pixels_: UnsafeMutablePointer<UInt32>! = nil
    var width_: Int32 = 0
    var height_: Int32 = 0
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func LoadView(_ sender: Int32, _ image_width: Int32)
    {
        DispatchQueue.main.async
        {() in
            self.width_ = image_width;
            let scale = CGFloat(self.width_) / self.frame.width
            self.height_ = Int32(self.frame.height * scale)
            self.ReleasePixels()
            self.pixels_ = UnsafeMutablePointer<UInt32>.allocate(capacity: Int(self.width_ * self.height_))
            let dpi = Int32(UIScreen.main.scale * 160.0 * scale)
            SetImageData(self.pixels_)
            BridgeHandleAsync(sender, "body ready \(dpi) \(self.width_) \(self.height_)")
        }
    }
    
    func ReleasePixels()
    {
        if (pixels_ != nil)
        {
            pixels_.deallocate()
            pixels_ = nil
        }
    }
    
    func Refresh()
    {
        image = UIImage(cgImage:
            CGContext(data: pixels_, width: Int(width_), height: Int(height_),
                      bitsPerComponent: 8, bytesPerRow: 4 * Int(width_),
                      space: CGColorSpace(name: CGColorSpace.genericRGBLinear)!,
                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!.makeImage()!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let pos = touches.first?.location(in: self)
        BridgeHandle("body touch-begin \(pos!.x) \(pos!.y)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let pos = touches.first?.location(in: self)
        BridgeHandle("body touch-move \(pos!.x) \(pos!.y)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let pos = touches.first?.location(in: self)
        BridgeHandle("body touch-end \(pos!.x) \(pos!.y)")
    }
}
