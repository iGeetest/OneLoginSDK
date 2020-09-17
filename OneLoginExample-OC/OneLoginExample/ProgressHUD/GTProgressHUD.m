//
//  GTProgressHUD.m
//  OneLoginCTDemo
//
//  Created by noctis on 2019/7/18.
//  Copyright © 2019 com.geetest. All rights reserved.
//

#import "GTProgressHUD.h"
#import "MBProgressHUD.h"

#define kGTProgressHUDHideTimeInterval 1.5f

@interface GTProgressHUD()
/*
 当前正在显示的loadingHUD
 */
@property (nonatomic, strong) MBProgressHUD *activeLoadingHUD;

@end

@implementation GTProgressHUD

static GTProgressHUD *_instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}

+ (void)customlizeHUD:(MBProgressHUD *)hud {
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:(CGFloat)0x00/255.f green:(CGFloat)0x0F/255.f blue:(CGFloat)0x1A/255.f alpha:0.9];
    hud.label.numberOfLines = 2;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = UIColor.whiteColor;
    hud.contentColor = UIColor.whiteColor;
}

+ (void)showToastWithMessage:(NSString *)message {
    [self showToastWithMessage:message offset:CGPointMake(0.f, 0.f)];
}

+ (void)showToastAtBottomWithMessage:(NSString *)message {
    [self showToastWithMessage:message offset:CGPointMake(0.f, CGFLOAT_MAX)];
}

+ (void)showToastWithMessage:(NSString *)message offset:(CGPoint)offset {
    if (!message || message.length == 0) {
        return;
    }
    
    [self hideAllHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
    hud.mode = MBProgressHUDModeText;
    [self customlizeHUD:hud];
    hud.userInteractionEnabled = NO;
    hud.label.text = message;
    hud.offset = offset;
    [hud hideAnimated:YES afterDelay:kGTProgressHUDHideTimeInterval];
}

+ (void)showLoadingHUDWithMessage:(NSString * _Nullable)message {
    [self showLoadingHUDWithMessage:message inView:[self keyWindow]];
}

+ (void)showLoadingHUDWithMessage:(NSString * _Nullable)message inView:(UIView * _Nullable)view {
    [self hideAllHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self customlizeHUD:hud];
    hud.userInteractionEnabled = NO;
    [[self sharedInstance] setActiveLoadingHUD:hud];
    hud.label.text = message;
}

+ (void)hideLoadingHUDInView:(UIView * _Nullable)view {
    if ([[self sharedInstance] activeLoadingHUD]) {
        [[[self sharedInstance] activeLoadingHUD] hideAnimated:YES];
        [[self sharedInstance] setActiveLoadingHUD:nil];
    } else {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[MBProgressHUD class]]) {
                MBProgressHUD *hud = (MBProgressHUD *)subview;
                [hud hideAnimated:YES];
            }
        }
    }
}

+ (void)hideAllHUD {
    [self hideLoadingHUDInView:[self keyWindow]];
}

+ (UIWindow *)keyWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows firstObject];
    }
    return window;
}

@end
