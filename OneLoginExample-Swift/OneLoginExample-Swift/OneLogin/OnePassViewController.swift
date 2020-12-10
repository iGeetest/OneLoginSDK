//
//  SwiftOnePassViewController.swift
//  OneLoginExample
//
//  Created by 刘练 on 2020/2/5.
//  Copyright © 2020 geetest. All rights reserved.
//

import UIKit
import OneLoginSDK

struct CheckSmsResult: Codable {
    var result: Bool
}

struct VerifyPhoneResult: Codable {
    var status: Int
    var result: String
}

class OnePassViewController: BaseViewController, GOPManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTF: UITextField!
    
    private lazy var gopManager: GOPManager = {
        let manager = GOPManager.init(customID: GTOnePassAppId, timeout: 10.0)
        manager.delegate = self as GOPManagerDelegate
        return manager
    }()
    
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "本机号码校验"
        
        // 配置开启缓存手机号功能(默认开启)
        GOPManager.setCachePhoneEnabled(true)
        
        // 获取缓存在本地的手机号
        if let phone = GOPManager.getCachedPhone(), phone.count > 0 {
            self.phoneNumberTF.text = phone
        }
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didViewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Button Action
    @IBAction func nextAction(_ sender: Any) {
        self.startOnepass()
    }
    
    @objc func didViewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK: OnePass
    
    func startOnepass() {
        self.doOnePass()
    }
    
    func doOnePass() {
        var phoneNumber = self.phoneNumberTF.text
        phoneNumber = phoneNumber?.replacingOccurrences(of: " ", with: "")
        if self.checkPhoneNumFormat(phoneNumber) {
            GTProgressHUD.showLoadingHUD(withMessage: nil)
            self.gopManager.verifyPhoneNumber(phoneNumber)
        } else {
            self.phoneNumberTF.text = nil
            self.phoneNumberTF.gtm_shake(9, witheDelta: 2.0, speed: 0.1, completion: nil)
            GTProgressHUD.showToast(withMessage: "不合法的手机号")
        }
    }
    
    func checkPhoneNumFormat(_ phoneNumber: String?) -> Bool {
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,147,148,150,151,152,157,158,159,172,178,182,183,184,187,188,198
         * 联通：130,131,132,145,146,152,155,156,166,171,175,176,185,186
         * 电信：133,1349,153,173,174,177,180,181,189,199
         */
        
        /**
         * 宽泛的手机号过滤规则
         */
        let MOBILE = "^1([3-9])\\d{9}$"
        
        /**
         * 虚拟运营商: Virtual Network Operator
         * 不支持
         */
        let VNO = "^170\\d{8}$"
        
        /**
         * 中国移动：China Mobile
         * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,172,178,182,183,184,187,188
         */
        let CM = "^1(34[0-8]|(3[5-9]|4[78]|5[0-27-9]|7[28]|8[2-478]|98)\\d)\\d{7}$"
        
        /**
         * 中国联通：China Unicom
         * 130,131,132,152,155,156,176,185,186
         */
        let CU = "^1(3[0-2]|45|5[256]|7[156]|8[56])\\d{8}$"
        
        /**
         * 中国电信：China Telecom
         * 133,1349,153,173,177,180,181,189
         */
        let CT = "^1((33|53|7[347]|8[019]|99)[0-9]|349)\\d{7}$"
        
        let regexTestMobile = NSPredicate.init(format: "SELF MATCHES %@", MOBILE)
        let regexTestVNO = NSPredicate.init(format: "SELF MATCHES %@", VNO)
        let regexTestCM = NSPredicate.init(format: "SELF MATCHES %@", CM)
        let regexTestCU = NSPredicate.init(format: "SELF MATCHES %@", CU)
        let regexTestCT = NSPredicate.init(format: "SELF MATCHES %@", CT)
        
        if (regexTestMobile.evaluate(with: phoneNumber) &&
            ((regexTestCM.evaluate(with: phoneNumber))  ||
            (regexTestCU.evaluate(with: phoneNumber))   ||
            (regexTestCT.evaluate(with: phoneNumber)))  &&
            !regexTestVNO.evaluate(with: phoneNumber)) {
            return true
        }
        
        return false
    }
    
    // MARK: GOPManagerDelegate
    
    func gtOnePass(_ manager: GOPManager, didReceiveDataToVerify data: [AnyHashable : Any]) {
        var params = data
        params["id_2_sign"] = GTOnePassAppId
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.fragmentsAllowed)
            let url = URL.init(string: GTOnePassVerifyURL)
            var mRequest = URLRequest.init(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10.0)
            mRequest.httpMethod = "POST"
            mRequest.httpBody = data
            let dataTask = URLSession.shared.dataTask(with: mRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async {
                    GTProgressHUD.hideAllHUD()
                    
                    guard let strongSelf = self else { return }
                    
                    if let error = error {
                        print("verify phone error: \(error)")
                        strongSelf.verifyPhoneNumberFailed()
                        return
                    }
                    
                    var verifyPhoneResult: VerifyPhoneResult?
                    if let data = data {
                        do {
                            verifyPhoneResult = try JSONDecoder().decode(VerifyPhoneResult.self, from: data)
                        } catch {
                            
                        }
                    }
                    
                    if let verifyPhoneResult = verifyPhoneResult, 200 == verifyPhoneResult.status {
                        if "0" == verifyPhoneResult.result {
                            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                            let resultViewController = storyboard.instantiateViewController(withIdentifier: "ResultViewController")
                            strongSelf.navigationController?.pushViewController(resultViewController, animated: true)
                        } else if "1" == verifyPhoneResult.result {
                            GTProgressHUD.showToast(withMessage: "非本机号码")
                        } else {
                            strongSelf.verifyPhoneNumberFailed()
                        }
                    } else {
                        strongSelf.verifyPhoneNumberFailed()
                    }
                }
            }
            dataTask.resume()
        } catch {
            
        }
    }
    
    func gtOnePass(_ manager: GOPManager, errorHandler error: GOPError) {
        print("gtonepass errorHandler: ", error)
        self.verifyPhoneNumberFailed()
    }
    
    func verifyPhoneNumberFailed() {
        DispatchQueue.main.async {
            GTProgressHUD.showToast(withMessage: "本机号码校验失败")
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if 11 == textField.text?.count {
            self.startOnepass()
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
}
