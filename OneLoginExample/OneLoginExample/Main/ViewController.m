//
//  ViewController.m
//  OneLoginExample
//
//  Created by NikoXu on 2019/3/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "NewLoginViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
}

- (IBAction)nLoginAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewLoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NewLoginViewController"];
    if (controller) {
        controller.isNewLogin = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)loginAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if (controller) {
        controller.isNewLogin = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
