//
//  NewLoginViewController.m
//  OneLoginExample
//
//  Created by noctis on 2019/11/21.
//  Copyright © 2019 geetest. All rights reserved.
//

#import "NewLoginViewController.h"
#import "CustomProtocolViewController.h"
#import "Masonry.h"

@interface NewLoginViewController () <GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *normalLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *popupLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *floatWindowLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *landscapeLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *captchaLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *captchaInSDKLoginButton;

@property (nonatomic, strong) GT3CaptchaManager *gt3CaptchaManager;

@end

@implementation NewLoginViewController

- (void)dealloc {
    NSLog(@"------------- %@ %@ -------------", [self class], NSStringFromSelector(_cmd));
}

#pragma mark - View LifeCycle

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.normalLoginButton.enabled = YES;
    self.popupLoginButton.enabled = YES;
    self.floatWindowLoginButton.enabled = YES;
    self.landscapeLoginButton.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"OneLogin(New)";
    self.normalLoginButton.layer.masksToBounds = YES;
    self.normalLoginButton.layer.cornerRadius = 5;
    self.popupLoginButton.layer.masksToBounds = YES;
    self.popupLoginButton.layer.cornerRadius = 5;
    self.floatWindowLoginButton.layer.masksToBounds = YES;
    self.floatWindowLoginButton.layer.cornerRadius = 5;
    self.landscapeLoginButton.layer.masksToBounds = YES;
    self.landscapeLoginButton.layer.cornerRadius = 5;
    self.captchaLoginButton.layer.masksToBounds = YES;
    self.captchaLoginButton.layer.cornerRadius = 5;
    self.captchaInSDKLoginButton.layer.masksToBounds = YES;
    self.captchaInSDKLoginButton.layer.cornerRadius = 5;
    
    [self initOneLogin];
}

#pragma mark - Init OneLogin

- (void)initOneLogin {
    // 设置日志开关，建议平常调试过程中打开，便于排查问题，上线时可以关掉日志
    [OneLoginPro setLogEnabled:YES];
    // 设置AppId，AppID通过后台注册获得，从极验后台获取该AppID，AppID需与bundleID配套
    [OneLoginPro registerWithAppID:GTOneLoginAppId];
}

#pragma mark - Getter

- (GT3CaptchaManager *)gt3CaptchaManager {
    if (!_gt3CaptchaManager) {
        _gt3CaptchaManager = [[GT3CaptchaManager alloc] initWithAPI1:GTCaptchaAPI1 API2:GTCaptchaAPI2 timeout:10.f];
        _gt3CaptchaManager.viewDelegate = self;
        _gt3CaptchaManager.delegate = self;
    }
    return _gt3CaptchaManager;
}

#pragma mark - Action

- (IBAction)normalLoginAction:(UIButton *)sender {
    // 防抖，避免重复点击
    sender.enabled = NO;
    
    // 若不需要自定义UI，可不设置任何参数，使用SDK默认配置即可
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    // -------------- 自定义UI设置 -----------------
    
#ifdef NeedCustomAuthUI
    
    // --------------状态栏设置 -------------------
    viewModel.statusBarStyle = UIStatusBarStyleLightContent;
    
    // -------------- 授权页面背景图片设置 -------------------
    //    viewModel.backgroundImage = [UIImage imageNamed:@"login_back"];
    //    viewModel.landscapeBackgroundImage = [UIImage imageNamed:@"login_back_landscape"];
    viewModel.backgroundColor = UIColor.lightGrayColor;
    
    // -------------- 导航栏设置 -------------------
    viewModel.naviTitle = [[NSAttributedString alloc] initWithString:@"一键登录"
                                                          attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
                                                                       NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                                       }];  // 导航栏标题
    viewModel.naviBgColor = UIColor.greenColor; // 导航栏背景色
    viewModel.naviBackImage = [UIImage imageNamed:@"back"]; // 导航栏返回按钮
    viewModel.backButtonHidden = NO; // 是否隐藏返回按钮，默认不隐藏
    OLRect backButtonRect = {0, 0, 0, 0, 0, 0, {0, 0}}; // 返回按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.backButtonRect = backButtonRect;
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
#ifndef OLAuthVCAutoLayout
    viewModel.naviRightControl = rightBarButton;    // 导航栏右侧控制视图
#endif
    
    // -------------- logo设置 -------------------
    viewModel.appLogo = [UIImage imageNamed:@"网关取号_logo"];  // 自定义logo图片
    OLRect logoRect = {0, 0, 0, 20, 0, 0, {0, 0}}; // logo偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置，logo大小默认为图片大小
    viewModel.logoRect = logoRect;
    viewModel.logoHidden = NO; // 是否隐藏logo，默认不隐藏
    viewModel.logoCornerRadius = 0; // logo圆角，默认为0
    
    // -------------- 手机号设置 -------------------
    viewModel.phoneNumColor = UIColor.redColor; // 颜色
    viewModel.phoneNumFont = [UIFont boldSystemFontOfSize:25]; // 字体
    OLRect phoneNumRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // 手机号偏移设置
    viewModel.phoneNumRect = phoneNumRect;
    
    // -------------- 切换账号设置 -------------------
    viewModel.switchButtonColor = UIColor.brownColor; // 切换按钮颜色
    viewModel.switchButtonFont = [UIFont systemFontOfSize:15];  // 切换按钮字体
    viewModel.switchButtonText = @"自定义切换按钮文案";  // 切换按钮文案
    viewModel.switchButtonHidden = NO; // 是否隐藏切换按钮，默认不隐藏
    OLRect switchButtonRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // 切换按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.switchButtonRect = switchButtonRect;
    
    // -------------- 授权登录按钮设置 -------------------
    viewModel.authButtonImages = @[
                                   [UIImage imageNamed:@"bg_logo_launch"],
                                   [UIImage imageNamed:@"bg_logo_launch"],
                                   [UIImage imageNamed:@"bg_logo_launch"]
                                   ];   // 授权按钮背景图片
    viewModel.authButtonTitle = [[NSAttributedString alloc] initWithString:@"授权登录"
                                                                attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
                                                                             NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                                             }];  // 登录按钮文案
    OLRect authButtonRect = {0, 0, 0, 0, 0, 0, {300, 40}};  // 授权按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.authButtonRect = authButtonRect;
    viewModel.authButtonCornerRadius = 0; // 授权按钮圆角，默认为0
    viewModel.clickAuthButtonBlock = ^(void) {  // 点击授权页面登录按钮回调
        NSLog(@"clickAuthButtonBlock");
    };
    
    // -------------- slogan设置 -------------------
    viewModel.sloganTextColor = UIColor.cyanColor; // slogan颜色
    viewModel.sloganTextFont = [UIFont systemFontOfSize:14]; // slogan字体
    OLRect sloganRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // slogan偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.sloganRect = sloganRect;
    
    // -------------- 服务条款设置 -------------------
    viewModel.defaultCheckBoxState = YES; // 是否默认选择同意服务条款，默认同意
//    viewModel.checkedImage = [UIImage imageNamed:@""]; // 复选框选中状态图片
//    viewModel.uncheckedImage = [UIImage imageNamed:@""]; // 复选框未选中状态图片
    OLRect checkBoxRect = {0, 0, 0, 0, 0, 0, {12, 12}};
    viewModel.checkBoxRect = checkBoxRect; // 复选框尺寸，默认为12*12
    // 隐私条款文字属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.33;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.paragraphSpacing = 0.0;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.firstLineHeadIndent = 0.0;
    viewModel.privacyTermsAttributes = @{
                                         NSForegroundColorAttributeName : UIColor.orangeColor,
                                         NSParagraphStyleAttributeName : paragraphStyle,
                                         NSFontAttributeName : [UIFont systemFontOfSize:12]
                                         };
    // 额外自定义服务条款，注意index属性，默认的index为0，SDK会根据index对多条服务条款升序排列，假如想设置服务条款顺序为 自定义服务条款1 默认服务条款 自定义服务条款2，则，只需将自定义服务条款1的index设为-1，自定义服务条款2的index设为1即可
    OLPrivacyTermItem *item1 = [[OLPrivacyTermItem alloc] initWithTitle:@"自定义服务条款1"
                                                                linkURL:[NSURL URLWithString:@"https://docs.geetest.com/onelogin/overview/start"]
                                                                  index:0
                                                                  block:^(OLPrivacyTermItem * _Nonnull termItem, UIViewController *controller) {
                                                                       NSLog(@"termItem.termLink: %@, controller: %@", termItem.termLink, controller);
                                                                       // 自定义操作，可进入自定义服务条款页面
        
                                                                        CATransition *animation = [CATransition animation];
                                                                        animation.duration = 0.5;
                                                                        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                        animation.type = kCATransitionPush;
                                                                        animation.subtype = kCATransitionFromRight;
        
                                                                        CustomProtocolViewController *customProtocolController = [CustomProtocolViewController new];
                                                                        [[OneLoginPro currentAuthViewController].view.window.layer addAnimation:animation forKey:nil];
                                                                        customProtocolController.modalPresentationStyle = UIModalPresentationFullScreen;
                                                                        [[OneLoginPro currentAuthViewController] presentViewController:customProtocolController animated:NO completion:nil];
                                                                  }];
    OLPrivacyTermItem *item2 = [[OLPrivacyTermItem alloc] initWithTitle:@"自定义服务条款2"
                                                                linkURL:[NSURL URLWithString:@"https://docs.geetest.com/"]
                                                                  index:0];
    // 加载本地的html
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:URL];
    OLPrivacyTermItem *item3 = [[OLPrivacyTermItem alloc] initWithTitle:@"自定义服务条款3"
                                                             urlRequest:URLRequest
                                                                  index:0
                                                                  block:nil];
    viewModel.additionalPrivacyTerms = @[item1, item2, item3];
    OLRect termsRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // 服务条款偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.termsRect = termsRect;
    viewModel.auxiliaryPrivacyWords = @[@"条款前文案", @"&", @"&", @"条款后的文案"];   // 条款之外的文案，默认可不设置
    
    viewModel.clickCheckboxBlock = ^(BOOL isChecked) {      // 点击隐私条款前勾选框回调
        NSLog(@"clickCheckboxBlock isChecked: %@", isChecked ? @"YES" : @"NO");
    };
    
    viewModel.termsAlignment = NSTextAlignmentCenter;
    
    // -------------- 服务条款H5页面导航栏设置 -------------------
//    viewModel.webNaviTitle = [[NSAttributedString alloc] initWithString:@"服务条款"
//                                                             attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
//                                                                          NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
//                                                                          }];  // 服务条款H5页面导航栏标题
    viewModel.webNaviBgColor = UIColor.purpleColor; // 服务条款导航栏背景色
    viewModel.webNaviHidden = NO;   // 服务条款导航栏是否隐藏
    
    // -------------- 授权页面支持的横竖屏设置 -------------------
    viewModel.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown; // 默认为UIInterfaceOrientationMaskPortrait
    
    // -------------- 自定义UI设置，如，可以在授权页面添加三方登录入口 -------------------
    UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [customBtn setTitle:@"我是自定义UI" forState:UIControlStateNormal];
    customBtn.backgroundColor = [UIColor redColor];
    customBtn.layer.cornerRadius = 2.0;
    [customBtn addTarget:self action:@selector(dismissAuthVC) forControlEvents:UIControlEventTouchUpInside];
    __block CGFloat customAreaWidth = 0;
    __block CGFloat customAreaHeight = 0;
    viewModel.customUIHandler = ^(UIView * _Nonnull customAreaView) {
        [customAreaView addSubview:customBtn];
        customBtn.center = CGPointMake(customAreaView.bounds.size.width/2, customAreaView.bounds.size.height/2 + 150);
        customAreaWidth = customAreaView.bounds.size.width > customAreaView.bounds.size.height ? customAreaView.bounds.size.height : customAreaView.bounds.size.width;
        customAreaHeight = customAreaView.bounds.size.width < customAreaView.bounds.size.height ? customAreaView.bounds.size.height : customAreaView.bounds.size.width;
    };
    
    // -------------- 授权页面自动旋转时的回调，在该回调中调整自定义视图的frame，若授权页面不支持自动旋转，或者没有添加自定义视图，可不用实现该block -------------------
    viewModel.authVCTransitionBlock = ^(CGSize size, id<UIViewControllerTransitionCoordinator>  _Nonnull coordinator, UIView * _Nonnull customAreaView) {
        if (size.width > size.height) { // 横屏
            customBtn.center = CGPointMake(customAreaHeight/2, customAreaWidth/2 - 15);
        } else {                        // 竖屏
            customBtn.center = CGPointMake(customAreaWidth/2, customAreaHeight/2 + 150);
        }
    };
    
    // -------------- 授权页面点击登录按钮之后的loading设置 -------------------
    viewModel.loadingViewBlock = ^(UIView * _Nonnull containerView) {
        if ([OneLogin isProtocolCheckboxChecked]) {
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [containerView addSubview:indicatorView];
            indicatorView.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
            [indicatorView startAnimating];
        }
    };
    
    viewModel.stopLoadingViewBlock = ^(UIView * _Nonnull containerView) {
        for (UIView *subview in containerView.subviews) {
            if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
                [(UIActivityIndicatorView *)subview stopAnimating];
                [subview removeFromSuperview];
                break;
            }
        }
    };
    
    // -------------- 授权页面未勾选服务条款时点击登录按钮的提示 -------------------
    viewModel.notCheckProtocolHint = @"请您先同意服务条款";  // 授权页面未勾选服务条款时点击登录按钮的提示，默认为"请同意服务条款"
    
    // -------------- Autolayout -------------------
#ifdef OLAuthVCAutoLayout
    viewModel.autolayoutBlock = ^(UIView *authView, UIView *authContentView, UIView *authBackgroundImageView, UIView *authNavigationView, UIView *authNavigationContainerView, UIView *authBackButton, UIView *authNavigationTitleView, UIView *authLogoView, UIView *authPhoneView, UIView *authSwitchButton, UIView *authLoginButton, UIView *authSloganView, UIView *authAgreementView, UIView *authCheckbox, UIView *authProtocolView, UIView *authClosePopupButton) {
        // content
        [authContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(authView);
        }];
        
        // background
        [authBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(authContentView);
        }];
        
        // navigation
        [authNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(authContentView);
            make.height.mas_equalTo(64);
        }];
        
        [authNavigationContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(authNavigationView);
        }];
        
        [authBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(authNavigationContainerView).offset(20);
            make.centerY.equalTo(authNavigationContainerView).offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [authNavigationTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(authNavigationContainerView);
            make.centerY.equalTo(authNavigationContainerView).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        
        UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBarButton setTitle:@"完成" forState:UIControlStateNormal];
        [rightBarButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [authNavigationContainerView addSubview:rightBarButton];
        [rightBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(authNavigationContainerView).offset(-10);
            make.centerY.equalTo(authNavigationContainerView).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 40));
        }];
        
        // logo
        [authLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(authContentView);
            make.top.equalTo(authNavigationView.mas_bottom).offset(100);
            make.size.mas_equalTo(CGSizeMake(107, 22));
        }];
        
        // phone
        [authPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(authContentView);
            make.top.equalTo(authLogoView.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        
        // switchbutton
        [authSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(authContentView);
            make.top.equalTo(authPhoneView.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        // loginbutton
        [authLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(authContentView);
            make.top.equalTo(authSwitchButton.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(260, 40));
        }];
        
        // slogan
        [authSloganView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(authContentView);
            make.top.equalTo(authLoginButton.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(260, 20));
        }];
        
        // agreementview
        [authAgreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(authContentView).offset(20);
            make.right.equalTo(authContentView).offset(-20);
            make.top.equalTo(authSloganView.mas_bottom).offset(50);
            make.height.mas_equalTo(80);
        }];
        
        [authCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(authAgreementView).offset(10);
            make.top.equalTo(authAgreementView).offset(10);
        }];
        
        [authProtocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(authCheckbox.mas_right).offset(5);
            make.right.equalTo(authAgreementView).offset(-10);
            make.height.equalTo(authAgreementView);
        }];
        
        // 自定义视图
        UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [customBtn setTitle:@"我是自定义UI" forState:UIControlStateNormal];
        customBtn.backgroundColor = [UIColor lightGrayColor];
        customBtn.layer.cornerRadius = 2.0;
        [customBtn addTarget:self action:@selector(dismissAuthVC) forControlEvents:UIControlEventTouchUpInside];
        [authContentView addSubview:customBtn];
        [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(authContentView).offset(20);
            make.right.equalTo(authContentView).offset(-20);
            make.height.mas_equalTo(40);
            make.top.equalTo(authAgreementView.mas_bottom).offset(30);
        }];
    };
#endif
    
    viewModel.pullAuthVCStyle = OLPullAuthVCStylePush;
    
    // -------------- 弹出授权页面转场动画设置 -------------------
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.5;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromRight;
//    viewModel.modalPresentationAnimation = animation;
//
//    CATransition *dismissAnimation = [CATransition animation];
//    dismissAnimation.duration = 0.5;
//    dismissAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    dismissAnimation.type = kCATransitionPush;
//    dismissAnimation.subtype = kCATransitionFromLeft;
//    viewModel.modalDismissAnimation = dismissAnimation;
#endif
    
    __weak typeof(self) wself = self;
    
    // 在SDK内部预取号未成功时，建议加载进度条
    if (![OneLoginPro isPreGetTokenResultValidate]) {
        [GTProgressHUD showLoadingHUDWithMessage:nil];
    }
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            sender.enabled = YES;
        } else if ([viewLifeCycle isEqualToString:@"viewDidLoad"]) {
            // 授权页面出现时，关掉进度条
            [GTProgressHUD hideAllHUD];
        }
    };
    
    [OneLoginPro requestTokenWithViewController:self viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSLog(@"OneLoginPro requestTokenWithViewController result: %@", result);
        [wself finishRequestingToken:result];
        sender.enabled = YES;
    }];
}

- (IBAction)popupLoginAction:(UIButton *)sender {
    // 防抖，避免重复点击
    sender.enabled = NO;
    
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    viewModel.isPopup = YES;
    viewModel.switchButtonHidden = YES;
    viewModel.canClosePopupFromTapGesture = YES;
    
    viewModel.tapAuthBackgroundBlock = ^{
        NSLog(@"tapAuthBackgroundBlock");
    };
    
    viewModel.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    
    __weak typeof(self) wself = self;
    
    // 在SDK内部预取号未成功时，建议加载进度条
    if (![OneLoginPro isPreGetTokenResultValidate]) {
        [GTProgressHUD showLoadingHUDWithMessage:nil];
    }
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            sender.enabled = YES;
        } else if ([viewLifeCycle isEqualToString:@"viewDidLoad"]) {
            // 授权页面出现时，关掉进度条
            [GTProgressHUD hideAllHUD];
        }
    };
    
    // 弹窗模式，请传 navigationController
    [OneLoginPro requestTokenWithViewController:self.navigationController viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSLog(@"OneLoginPro requestTokenWithViewController result: %@", result);
        [wself finishRequestingToken:result];
        sender.enabled = YES;
    }];
}

- (IBAction)floatWindowLogin:(UIButton *)sender {
    // 防抖，避免重复点击
    sender.enabled = NO;
    
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    viewModel.isPopup = YES;
    viewModel.switchButtonHidden = YES;
    
    // --------------点击弹窗背景收起弹窗 -------------------
    viewModel.canClosePopupFromTapGesture = YES;
    
    // -------------- 弹窗设置 -------------------
    
    // 自定义弹窗动画
    viewModel.popupAnimationStyle = OLAuthPopupAnimationStyleCoverVertical; // 弹窗动画风格，支持CoverVertical、StyleFlipHorizontal、CrossDissolve和自定义模式，默认为CoverVertical
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromLeft;
    viewModel.popupTransitionAnimation = animation; // 只有在popupAnimationStyle为OLAuthPopupAnimationStyleCustom时生效
    
    // 弹窗位置、大小设置，弹窗默认大小为300*340，居于屏幕中间，假如要弹窗居于底部，可做如下设置
    OLRect popupRect = {[self ol_screenHeight] - 340, 0, 0, 0, 0, 0, {[self ol_screenWidth], 340}};  // 弹窗偏移、大小设置
    viewModel.popupRect = popupRect;
    viewModel.popupCornerRadius = 8; // 弹窗圆角，默认为6
    viewModel.popupRectCorners = @[@(UIRectCornerTopLeft), @(UIRectCornerTopRight)];  // 设置部分圆角
//    viewModel.closePopupImage = [UIImage imageNamed:@"back"]; // 关闭按钮
    viewModel.closePopupTopOffset = @(3);  // 关闭按钮距弹窗顶部偏移
    viewModel.closePopupRightOffset = @(-8); // 关闭按钮距弹窗右边偏移
    
    viewModel.tapAuthBackgroundBlock = ^{
        NSLog(@"tapAuthBackgroundBlock");
    };
    
    __weak typeof(self) wself = self;
    
    // 在SDK内部预取号未成功时，建议加载进度条
    if (![OneLoginPro isPreGetTokenResultValidate]) {
        [GTProgressHUD showLoadingHUDWithMessage:nil];
    }
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            sender.enabled = YES;
        } else if ([viewLifeCycle isEqualToString:@"viewDidLoad"]) {
            // 授权页面出现时，关掉进度条
            [GTProgressHUD hideAllHUD];
        }
    };
    
    // 弹窗模式，请传 navigationController
    [OneLoginPro requestTokenWithViewController:self.navigationController viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSLog(@"OneLoginPro requestTokenWithViewController result: %@", result);
        [wself finishRequestingToken:result];
        sender.enabled = YES;
    }];
}

- (IBAction)landscapeLogin:(UIButton *)sender {
    // 防抖，避免重复点击
    sender.enabled = NO;
    
    // 若不需要自定义UI，可不设置任何参数，使用SDK默认配置即可
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    viewModel.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    
    __weak typeof(self) wself = self;
    
    // 在SDK内部预取号未成功时，建议加载进度条
    if (![OneLoginPro isPreGetTokenResultValidate]) {
        [GTProgressHUD showLoadingHUDWithMessage:nil];
    }
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            sender.enabled = YES;
        } else if ([viewLifeCycle isEqualToString:@"viewDidLoad"]) {
            // 授权页面出现时，关掉进度条
            [GTProgressHUD hideAllHUD];
        }
    };
    
    [OneLoginPro requestTokenWithViewController:self.navigationController viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSLog(@"OneLoginPro requestTokenWithViewController result: %@", result);
        [wself finishRequestingToken:result];
        sender.enabled = YES;
    }];
}

/**
 * 一键登录 SDK 提供两种方式接入极验的 [行为验证](https://docs.geetest.com/sensebot/start/) 能力，当且仅当您在接入极验一键登录的同时需要结合行为验证时，您才需要搭建您自己的服务来处理行为验证的 api1 和 api2 请求，若您不需要接入行为验证功能，请忽略该方法
 */
- (IBAction)captchaLoginAction:(UIButton *)sender {
    // 防抖，避免重复点击
    sender.enabled = NO;
    
    // 若不需要自定义UI，可不设置任何参数，使用SDK默认配置即可
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    
    __weak typeof(self) wself = self;
    
    // 在SDK内部预取号未成功时，建议加载进度条
    if (![OneLoginPro isPreGetTokenResultValidate]) {
        [GTProgressHUD showLoadingHUDWithMessage:nil];
    }
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            sender.enabled = YES;
        } else if ([viewLifeCycle isEqualToString:@"viewDidLoad"]) {
            // 授权页面出现时，关掉进度条
            [GTProgressHUD hideAllHUD];
        }
    };
    
    // 结合行为验证
    viewModel.customAuthActionBlock = ^BOOL{
        [wself.gt3CaptchaManager registerCaptcha:nil];
        [wself.gt3CaptchaManager startGTCaptchaWithAnimated:YES];
        return YES;
    };
        
    [OneLoginPro requestTokenWithViewController:self viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSLog(@"OneLoginPro requestTokenWithViewController result: %@", result);
        [wself finishRequestingToken:result];
        sender.enabled = YES;
    }];
}

/**
 * 一键登录 SDK 提供两种方式接入极验的 [行为验证](https://docs.geetest.com/sensebot/start/) 能力，当且仅当您在接入极验一键登录的同时需要结合行为验证时，您才需要搭建您自己的服务来处理行为验证的 api1 和 api2 请求，若您不需要接入行为验证功能，请忽略该方法
 */
- (IBAction)captchaInSDKLoginButton:(UIButton *)sender {
    // 防抖，避免重复点击
    sender.enabled = NO;
    
    // 若不需要自定义UI，可不设置任何参数，使用SDK默认配置即可
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    
    __weak typeof(self) wself = self;
    
    // 在SDK内部预取号未成功时，建议加载进度条
    if (![OneLoginPro isPreGetTokenResultValidate]) {
        [GTProgressHUD showLoadingHUDWithMessage:nil];
    }
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            sender.enabled = YES;
        } else if ([viewLifeCycle isEqualToString:@"viewDidLoad"]) {
            // 授权页面出现时，关掉进度条
            [GTProgressHUD hideAllHUD];
        }
    };
    
    // OneLoginSDK 内部集成行为验证，只需提供 api1、api2，无需其他操作
    viewModel.captchaAPI1 = GTCaptchaAPI1;
    viewModel.captchaAPI2 = GTCaptchaAPI2;
    
    [OneLoginPro requestTokenWithViewController:self viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSLog(@"OneLoginPro requestTokenWithViewController result: %@", result);
        [wself finishRequestingToken:result];
        sender.enabled = YES;
    }];
}

- (void)doneAction:(UIButton *)button {
    [self dismissAuthVC];
}

- (void)dismissAuthVC {
    [OneLoginPro dismissAuthViewController:nil];
}

- (void)finishRequestingToken:(NSDictionary *)result {
    if (result.count > 0 && result[OLStatusKey] && 200 == [result[OLStatusKey] integerValue]) {
        NSString *token = result[OLTokenKey];
        NSString *appID = result[OLAppIDKey];
        NSString *processID = result[OLProcessIDKey];
        NSString *authcode = result[OLAuthcodeKey];
        [self validateToken:token appID:appID processID:processID authcode:authcode];
    } else {
        if (result[OLErrCodeKey] && [result[OLErrCodeKey] isEqual:OLErrorCode_20302]) { // 点击授权页面返回按钮退出授权页面
            
        } else if (result[OLErrCodeKey] && [result[OLErrCodeKey] isEqual:OLErrorCode_20303]) { // 点击授权页面切换账号按钮
            [GTProgressHUD showToastWithMessage:@"切换账号"];
            [OneLoginPro dismissAuthViewController:nil];
        } else {
            [GTProgressHUD showToastWithMessage:@"登录失败"];
            [OneLoginPro dismissAuthViewController:nil];
        }
    }
}

// 使用token获取用户的登录信息
- (void)validateToken:(NSString *)token appID:(NSString *)appID processID:(NSString *)processID authcode:(NSString *)authcode {
    /**
     * 根据用户自己接口构造
     * demo仅做演示
     * 请不要在线上使用该接口 http://onepass.geetest.com/onelogin/result
     */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@onelogin/result", GTOneLoginResultURL]];
    NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(NSURLRequestCachePolicy)0 timeoutInterval:10.0];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:processID forKey:@"process_id"];
    [params setValue:appID forKey:@"id_2_sign"];
    [params setValue:token forKey:@"token"];
    if (authcode) {
        params[@"authcode"] = authcode;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:(NSJSONWritingOptions)0 error:nil];
    
    mRequest.HTTPMethod = @"POST";
    mRequest.HTTPBody = data;
    
    __weak typeof(self) wself = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:mRequest
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         id result = nil;
                                         if (data && !error) {
                                             result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                         }
                                         [wself finishValidatingToken:result error:error];
                                     }] resume];
    
}

- (void)finishValidatingToken:(NSDictionary *)result error:(NSError *)error {
    NSLog(@"validateToken result: %@, error: %@", result, error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [GTProgressHUD hideAllHUD];
        if (result && result[@"status"] && 200 == [result[@"status"] integerValue] && !error) {
            [GTProgressHUD showToastWithMessage:result[@"result"]?[NSString stringWithFormat:@"手机号为：%@", result[@"result"]]:@"取号成功"];
            // 开启重新预取号，以保证下次可以更快的拉起授权页面，此处仅做演示，建议将重新预取号的时机放在用户退出登录时
            [OneLoginPro renewPreGetToken];
        } else {
            [GTProgressHUD showToastWithMessage:result[@"result"]?:@"token验证失败"];
        }
        
        [OneLoginPro dismissAuthViewController:nil];
    });
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
        [OneLoginPro startRequestToken];
    } else {
        // 二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
    }
}

@end
