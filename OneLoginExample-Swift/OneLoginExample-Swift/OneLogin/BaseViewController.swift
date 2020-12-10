//
//  SwiftBaseViewController.swift
//  OneLoginExample
//
//  Created by 刘练 on 2020/2/4.
//  Copyright © 2020 geetest. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // OneLogin
    let GTOneLoginAppId = "b41a959b5cac4dd1277183e074630945"
    let GTOneLoginResultURL = "http://onepass.geetest.com/onelogin/result"
    
    // OnePass
    let GTOnePassAppId = "3996159873d7ccc36f25803b88dda97a"
    let GTOnePassVerifyURL = "http://onepass.geetest.com/v2.0/result"
        
    let NeedCustomAuthUI = true
    let OLAuthVCAutoLayout = true
        
    // MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Screen
    
    func ol_screenHeight() -> CGFloat {
        return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    }
    
    func ol_screenWidth() -> CGFloat {
        return min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    }
    
    func isIPhoneXScreen() -> Bool {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window, let bottom = window?.safeAreaInsets.bottom {
                return bottom > 0.0
            }
        }
        return false
    }
}
