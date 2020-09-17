//
//  ViewController.m
//  OneLoginExample
//
//  Created by 刘练 on 2019/3/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "OnePassViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *onepassButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"无感本机认证";
    self.nLoginButton.layer.masksToBounds = YES;
    self.nLoginButton.layer.cornerRadius = 5;
    self.onepassButton.layer.masksToBounds = YES;
    self.onepassButton.layer.cornerRadius = 5;
}

- (IBAction)nLoginAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NewLoginViewController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)onepassAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    OnePassViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OnePassViewController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
