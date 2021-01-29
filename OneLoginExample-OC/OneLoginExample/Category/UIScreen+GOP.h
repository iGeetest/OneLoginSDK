//
//  UIScreen+OL.h
//  OneLoginSDK
//
//  Created by NikoXu on 2019/5/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (GOP)

+ (UIEdgeInsets)gop_safeAreaInsets:(BOOL)isLandscape;
+ (CGFloat)gop_screenWidth;
+ (CGFloat)gop_screenHeight;

@end

NS_ASSUME_NONNULL_END
