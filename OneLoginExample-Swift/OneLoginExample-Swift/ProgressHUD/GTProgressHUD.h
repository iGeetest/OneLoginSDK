//
//  GTProgressHUD.h
//  OneLoginCTDemo
//
//  Created by noctis on 2019/7/18.
//  Copyright © 2019 com.geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTProgressHUD : NSObject

// MARK: Toast
+ (void)showToastWithMessage:(NSString *)message;
+ (void)showToastAtBottomWithMessage:(NSString *)message;

// MARK: HUD
+ (void)showLoadingHUDWithMessage:(NSString * _Nullable)message;
+ (void)showLoadingHUDWithMessage:(NSString * _Nullable)message inView:(UIView * _Nullable)view;

+ (void)hideLoadingHUDInView:(UIView * _Nullable)view;
+ (void)hideAllHUD;

@end

NS_ASSUME_NONNULL_END
