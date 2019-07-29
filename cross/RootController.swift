//
//  RootController.swift
//  cross
//
//  Created by Ali Asadpoor on 7/27/19.
//  Copyright © 2019 shaidin. All rights reserved.
//

import UIKit

class RootController: UIViewController
{
    var child_controller_: ViewController
    var view_info_: Int32 = 0
    
    required init?(coder aDecoder: NSCoder)
    {
        child_controller_ = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: "container") as! ViewController
        super.init(coder: aDecoder)
        (UIApplication.shared.delegate as! AppDelegate).root_controller_ = self
    }
    
    func LoadController(_ callback: @escaping ()->Void)
    {
        let presentation =
        {
            self.present(self.child_controller_, animated: false)
            {
                callback();
            }
        }
        if (presentedViewController == nil)
        {
            presentation()
        }
        else
        {
            dismiss(animated: false)
            {
                presentation();
            }
        }
    }
    
    func UnloadController(_ callback: @escaping ()->Void)
    {
        callback();
        child_controller_.web_view_.Clear()
        child_controller_.image_view_.Clear()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        switch (view_info_ & 3)
        {
        case 1:
            return .portrait
        case 2:
            return .landscape
        default:
            return .allButUpsideDown
        }
    }
}
