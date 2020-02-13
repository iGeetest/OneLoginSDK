//
//  ViewController.m
//  OneLoginExample
//
//  Created by 刘练 on 2019/3/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "NewLoginViewController.h"
#import "OnePassViewController.h"
#import "无感本机认证-Swift.h"

#define UseSwiftDemo

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *onepassButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"OneLogin";
    self.nLoginButton.layer.masksToBounds = YES;
    self.nLoginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 5;
    self.onepassButton.layer.masksToBounds = YES;
    self.onepassButton.layer.cornerRadius = 5;
}

- (IBAction)nLoginAction:(id)sender {
    // OneLogin 1.9.0版本提供的新的流程，由SDK内部控制预取号流程
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
#ifndef UseSwiftDemo
    NewLoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NewLoginViewController"];
    if (controller) {
        controller.isNewLogin = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
#else
    SwiftNewLoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SwiftNewLoginViewController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
#endif
}

- (IBAction)loginAction:(id)sender {
    // OneLogin 1.9.0及以下版本的原流程，由开发者自行控制预取号时机
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
#ifndef UseSwiftDemo
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if (controller) {
        controller.isNewLogin = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }
#else
    SwiftLoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SwiftLoginViewController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
#endif
}

- (IBAction)onepassAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
#ifndef UseSwiftDemo
    OnePassViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OnePassViewController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
#else
    SwiftOnePassViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SwiftOnePassViewController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
#endif
}

@end
