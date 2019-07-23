//
//  ViewController.swift
//  cross
//
//  Created by Ali Asadpoor on 1/15/19.
//  Copyright © 2019 Shaidin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var web_view_: WebView
    var image_view_: ImageView
    var view_info_: Int32 = 0
    var temp_buffer_: String = ""
    
    required init?(coder aDecoder: NSCoder)
    {
        web_view_ = WebView(coder: aDecoder)!
        image_view_ = ImageView(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).vc_ = self
    }
    
    func ActivateView(_ view :UIViewController,_ view_info: Int32)
    {
        let presenting =
        {
            self.view_info_ = view_info
            self.present(view, animated:false, completion:
            {
                UIApplication.shared.isIdleTimerDisabled = (self.view_info_ & 4) != 0
                view.viewDidLoad()
            })
        }
        if (presentedViewController == nil)
        {
            presenting();
        }
        else
        {
            dismiss(animated:true, completion: presenting)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        switch view_info_ & 3 {
        case 1:
            return .portrait
        case 2:
            return .landscape
        default:
            return .allButUpsideDown
        }
    }
}
