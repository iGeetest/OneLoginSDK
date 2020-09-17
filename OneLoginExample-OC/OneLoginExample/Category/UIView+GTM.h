#import <UIKit/UIKit.h>

@interface UIView (GTM)

- (void)gtm_shake:(int)times witheDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void (^)(void))handler;

@end
