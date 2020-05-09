//
//  SwiftBaseViewController.swift
//  OneLoginExample
//
//  Created by 刘练 on 2020/2/4.
//  Copyright © 2020 geetest. All rights reserved.
//

import UIKit

struct ValidateTokenResult: Codable {
    var status: Int
    var result: String?
}

class SwiftBaseViewController: UIViewController {
    let GTOneLoginAppId = "b41a959b5cac4dd1277183e074630945"
    let GTOneLoginResultURL = "http://onepass.geetest.com/onelogin/result"
    let GTOnePassAppId = "3996159873d7ccc36f25803b88dda97a"
    let GTOnePassVerifyURL = "http://onepass.geetest.com/v2.0/result"
    
    let GTCaptchaAPI1 = "http://www.geetest.com/demo/gt/register-test"
    let GTCaptchaAPI2 = "http://www.geetest.com/demo/gt/validate-test"
    
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
    
    // MARK: Validate Token
        
    func validateToken(token: String?, appId: String?, processID: String?, authcode: String?, completion: @escaping (Result<ValidateTokenResult, Error>) -> Void) {
        var params = Dictionary<String, Any>.init()
        if let token = token {
            params["token"] = token
        }
        if let processID = processID {
            params["process_id"] = processID
        }
        if let appId = appId {
            params["id_2_sign"] = appId
        }
        if let authcode = authcode {
            params["authcode"] = authcode
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.fragmentsAllowed)
            /**
             * 根据用户自己接口构造
             * demo仅做演示
             * 请不要在线上使用该接口 http://onepass.geetest.com/onelogin/result
             */
            let url = URL.init(string: GTOneLoginResultURL)
            var mRequest = URLRequest.init(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10.0)
            mRequest.httpMethod = "POST"
            mRequest.httpBody = data
            let dataTask = URLSession.shared.dataTask(with: mRequest) { (data: Data?, response: URLResponse?, error: Error?) in
                var validateTokenResult: ValidateTokenResult?
                if let data = data {
                    do {
                        validateTokenResult = try JSONDecoder().decode(ValidateTokenResult.self, from: data)
                    } catch {
                        
                    }
                }
                
                if let validateTokenResult = validateTokenResult {
                    completion(.success(validateTokenResult))
                } else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(NSError.init(domain: "validate token error", code: 30000, userInfo: nil)))
                    }
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(NSError.init(domain: "JSON Serialization error", code: 30001, userInfo: nil)))
        }
    }

}
