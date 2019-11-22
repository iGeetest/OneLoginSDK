//
//  BaseViewController.h
//  OneLoginExample
//
//  Created by noctis on 2019/11/21.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OneLoginSDK/OneLoginSDK.h>
#import "GTProgressHUD.h"

#define GTOneLoginAppId @"53cd718a9fd11e4dea99a22f138dc509"
#define GTOneLoginResultURL @"http://onepass.geetest.com/"
#define GTOneLoginIntranetTestURL @"http://10.0.0.25:8886/"         // 内网测试地址
#define GTOneLoginExtranetTestURL @"http://113.57.172.106:25886/"   // 外网测试地址

#define NeedCustomAuthUI

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isNewLogin;

- (CGFloat)ol_screenWidth;
- (CGFloat)ol_screenHeight;

@end

NS_ASSUME_NONNULL_END
