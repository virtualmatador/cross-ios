//
//  ImageView.swift
//  cross
//
//  Created by Null on 7/19/19.
//  Copyright © 2019 shaidin. All rights reserved.
//

import UIKit

class ImageView : UIViewController
{
    var view_: UIImageView!
    var sender_: Int32 = 0
    var image_width_ : Int32 = 0
    var pixels_: UnsafeMutablePointer<UInt32>! = nil
    var width_: Int32 = 0
    var height_: Int32 = 0
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        view_ = UIImageView(coder: aDecoder)
        view = view_
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        width_ = image_width_;
        let scale = CGFloat(width_) / view_.frame.width
        height_ = Int32(view_.frame.height * scale)
        ReleasePixels()
        pixels_ = UnsafeMutablePointer<UInt32>.allocate(capacity: Int(width_ * height_))
        let dpi = Int32(UIScreen.main.scale * 160.0 * scale)
        DispatchQueue.main.async
        {[pixels_, sender_, width_, height_]() in
            SetImageData(pixels_)
            BridgeHandleAsync(sender_, "body ready \(dpi) \(width_) \(height_)")
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
        view_.image = UIImage(cgImage:
            CGContext(data: pixels_, width: Int(width_), height: Int(height_),
                      bitsPerComponent: 8, bytesPerRow: 4 * Int(width_),
                      space: CGColorSpace(name: CGColorSpace.genericRGBLinear)!,
                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!.makeImage()!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let pos = touches.first?.location(in: view_)
        BridgeHandle("body touch-begin \(pos!.x) \(pos!.y)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let pos = touches.first?.location(in: view_)
        BridgeHandle("body touch-move \(pos!.x) \(pos!.y)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let pos = touches.first?.location(in: view_)
        BridgeHandle("body touch-end \(pos!.x) \(pos!.y)")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (UIApplication.shared.keyWindow?.rootViewController!.supportedInterfaceOrientations)!
    }
}
