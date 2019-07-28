//
//  ViewController.swift
//  cross
//
//  Created by Ali Asadpoor on 1/15/19.
//  Copyright © 2019 Shaidin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController
{
    var view_info_: Int32 = 0
    var menu_options_: [String] = []
    var sender_: Int32 = 0
    
    @IBOutlet var web_view_: WebView!
    @IBOutlet var image_view_: ImageView!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        (UIApplication.shared.delegate as! AppDelegate).view_controller_ = self
    }
    
    func LoadWebView(_ sender: Int32, _ view_info: Int32, _ html: String)
    {
        image_view_.isHidden = true
        ActivateView(sender, view_info)
        {
            self.web_view_.isHidden = false
            self.image_view_.ReleasePixels()
            self.web_view_.LoadView(sender, html)
        }
    }
    
    func LoadImageView(_ sender: Int32, _ view_info: Int32, _ image_width: Int32)
    {
        web_view_.isHidden = true
        web_view_.Clear();
        ActivateView(sender, view_info)
        {
            self.image_view_.isHidden = false
            self.image_view_.LoadView(sender, image_width)
        }
     }
    
    func ActivateView(_ sender: Int32, _ view_info: Int32, _ update: @escaping ()->Void)
    {
        sender_ = sender
        menu_options_ = []
        let root_controller = presentingViewController as! RootController
        root_controller.view_info_ = view_info
        root_controller.dismiss(animated: false)
        {
            root_controller.present(self, animated: false)
            {
                update()
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return presentingViewController!.supportedInterfaceOrientations
    }
    
    @IBAction func ShowMenu(_ sender: UIButton)
    {
        if (!menu_options_.isEmpty)
        {
            let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            BridgeHandle("menu +")
            for option in menu_options_
            {
                menu.addAction(UIAlertAction(title: option, style: .default, handler:
                {[sender_] _ in
                    BridgeHandleAsync(sender_, "menu \(option)")
                    BridgeHandleAsync(sender_, "menu -")
                }))
            }
            menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
            {[sender_] _ in
                BridgeHandleAsync(sender_, "menu -")
            }))
            present(menu, animated: true)
        }
    }
}
