//
//  GOPUtil.m
//  OneLoginDemo
//
//  Created by noctis on 2021/1/25.
//  Copyright © 2021 com.geetest. All rights reserved.
//

#import "GOPUtil.h"

@implementation GOPUtil

+ (UIWindow *)keyWindow {
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    return keyWindow;
}

+ (BOOL)isIphoneXSerial {
    BOOL isIphoneXSerial = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [GOPUtil keyWindow];
        if ([keyWindow isKindOfClass:[UIWindow class]] && [keyWindow respondsToSelector:@selector(safeAreaInsets)] && keyWindow.safeAreaInsets.bottom > 0.0) {
            isIphoneXSerial = YES;
        }
    }
    return isIphoneXSerial;
}

+ (UIColor *)colorFromHexString:(const NSString *)hexString {
    if ([hexString isKindOfClass:[NSString class]] && hexString.length > 0) {
        NSString *tmpHexString = hexString.copy;
        if ([tmpHexString hasPrefix:@"#"]) {
            tmpHexString = [tmpHexString substringFromIndex:[@"#" length]];
        }
        
        if (tmpHexString.length > 0) {
            if (tmpHexString.length >= 8) {             // 大于8位，取前8位
                tmpHexString = [tmpHexString substringToIndex:8];
            } else if (tmpHexString.length >= 6) {      // 大于6位，取前6位
                tmpHexString = [tmpHexString substringToIndex:6];
            } else {                                    // 不足6位，前面补0
                while (tmpHexString.length < 6) {
                    tmpHexString = [@"0" stringByAppendingString:tmpHexString];
                }
            }
            
            NSRange range = NSMakeRange(0, 2);
            NSString *aString = nil;
            if (8 == tmpHexString.length) {
                aString = [tmpHexString substringWithRange:range];
                range.location = range.location + 2;
            }
            NSString *rString = [tmpHexString substringWithRange:range];
            range.location = range.location + 2;
            NSString *gString = [tmpHexString substringWithRange:range];
            range.location = range.location + 2;
            NSString *bString = [tmpHexString substringWithRange:range];
            // 取三种颜色值
            unsigned int r, g, b;
            [[NSScanner scannerWithString:rString] scanHexInt:&r];
            [[NSScanner scannerWithString:gString] scanHexInt:&g];
            [[NSScanner scannerWithString:bString] scanHexInt:&b];
            unsigned int a = 255;
            if (aString.length > 0) {
                [[NSScanner scannerWithString:aString] scanHexInt:&a];
            }
            return [UIColor colorWithRed:((float)r / 255.0f)
                                   green:((float)g / 255.0f)
                                    blue:((float)b / 255.0f)
                                   alpha:((float)a / 255.0f)];
        }
    }
    
    return UIColor.clearColor;
}

@end
