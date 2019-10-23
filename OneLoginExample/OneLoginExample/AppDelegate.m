//
//  AppDelegate.m
//  OneLoginExample
//
//  Created by NikoXu on 2019/3/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "AppDelegate.h"
#import <OneLoginSDK/OneLoginSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 建议APP启动时就进行预取号，若是用户首次安装APP，网络未开启，在此处肯定无法预取号成功，故，建议在需要进入授权页面的页面的viewDidLoad中也进行预取号
    // 若您修改了bundleId，此处请将appId修改为与bundleId相对应的值，appId一定要与bundleId一一对应
    [OneLogin registerWithAppID:@"53cd718a9fd11e4dea99a22f138dc509"];
    // 预取号方法会先调用系统API检测当前手机流量对应的运营商，而在程序刚刚启动时，该检测方法往往会检测不到正确的运营商
    // 所以若didFinishLaunchingWithOptions方法中有较多其他初始化操作，可以将preGetTokenWithCompletion方法放到最后面执行
    // 若didFinishLaunchingWithOptions方法中操作很简单，可以稍微延迟一点再去执行preGetTokenWithCompletion方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            NSLog(@"didFinishLaunchingWithOptions pre get token result: %@", sender);
        }];
    });
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
