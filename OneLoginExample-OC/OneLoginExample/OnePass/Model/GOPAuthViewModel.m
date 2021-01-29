//
//  GOPAuthViewModel.m
//  OneLoginSDK
//
//  Created by noctis on 2021/1/13.
//  Copyright © 2021 geetest. All rights reserved.
//

#import "GOPAuthViewModel.h"
#import "GOPUtil.h"

@implementation GOPAuthViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.statusBarStyle = UIStatusBarStyleDefault;
        self.pullAuthVCStyle = GOPPullAuthVCStyleModal;
        if (@available(iOS 12.0, *)) {
            self.userInterfaceStyle = @(UIUserInterfaceStyleUnspecified);
        } else {
            self.userInterfaceStyle = @(-1000);
        }
        self.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
        self.defaultOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }
    return self;
}

- (BOOL)isDarkMode {
    BOOL isDarkMode = NO;
    if (@available(iOS 12.0, *)) {
        if (UIUserInterfaceStyleUnspecified == self.userInterfaceStyle.integerValue) {
            if (@available(iOS 13.0, *)) {
                if (UIUserInterfaceStyleDark == [GOPUtil keyWindow].traitCollection.userInterfaceStyle) {
                    isDarkMode = YES;
                }
            }
        }
        
        if (@available(iOS 13.0, *)) {
            if (UIUserInterfaceStyleDark == self.userInterfaceStyle.integerValue) {
                isDarkMode = YES;
            }
        }
    }
    
    return isDarkMode;
}

@end
