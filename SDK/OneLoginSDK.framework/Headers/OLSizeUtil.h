//
//  OLSizeUtil.h
//  OneLoginSDK
//
//  Created by noctis on 2019/8/1.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OLSizeUtil : NSObject

+ (BOOL)isEqualToZero:(CGFloat)value;

+ (BOOL)isValidCGSize:(CGSize)size;

+ (CGFloat)leftXOffsetToCenterXOffset:(CGFloat)leftXOffset
                  originCenterXOffset:(CGFloat)originCenterXOffset
                          widgetWidth:(CGFloat)widgetWidth
                           totalWidth:(CGFloat)totalWidth;

@end

NS_ASSUME_NONNULL_END
