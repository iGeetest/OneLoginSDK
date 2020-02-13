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

#define GTOneLoginAppId @"b41a959b5cac4dd1277183e074630945"
#define GTOneLoginResultURL @"http://onepass.geetest.com/"

#define GTOnePassAppId @"3996159873d7ccc36f25803b88dda97a"
#define GTOnePassVerifyURL @"http://onepass.geetest.com/v2.0/result"

#define NeedCustomAuthUI
#define OLAuthVCAutoLayout

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isNewLogin;

- (CGFloat)ol_screenWidth;
- (CGFloat)ol_screenHeight;

@end

NS_ASSUME_NONNULL_END
