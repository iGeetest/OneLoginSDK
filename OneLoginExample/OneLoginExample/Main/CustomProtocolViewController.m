//
//  CustomProtocolViewController.m
//  OneLoginExample
//
//  Created by noctis on 2019/12/5.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "CustomProtocolViewController.h"

@interface CustomProtocolViewController ()

@end

@implementation CustomProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.systemRedColor;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = UIColor.clearColor;
    backButton.frame = CGRectMake(15, 30, 39, 39);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)back {
    CATransition *dismissAnimation = [CATransition animation];
    dismissAnimation.duration = 0.5;
    dismissAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    dismissAnimation.type = kCATransitionPush;
    dismissAnimation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:dismissAnimation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
