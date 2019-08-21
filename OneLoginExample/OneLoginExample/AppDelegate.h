//
//  AppDelegate.h
//  OneLoginExample
//
//  Created by NikoXu on 2019/3/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSTimeInterval preGetTokenSuccessedTime;
@property (nonatomic, assign) NSInteger expireTime;

@end

