//
//  OnePassViewController.m
//  OneLoginExample
//
//  Created by 刘练 on 2020/2/3.
//  Copyright © 2020 geetest. All rights reserved.
//

#import "OnePassViewController.h"
#import <OneLoginSDK/OneLoginSDK.h>
#import "UIView+GTM.h"
#import "GTProgressHUD.h"
#import "ResultViewController.h"

@interface OnePassViewController () <GOPManagerDelegate, UITextFieldDelegate, ResultVCDelegate, GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate>

@property (nonatomic, strong) GOPManager *gopManager;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;

@property (nonatomic, strong) GT3CaptchaManager *gt3CaptchaManager;

@end

@implementation OnePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"本机号码校验";
    
    self.phoneNumberTF.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didViewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didViewTapped:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

// MARK: Getter

- (GOPManager *)gopManager {
    if (!_gopManager) {
        _gopManager = [[GOPManager alloc] initWithCustomID:GTOnePassAppId timeout:10.f];
        _gopManager.delegate = self;
    }
    return _gopManager;
}

- (GT3CaptchaManager *)gt3CaptchaManager {
    if (!_gt3CaptchaManager) {
        _gt3CaptchaManager = [[GT3CaptchaManager alloc] initWithAPI1:GTCaptchaAPI1 API2:GTCaptchaAPI2 timeout:10.f];
        _gt3CaptchaManager.viewDelegate = self;
        _gt3CaptchaManager.delegate = self;
    }
    return _gt3CaptchaManager;
}

// MARK: Action

- (IBAction)nextAction:(id)sender {
    [self startOnePass];
}

// MARK: Integrate GTCaptcha

- (BOOL)integrateGTCaptcha {
    int x = arc4random() % 2;
    return 0 == x;
}

// MARK: OnePass

- (void)startOnePass {
    if (self.integrateGTCaptcha) {
        [self.gt3CaptchaManager registerCaptcha:nil];
        [self.gt3CaptchaManager startGTCaptchaWithAnimated:YES];
    } else {
        [self doOnePass];
    }
}

- (void)doOnePass {
    NSString *phoneNumber = self.phoneNumberTF.text;
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self checkPhoneNumFormat:phoneNumber]) {
        [GTProgressHUD showLoadingHUDWithMessage:nil];
        [self.gopManager verifyPhoneNumber:phoneNumber];
    } else {
        self.phoneNumberTF.text = nil;
        [self.phoneNumberTF gtm_shake:9 witheDelta:2.f speed:0.1 completion:nil];
        [GTProgressHUD showToastWithMessage:@"不合法的手机号"];
    }
}

- (BOOL)checkPhoneNumFormat:(NSString *)num {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,148,150,151,152,157,158,159,172,178,182,183,184,187,188,198
     * 联通：130,131,132,145,146,152,155,156,166,171,175,176,185,186
     * 电信：133,1349,153,173,174,177,180,181,189,199
     */
    
    /**
     * 宽泛的手机号过滤规则
     */
    NSString * MOBILE = @"^1([3-9])\\d{9}$";
    
    /**
     * 虚拟运营商: Virtual Network Operator
     * 不支持
     */
    NSString * VNO = @"^170\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,172,178,182,183,184,187,188
     */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[78]|5[0-27-9]|7[28]|8[2-478]|98)\\d)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,176,185,186
     */
    
    NSString * CU = @"^1(3[0-2]|45|5[256]|7[156]|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,1349,153,173,177,180,181,189
     */
    
    NSString * CT = @"^1((33|53|7[347]|8[019]|99)[0-9]|349)\\d{7}$";
    
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    NSPredicate *regexTestVNO = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VNO];
    
    NSPredicate *regexTestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regexTestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regexTestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regexTestMobile evaluateWithObject:num] == YES &&
        (([regexTestCM evaluateWithObject:num] == YES) ||
        ([regexTestCT evaluateWithObject:num] == YES) ||
        ([regexTestCU evaluateWithObject:num] == YES)) &&
        [regexTestVNO evaluateWithObject:num] == NO) {
        return YES;
    } else {
        return NO;
    }
}

- (void)verifyFailed {
    [GTProgressHUD showToastWithMessage:@"本机号码校验失败"];
}

// MARK: GOPManagerDelegate

- (void)gtOnePass:(GOPManager *)manager didReceiveDataToVerify:(NSDictionary *)data {
    NSMutableDictionary *mdict = [data mutableCopy];
    mdict[@"id_2_sign"] = GTOnePassAppId;
    NSURL *url = [NSURL URLWithString:GTOnePassVerifyURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:mdict options:0 error:nil];
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"verify onepass result: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [GTProgressHUD hideAllHUD];
            if (nil != data) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:nil];
                if (result[@"status"] && [@(200) isEqual:result[@"status"]]) {
                    if (result[@"result"] && [@"0" isEqual:result[@"result"]]) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ResultViewController *vc = [sb instantiateViewControllerWithIdentifier:@"result"];
                        vc.delegate = self;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if (result[@"result"] && [@"1" isEqual:result[@"result"]]) {
                        [GTProgressHUD showToastWithMessage:@"非本机号码"];
                    } else {
                        [self verifyFailed];
                    }
                } else {
                    [self verifyFailed];
                }
            } else {
                [self verifyFailed];
            }
        });
    }];
    [task resume];
}

- (void)gtOnePass:(GOPManager *)manager errorHandler:(GOPError *)error {
    NSLog(@"gtOnePass errorHandler: %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [GTProgressHUD showToastWithMessage:error.localizedDescription ?: @"本机号码校验失败"];
    });
}

// MARK: UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 11) {
        [self startOnePass];
        if ([textField canResignFirstResponder]) {
            [textField resignFirstResponder];
        }
        return YES;
    } else {
        return NO;
    }
}

// MARK: ResultVCDelegate

- (void)resultVCDidReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: GT3CaptchaManagerViewDelegate

- (void)gtCaptchaWillShowGTView:(GT3CaptchaManager *)manager {
    NSLog(@"gtCaptchaWillShowGTView");
}

// MARK: GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    NSLog(@"gtCaptcha errorHandler: %@", error);
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *originURL = originalRequest.URL.absoluteString;
    NSRange tRange = [originURL rangeOfString:@"?t="];
    NSString *newURL = originURL.copy;
    if (NSNotFound != tRange.location) {
        if (newURL.length >= tRange.location + tRange.length + 13) {
            newURL = [newURL stringByReplacingCharactersInRange:NSMakeRange(tRange.location + tRange.length, 13) withString:[NSString stringWithFormat:@"%.0f", 1000 * [[[NSDate alloc] init] timeIntervalSince1970]]];
        }
    } else {
        newURL = [NSString stringWithFormat:@"%@?t=%.0f", originURL, 1000 * [[[NSDate alloc] init] timeIntervalSince1970]];
    }
    
    mRequest.URL = [NSURL URLWithString:newURL];
    NSLog(@"gtCaptcha willSendRequestAPI1 newURL: %@", newURL);
    
    replacedHandler(mRequest);
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        // 处理验证结果
        NSLog(@"\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        [self doOnePass];
    } else {
        // 二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
    }
}

@end
