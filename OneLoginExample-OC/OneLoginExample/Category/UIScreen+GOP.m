//
//  UIScreen+OL.m
//  OneLoginSDK
//
//  Created by NikoXu on 2019/5/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "UIScreen+GOP.h"
#import "GOPUtil.h"

@implementation UIScreen (GOP)

+ (UIEdgeInsets)gop_safeAreaInsets:(BOOL)isLandscape {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    if (isLandscape) {
        safeAreaInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    if (@available(iOS 11.0, *)) {
        UIWindow *window = [GOPUtil keyWindow];
        if ([window respondsToSelector:@selector(safeAreaInsets)]) {
            CGFloat top     = MAX(safeAreaInsets.top, window.safeAreaInsets.top);
            CGFloat bottom  = MAX(safeAreaInsets.bottom, window.safeAreaInsets.bottom);
            CGFloat left    = MAX(safeAreaInsets.left, window.safeAreaInsets.left);
            CGFloat right   = MAX(safeAreaInsets.right, window.safeAreaInsets.right);
            if (fabs(left - right) < 0.000001 && left > top) {
                top = left;
                left = right = 0;
            }
            safeAreaInsets = UIEdgeInsetsMake(top, left, bottom, right);
        }
    }
    
    return safeAreaInsets;
}

+ (CGFloat)gop_screenWidth {
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+ (CGFloat)gop_screenHeight {
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

@end
