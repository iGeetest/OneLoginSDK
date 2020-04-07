//
//  SwiftBaseViewController.swift
//  OneLoginExample
//
//  Created by 刘练 on 2020/2/4.
//  Copyright © 2020 geetest. All rights reserved.
//

import UIKit

class SwiftBaseViewController: UIViewController {
    let GTOneLoginAppId = "b41a959b5cac4dd1277183e074630945"
    let GTOneLoginResultURL = "http://onepass.geetest.com/onelogin/result"
    let GTOnePassAppId = "3996159873d7ccc36f25803b88dda97a"
    let GTOnePassVerifyURL = "http://onepass.geetest.com/v2.0/result"
    
    let GTCaptchaAPI1 = "http://www.geetest.com/demo/gt/register-test"
    let GTCaptchaAPI2 = "http://www.geetest.com/demo/gt/validate-test"
    
    let NeedCustomAuthUI = true
    let OLAuthVCAutoLayout = true
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func ol_screenHeight() -> CGFloat {
        return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    }
    
    func ol_screenWidth() -> CGFloat {
        return min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    }
    
    func ol_integrateGTCaptcha() -> Bool {
        let x = arc4random() % 2
        return 0 == x
    }
    
    func ol_integrateGTCaptchaInSDK() -> Bool {
        let x = arc4random() % 2
        return 0 == x
    }
}
