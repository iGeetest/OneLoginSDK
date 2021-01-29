//
//  OLButton.m
//  OneLoginSDK
//
//  Created by noctis on 2019/8/2.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "GOPButton.h"

@implementation GOPButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(20, 0);
    CGFloat heightDelta = MAX(20, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
