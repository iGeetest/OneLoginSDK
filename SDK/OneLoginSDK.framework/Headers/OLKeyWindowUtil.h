//
//  OLKeyWindowUtil.h
//  OneLoginSDK
//
//  Created by noctis on 2019/9/27.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OLKeyWindowUtil : NSObject

+ (UIWindow *)keyWindow;
+ (BOOL)isIphoneXSerial;

@end

NS_ASSUME_NONNULL_END
