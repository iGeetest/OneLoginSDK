//
//  ViewController.m
//  OneLoginExample
//
//  Created by NikoXu on 2019/3/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"OneLogin";
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 5;
}

@end
