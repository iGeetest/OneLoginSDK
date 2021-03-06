//
//  BaseViewController.m
//  OneLoginExample
//
//  Created by noctis on 2019/11/21.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (CGFloat)ol_screenWidth {
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (CGFloat)ol_screenHeight {
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (BOOL)isAuthViewControllerNotPresented:(NSDictionary *)result {
    if (result && result[@"errorCode"]) {
        NSString *errorCode = [NSString stringWithFormat:@"%@", result[@"errorCode"]];
        if ([errorCode isEqual:@"-20205"] ||
            [errorCode isEqual:@"-20206"] ||
            [errorCode isEqual:@"-20103"]) {
            return YES;
        }
        
        NSDictionary *metadata = result[@"metadata"];
        if (metadata && [metadata isKindOfClass:[NSDictionary class]] && metadata.count > 0) {
            NSString *resultCode = [NSString stringWithFormat:@"%@", metadata[@"resultCode"]];
            // 200022 无网络, 200023 请求超时, 200027 未开启数据网络
            if ([resultCode isEqual:@"200022"] ||
                [resultCode isEqual:@"200023"] ||
                [resultCode isEqual:@"200027"]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isIPhoneXScreen {
    if (@available(iOS 11.0, *)) {
        CGFloat safeAreaInsetBottom = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        return safeAreaInsetBottom > 0.0;
    }
    
    return NO;
}

@end
