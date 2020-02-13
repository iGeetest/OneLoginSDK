//
//  SwiftResultViewController.swift
//  OneLoginExample
//
//  Created by 刘练 on 2020/2/5.
//  Copyright © 2020 geetest. All rights reserved.
//

import UIKit

class SwiftResultViewController: SwiftBaseViewController {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "本机号码校验成功"
        self.resultImageView.image = UIImage.init(named: "purple_center")
        self.resultLabel.text = "本机号码校验成功"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
        
    // MARK: - Button Action
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
