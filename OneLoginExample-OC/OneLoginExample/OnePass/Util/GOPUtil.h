//
//  GOPUtil.h
//  OneLoginDemo
//
//  Created by noctis on 2021/1/25.
//  Copyright © 2021 com.geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GOPUtil : NSObject

+ (UIWindow *)keyWindow;
+ (BOOL)isIphoneXSerial;
+ (UIColor *)colorFromHexString:(const NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
