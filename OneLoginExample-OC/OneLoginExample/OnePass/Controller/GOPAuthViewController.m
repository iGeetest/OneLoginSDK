//
//  GOPAuthViewController.m
//  OneLoginSDK
//
//  Created by noctis on 2021/1/13.
//  Copyright © 2021 geetest. All rights reserved.
//

#import "GOPAuthViewController.h"
#import "GOPUtil.h"
#import "UIScreen+GOP.h"
#import "GOPButton.h"
#import "UIView+GOPAutoLayout.h"
#import <OneLoginSDK/OneLoginSDK.h>
#import "GOPPhoneTableCell.h"
#import "ResultViewController.h"

static NSInteger const GOPContainerViewTag =        3100;
static NSInteger const GOPBackButtonTag =           3101;
static NSInteger const GOPLogoImageViewTag =        3102;
static NSInteger const GOPPhoneViewTag =            3103;
static NSInteger const GOPPhoneTextFieldTag =       3104;
static NSInteger const GOPSwitchButtonTag =         3105;
static NSInteger const GOPLoginButtonTag =          3106;
static NSInteger const GOPPhoneTableViewTag =       3107;
static NSInteger const GOPLoginIVTag =              3108;

static CGFloat const GOPPhoneTableCellHeight =      46.f;

@interface GOPAuthViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, GOPManagerDelegate>

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) GOPButton *backButton;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) GOPButton *switchButton;
@property (nonatomic, strong) GOPButton *loginButton;
@property (nonatomic, strong) UIActivityIndicatorView *loginIV;
@property (nonatomic, strong) UITableView *phoneTableView;

@property (nonatomic, strong) NSLayoutConstraint *logoTopConstraint;
@property (nonatomic, assign) CGFloat logoTopConstraintConstant;
@property (nonatomic, strong) NSLayoutConstraint *phoneTopConstraint;
@property (nonatomic, assign) CGFloat phoneTopConstraintConstant;
@property (nonatomic, strong) NSLayoutConstraint *phoneTableHeightConstraint;

@property (nonatomic, strong) NSMutableArray<NSString *> *phonesFromCache;
@property (nonatomic, strong) NSArray<NSString *> *phonesFromMemory;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, copy) NSString *currentPhoneString;

@property (nonatomic, strong) NSNumber *isVCBasedStatusBarAppearanceNum;
@property (nonatomic, assign) UIStatusBarStyle originStatusBarStyle;

@property (nonatomic, assign) UIUserInterfaceStyle previousUserInterfaceStyle API_AVAILABLE(tvos(10.0)) API_AVAILABLE(ios(12.0)) API_UNAVAILABLE(watchos);

@property (nonatomic, strong) GOPManager *gopManager;

@end

@implementation GOPAuthViewController

- (void)dealloc {
    [self removeNotifications];
}

// MARK: View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setViewLifeCycleBlock:_cmd animated:YES];
    // 配置开启缓存手机号功能(默认开启)
    [GOPManager setCachePhoneEnabled:YES];
    // 获取缓存手机号列表
    [GOPManager getCachedPhonesWithCompletionHandler:^(NSMutableArray<NSString *> * _Nonnull phones) {
        if (phones.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ((!self.phoneTextField.text || 0 == self.phoneTextField.text.length) && phones[0].length > 0) {
                    self.phoneTextField.text = phones[0];
                    [self textFieldEditingChanged:self.phoneTextField];
                }
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewLifeCycleBlock:_cmd animated:animated];
    if (nil != self.isVCBasedStatusBarAppearanceNum && !self.isVCBasedStatusBarAppearanceNum.boolValue) {
        // 防止将View controller-based status bar appearance设置为NO时- (UIStatusBarStyle)preferredStatusBarStyle方法无法生效
        [UIApplication sharedApplication].statusBarStyle = self.authViewModel.statusBarStyle;
        if (@available(iOS 12.0, *)) {
            if (UIStatusBarStyleDefault == self.authViewModel.statusBarStyle && self.authViewModel.userInterfaceStyle.integerValue == UIUserInterfaceStyleUnspecified) {
                if (@available(iOS 13.0, *)) {
                    self.statusBarStyle = [self isDarkMode] ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
                } else {
                    self.statusBarStyle = [self isDarkMode] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
                }
                [UIApplication sharedApplication].statusBarStyle = self.statusBarStyle;
            }
        }
    }
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setViewLifeCycleBlock:_cmd animated:animated];
    if (!self.presentedViewController) {
        // 还原状态栏
        if (nil != self.isVCBasedStatusBarAppearanceNum && !self.isVCBasedStatusBarAppearanceNum.boolValue) {
            // 设置状态栏样式为初始状态栏样式
            [UIApplication sharedApplication].statusBarStyle = self.originStatusBarStyle;
        }
    }
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setViewLifeCycleBlock:_cmd animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self setViewLifeCycleBlock:_cmd animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setViewLifeCycleBlock:_cmd animated:YES];
}

- (void)setViewLifeCycleBlock:(SEL)selector animated:(BOOL)animated {
    if (self.authViewModel.viewLifeCycleBlock) {
        self.authViewModel.viewLifeCycleBlock([NSString stringWithFormat:@"%@", NSStringFromSelector(selector)], animated);
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

// MARK: Setup Views & Constraints

- (void)setupViews {
    // status bar
    self.isVCBasedStatusBarAppearanceNum = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    self.originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    UIStatusBarStyle statusBarStyle = self.authViewModel.statusBarStyle;
    self.statusBarStyle = statusBarStyle;
        
    // container view
    [self.view addSubview:self.containerView];
    
    // back button
    [self.containerView addSubview:self.backButton];
    
    // logo
    [self.containerView addSubview:self.logoImageView];
    
    // phone view
    [self.containerView addSubview:self.phoneView];
    [self.phoneView addSubview:self.phoneTextField];
    self.phoneView.layer.cornerRadius = 21.f;
    self.phoneTextField.delegate = self;
    self.phoneTextField.font = [UIFont systemFontOfSize:24];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.phoneTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    // switch button
    [self.containerView addSubview:self.switchButton];
    [self.switchButton setTitle:@"更换号码" forState:UIControlStateNormal];
    [self.switchButton setTitleColor:[GOPUtil colorFromHexString:@"3973FF"] forState:UIControlStateNormal];
    self.switchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // login button
    [self.containerView addSubview:self.loginButton];
    self.loginButton.backgroundColor = [GOPUtil colorFromHexString:@"3973FF"];
    self.loginButton.layer.cornerRadius = 7.f;
    [self.loginButton setTitle:@"本机号码登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self disableLoginButton];
    
    // login iv
    [self.loginButton addSubview:self.loginIV];
    [self stopLoading];
    
    // phone table view
    [self.containerView addSubview:self.phoneTableView];
    self.phoneTableView.dataSource = self;
    self.phoneTableView.delegate = self;
    self.phoneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.phoneTableView.layer.cornerRadius = 4.f;
    self.phoneTableView.layer.borderWidth = 1.f;
    
    // images and colors
    [self setupImagesAndColors];
    
    // constraints
    [self setupConstraints];
    
    // tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.containerView addGestureRecognizer:tapGesture];
    
    // notifications
    [self addNotifications];
    
    // custom block
    if (self.authViewModel.customBlock) {
        if (self.authViewModel.autolayoutAgain) {
            [self removeAllConstraints];
            [self removeNotifications];
        }
        __weak typeof(self) wself = self;
        self.authViewModel.customBlock(wself, wself.containerView, wself.backButton, wself.logoImageView, wself.phoneView, wself.phoneTextField, wself.switchButton, wself.loginButton, wself.loginIV, wself.phoneTableView);
        // 未重新布局情况下，在设置了控件属性后，需要重新设置约束
        if (!self.authViewModel.autolayoutAgain) {
            [self setupConstraints];
        }
    }
}

- (void)setupImagesAndColors {
    [self.backButton setImage:[self backImage] forState:UIControlStateNormal];
    self.logoImageView.image = [self logoImage];
    self.view.backgroundColor = [self backgroundColor];
    self.phoneView.backgroundColor = [self phoneBackgroundColor];
    self.phoneTextField.textColor = [self phoneTextColor];
    self.phoneTextField.tintColor = [self phoneEditFieldTintColor];
    self.phoneTableView.backgroundColor = [self phoneTableBackgroundColor];
    self.phoneTableView.layer.borderColor = [self phoneTableBorderColor].CGColor;
}

- (void)setupConstraints {
    if ([self needUpdateLandscapeConstraints]) {
        [self setupLandscapeConstraints];
    } else {
        [self setupPortraitConstraints];
    }
}

- (void)setupPortraitConstraints {
    [self removeAllConstraints];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat screenHeight = MAX(size.width, size.height);
    CGFloat scale = screenHeight/667.0;
    
    UIEdgeInsets safeAreaInsets = [UIScreen gop_safeAreaInsets:NO];
    
    // container view
    [self.view addConstraints:[self.containerView gopConstraintsAssignLeft]];
    [self.view addConstraints:[self.containerView gopConstraintsAssignTop]];
    [self.view addConstraints:[self.containerView gopConstraintsAssignRight]];
    [self.view addConstraints:[self.containerView gopConstraintsAssignBottom]];
    
    // back button
    [self.containerView addConstraints:[self.backButton gopConstraintsLeftInContainer:8.f]];
    [self.containerView addConstraints:[self.backButton gopConstraintsTopInContainer:safeAreaInsets.top + 15.f]];
    UIImage *backImage = self.backButton.imageView.image;
    CGSize backSize = CGSizeEqualToSize(backImage.size, CGSizeZero) ? CGSizeMake(20.f, 20.f) : backImage.size;
    [self.containerView addConstraints:[self.backButton gopConstraintsSize:backSize]];
    
    // logo
    self.logoTopConstraint = [self.logoImageView gopConstraintsTopInContainer:safeAreaInsets.top + 100.f * scale][0];
    self.logoTopConstraintConstant = self.logoTopConstraint.constant;
    [self.containerView addConstraint:self.logoTopConstraint];
    [self.containerView addConstraint:[self.logoImageView gopConstraintCenterXEqualToView:self.containerView]];
    UIImage *logoImage = self.logoImageView.image;
    CGSize logoSize = CGSizeEqualToSize(logoImage.size, CGSizeZero) ? CGSizeMake(80.f, 80.f) : logoImage.size;
    [self.containerView addConstraints:[self.logoImageView gopConstraintsSize:logoSize]];
    self.logoImageView.hidden = NO;
    
    // phone view
    self.phoneTopConstraint = [self.phoneView gopConstraintsTopInContainer:safeAreaInsets.top + 220.f * scale][0];
    self.phoneTopConstraintConstant = self.phoneTopConstraint.constant;
    [self.containerView addConstraint:self.phoneTopConstraint];
    [self.containerView addConstraint:[self.phoneView gopConstraintCenterXEqualToView:self.containerView]];
    [self.containerView addConstraint:[self.phoneView gopConstraintWidth:220.f]];
    [self.containerView addConstraint:[self.phoneView gopConstraintHeight:42.f]];
    
    [self.phoneView addConstraints:[self.phoneTextField gopConstraintsLeftInContainer:35.f]];
    [self.phoneView addConstraints:[self.phoneTextField gopConstraintsRightInContainer:-35.f]];
    [self.phoneView addConstraints:[self.phoneTextField gopConstraintsTopInContainer:5.f]];
    [self.phoneView addConstraint:[self.phoneTextField gopConstraintHeight:42.f - 2 * 5.f]];
    
    // switch button
    [self.containerView addConstraint:[self.switchButton gopConstraintCenterXEqualToView:self.containerView]];
    [self.containerView addConstraints:[self.switchButton gopConstraintsTop:10.f fromView:self.phoneView]];
    [self.containerView addConstraints:[self.switchButton gopConstraintsSize:CGSizeMake(100.f, 25.f)]];
    
    // login button
    [self.containerView addConstraint:[self.loginButton gopConstraintCenterXEqualToView:self.containerView]];
    [self.containerView addConstraints:[self.loginButton gopConstraintsTop:40.f fromView:self.switchButton]];
    [self.containerView addConstraints:[self.loginButton gopConstraintsLeftInContainer:26.f]];
    [self.containerView addConstraint:[self.loginButton gopConstraintHeight:45.f]];
    
    [self.view layoutIfNeeded];
    
    // login iv
    [self.loginButton addConstraint:[self.loginIV gopConstraintCenterYEqualToView:self.loginButton]];
    CGFloat screenWidth = MIN(size.width, size.height);
    CGFloat loginButtonWidth = screenWidth - 2 * 26.f;
    CGFloat loginIVRightMargin = loginButtonWidth/4.0 - 10.f;
    [self.loginButton addConstraints:[self.loginIV gopConstraintsRight:-loginIVRightMargin fromView:self.loginButton]];
    
    // phone table view
    [self.containerView addConstraints:[self.phoneTableView gopConstraintsTop:5.f fromView:self.phoneView]];
    [self.containerView addConstraint:[self.phoneTableView gopConstraintWidthEqualToView:self.phoneView]];
    [self.containerView addConstraint:[self.phoneTableView gopConstraintCenterXEqualToView:self.phoneView]];
    self.phoneTableHeightConstraint = [self.phoneTableView gopConstraintHeight:0.f];
    [self.containerView addConstraint:self.phoneTableHeightConstraint];
    
    [self.view layoutIfNeeded];
}

- (void)setupLandscapeConstraints {
    [self removeAllConstraints];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = MIN(size.width, size.height);
    CGFloat scale = screenWidth/375.0;
    
    // container view
    [self.view addConstraints:[self.containerView gopConstraintsAssignLeft]];
    [self.view addConstraints:[self.containerView gopConstraintsAssignTop]];
    [self.view addConstraints:[self.containerView gopConstraintsAssignRight]];
    [self.view addConstraints:[self.containerView gopConstraintsAssignBottom]];
    
    // back button
    [self.containerView addConstraints:[self.backButton gopConstraintsLeftInContainer:21.f]];
    [self.containerView addConstraints:[self.backButton gopConstraintsTopInContainer:9.f]];
    UIImage *backImage = self.backButton.imageView.image;
    CGSize backSize = CGSizeEqualToSize(backImage.size, CGSizeZero) ? CGSizeMake(20.f, 20.f) : backImage.size;
    [self.containerView addConstraints:[self.backButton gopConstraintsSize:backSize]];
    
    // logo
    self.logoTopConstraint = [self.logoImageView gopConstraintsTopInContainer:100.f][0];
    self.logoTopConstraintConstant = self.logoTopConstraint.constant;
    [self.containerView addConstraint:self.logoTopConstraint];
    [self.containerView addConstraint:[self.logoImageView gopConstraintCenterXEqualToView:self.containerView]];
    UIImage *logoImage = self.logoImageView.image;
    CGSize logoSize = CGSizeEqualToSize(logoImage.size, CGSizeZero) ? CGSizeMake(80.f, 80.f) : logoImage.size;
    [self.containerView addConstraints:[self.logoImageView gopConstraintsSize:logoSize]];
    self.logoImageView.hidden = YES;

    // phone view
    self.phoneTopConstraint = [self.phoneView gopConstraintsTopInContainer:65.f * scale][0];
    self.phoneTopConstraintConstant = self.phoneTopConstraint.constant;
    [self.containerView addConstraint:self.phoneTopConstraint];
    [self.containerView addConstraint:[self.phoneView gopConstraintCenterXEqualToView:self.containerView]];
    [self.containerView addConstraint:[self.phoneView gopConstraintWidth:220.f]];
    [self.containerView addConstraint:[self.phoneView gopConstraintHeight:42.f]];
    
    [self.phoneView addConstraints:[self.phoneTextField gopConstraintsLeftInContainer:35.f]];
    [self.phoneView addConstraints:[self.phoneTextField gopConstraintsRightInContainer:-35.f]];
    [self.phoneView addConstraints:[self.phoneTextField gopConstraintsTopInContainer:5.f]];
    [self.phoneView addConstraint:[self.phoneTextField gopConstraintHeight:42.f - 2 * 5.f]];
    
    // switch button
    [self.containerView addConstraint:[self.switchButton gopConstraintCenterXEqualToView:self.containerView]];
    [self.containerView addConstraints:[self.switchButton gopConstraintsTop:10.f fromView:self.phoneView]];
    [self.containerView addConstraints:[self.switchButton gopConstraintsSize:CGSizeMake(100.f, 25.f)]];
    
    // login button
    [self.containerView addConstraint:[self.loginButton gopConstraintCenterXEqualToView:self.containerView]];
    [self.containerView addConstraints:[self.loginButton gopConstraintsTop:40.f fromView:self.switchButton]];
    [self.containerView addConstraints:[self.loginButton gopConstraintsSize:CGSizeMake(323.f, 45.f)]];
    
    [self.view layoutIfNeeded];
    
    // login iv
    [self.loginButton addConstraint:[self.loginIV gopConstraintCenterYEqualToView:self.loginButton]];
    CGFloat loginButtonWidth = self.loginButton.bounds.size.width;
    CGFloat loginIVRightMargin = loginButtonWidth/4.0 - 10.f;
    [self.loginButton addConstraints:[self.loginIV gopConstraintsRight:-loginIVRightMargin fromView:self.loginButton]];
    
    // phone table view
    [self.containerView addConstraints:[self.phoneTableView gopConstraintsTop:5.f fromView:self.phoneView]];
    [self.containerView addConstraint:[self.phoneTableView gopConstraintWidthEqualToView:self.phoneView]];
    [self.containerView addConstraint:[self.phoneTableView gopConstraintCenterXEqualToView:self.phoneView]];
    self.phoneTableHeightConstraint = [self.phoneTableView gopConstraintHeight:0.f];
    [self.containerView addConstraint:self.phoneTableHeightConstraint];
    
    [self.view layoutIfNeeded];
}

- (void)removeAllConstraints {
    for (UIView *subview in self.view.subviews) {
        [self removeConstraints:subview];
        if (GOPPhoneViewTag == subview.tag ||
            GOPLoginButtonTag == subview.tag) {
            for (UIView *subPhoneView in subview.subviews) {
                [self removeConstraints:subPhoneView];
            }
        }
    }
}

- (void)removeConstraints:(UIView *)view {
    if ([view isKindOfClass:[UIView class]]) {
        [view removeConstraints:view.constraints];
        for (NSLayoutConstraint *constraint in view.superview.constraints) {
            if ([constraint.firstItem isEqual:view]) {
                [view.superview removeConstraint:constraint];
            }
        }
    }
}

// MARK: UITraitCollection

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (@available(iOS 12.0, *)) {
        if (previousTraitCollection.userInterfaceStyle != self.previousUserInterfaceStyle) {
            [self updateUserInterfaceStyle];
        }
        self.previousUserInterfaceStyle = previousTraitCollection.userInterfaceStyle;
    }
}

- (void)updateUserInterfaceStyle {
    if (@available(iOS 12.0, *)) {
        if (!self.authViewModel.customBlock && self.authViewModel.userInterfaceStyle.integerValue == UIUserInterfaceStyleUnspecified) {
            [self setupImagesAndColors];
            [self reloadPhoneTableView];
        }
    }
}

// MARK: Loading

- (void)startLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loginIV.hidden = NO;
        [self.loginIV startAnimating];
    });
}

- (void)stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loginIV.hidden = YES;
        [self.loginIV stopAnimating];
    });
}

// MARK: Actions

- (void)backAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchAction:(UIButton *)button {
    self.phoneTextField.text = nil;
    [self.phoneTextField becomeFirstResponder];
    self.currentPhoneString = nil;
    [self queryPhones];
}

- (void)loginAction:(UIButton *)button {
    if (self.phoneTextField.text.length > 0) {
        [self.view endEditing:YES];
        [self hidePhoneTableView];
        [self startOnePass];
        [self startLoading];
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self.phonesFromCache removeAllObjects];
        self.phonesFromMemory = nil;
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

// MARK: OnePass

- (GOPManager *)gopManager {
    if (!_gopManager) {
        _gopManager = [[GOPManager alloc] initWithCustomID:GTOnePassAppId timeout:5.f];
        _gopManager.delegate = self;
    }
    return _gopManager;
}

- (void)startOnePass {
    NSString *phoneNumber = self.phoneTextField.text;
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.gopManager verifyPhoneNumber:phoneNumber];
}

- (void)verifyFailed {
    [GTProgressHUD showToastWithMessage:@"本机号码校验失败"];
}

// MARK: GOPManagerDelegate

- (void)gtOnePass:(GOPManager *)manager didReceiveDataToVerify:(NSDictionary *)data {
    NSLog(@"gt onepass received data: %@", data);
    [self stopLoading];
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
            [self enableLoginButton];
        });
    }];
    [task resume];
}

- (void)gtOnePass:(GOPManager *)manager errorHandler:(GOPError *)error {
    NSLog(@"gt onepass error: %@", error);
    [self stopLoading];
    [self enableLoginButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [GTProgressHUD showToastWithMessage:error.localizedDescription ?: @"本机号码校验失败"];
    });
}

// MARK: UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"GOPButton"] ||
        [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ||
        [NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return NO;
    }
    return  YES;
}

// MARK: Notifications

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    self.logoTopConstraint.constant = self.logoTopConstraintConstant - 30.f;
    self.phoneTopConstraint.constant = self.phoneTopConstraintConstant - 30.f;
    [self.view updateConstraints];
    [UIView animateWithDuration:[self animationDurationWithNotification:noti] animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    self.logoTopConstraint.constant = self.logoTopConstraintConstant;
    self.phoneTopConstraint.constant = self.phoneTopConstraintConstant;
    [self.view updateConstraints];
    [UIView animateWithDuration:[self animationDurationWithNotification:noti] animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (CGFloat)animationDurationWithNotification:(NSNotification *)noti {
    CGFloat duration = 0.3;
    if (nil != [noti userInfo] && nil != [noti userInfo][UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[noti userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
        duration = duration > 0 ? duration : 0.3;
    }
    return duration;
}

// MARK: Phone Table

- (void)reloadPhoneTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.phoneTableView reloadData];
        if (self.phonesFromMemory.count > 0) {
            [self showPhoneTableView];
        } else {
            [self hidePhoneTableView];
        }
    });
}

- (void)showPhoneTableView {
    if (self.authViewModel.customPhoneTable) {
        return;
    }
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    self.phoneTableHeightConstraint.constant = self.phonesFromMemory.count > 1 ? 2 * GOPPhoneTableCellHeight : GOPPhoneTableCellHeight;
    dispatch_semaphore_signal(self.semaphore);
    [UIView animateWithDuration:.3 animations:^{
        self.phoneTableView.hidden = NO;
        [self.view layoutIfNeeded];
    }];
}

- (void)hidePhoneTableView {
    if (self.authViewModel.customPhoneTable) {
        return;
    }
    
    if (!self.phoneTableView.hidden) {
        self.phoneTableHeightConstraint.constant = 0;
        [UIView animateWithDuration:.3 animations:^{
            self.phoneTableView.hidden = YES;
            [self.view layoutIfNeeded];
        }];
    }
}

// MARK: Login Button

- (void)enableLoginButton {
    self.loginButton.enabled = YES;
}

- (void)disableLoginButton {
    self.loginButton.enabled = NO;
}

// MARK: UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"GOPPhoneTableCell";
    GOPPhoneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[GOPPhoneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.phoneLabel.textColor = [self phoneLabelColor];
    cell.contentView.backgroundColor = [self phoneCellBackgroundColor];
    cell.backgroundColor = [self phoneCellBackgroundColor];
    if (self.authViewModel.phoneTableCellBackgroundColor) {
        cell.contentView.backgroundColor = self.authViewModel.phoneTableCellBackgroundColor;
        cell.backgroundColor = self.authViewModel.phoneTableCellBackgroundColor;
    }
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    cell.phoneLabel.text = self.phonesFromMemory[indexPath.row];
    if (self.authViewModel.phoneTableCellTextColor) {
        cell.phoneLabel.textColor = self.authViewModel.phoneTableCellTextColor;
    }
    if (self.authViewModel.phoneTableCellTextFont) {
        cell.phoneLabel.font = self.authViewModel.phoneTableCellTextFont;
    }
    dispatch_semaphore_signal(self.semaphore);
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSInteger count = self.phonesFromMemory.count;
    dispatch_semaphore_signal(self.semaphore);
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (self.phonesFromMemory.count > indexPath.row) {
        self.phoneTextField.text = self.phonesFromMemory[indexPath.row];
        [self textFieldEditingChanged:self.phoneTextField];
        [self hidePhoneTableView];
    }
    dispatch_semaphore_signal(self.semaphore);
}

// MARK: UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self textFieldEditingChanged:textField];
    self.currentPhoneString = [textField.text copy];
    if (self.currentPhoneString.length < 11) {
        [self queryPhones];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    if ([self isValidPhone:textField.text]) {
        [self enableLoginButton];
    } else {
        [self disableLoginButton];
    }
    
    self.currentPhoneString = [textField.text copy];
    if (self.currentPhoneString.length >= 11) {
        [self hidePhoneTableView];
    } else {
        [self queryPhones];
    }
}

- (BOOL)isValidPhone:(NSString *)phone {
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:phone];
}

// MARK: Query Phones

- (void)queryPhones {
    dispatch_async(self.serialQueue, ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        NSMutableArray *phones = self.phonesFromCache;
        dispatch_semaphore_signal(self.semaphore);
        if (phones.count > 0) {
            [self filterPhones];
        } else {
            [GOPManager getCachedPhonesWithCompletionHandler:^(NSMutableArray<NSString *> * _Nonnull phones) {
                if (phones.count > 0) {
                    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                    [self.phonesFromCache addObjectsFromArray:phones];
                    dispatch_semaphore_signal(self.semaphore);
                    [self filterPhones];
                }
            }];
        }
    });
}

- (void)filterPhones {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (nil == self.currentPhoneString || 0 == self.currentPhoneString.length) {
        self.phonesFromMemory = [self.phonesFromCache copy];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", self.currentPhoneString.copy];
        self.phonesFromMemory = [self.phonesFromCache filteredArrayUsingPredicate:predicate];
    }
    dispatch_semaphore_signal(self.semaphore);
    [self reloadPhoneTableView];
}

// MARK: Rotate

- (BOOL)needUpdateLandscapeConstraints {
    if ([self supportOnlyLandscapeOrientation]) {
        return YES;
    }
    
    if ([self supportOnlyPortraitOrientation]) {
        return NO;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationPortrait == orientation ||
        UIInterfaceOrientationPortraitUpsideDown == orientation) {
        return NO;
    }
    
    return (UIInterfaceOrientationLandscapeLeft == self.authViewModel.defaultOrientation ||
            UIInterfaceOrientationLandscapeRight == self.authViewModel.defaultOrientation);
}

- (BOOL)supportOnlyPortraitOrientation {
    return (UIInterfaceOrientationMaskPortrait == self.authViewModel.supportedInterfaceOrientations ||
            UIInterfaceOrientationMaskPortraitUpsideDown == self.authViewModel.supportedInterfaceOrientations);
}

- (BOOL)supportOnlyLandscapeOrientation {
    return (UIInterfaceOrientationMaskLandscapeLeft == self.authViewModel.supportedInterfaceOrientations ||
            UIInterfaceOrientationMaskLandscapeRight == self.authViewModel.supportedInterfaceOrientations ||
            UIInterfaceOrientationMaskLandscape == self.authViewModel.supportedInterfaceOrientations);
}

- (BOOL)supportOnlyOneOrientation {
    if (UIInterfaceOrientationMaskPortrait == self.authViewModel.supportedInterfaceOrientations ||
        UIInterfaceOrientationMaskLandscapeLeft == self.authViewModel.supportedInterfaceOrientations ||
        UIInterfaceOrientationMaskLandscapeRight == self.authViewModel.supportedInterfaceOrientations ||
        UIInterfaceOrientationMaskPortraitUpsideDown == self.authViewModel.supportedInterfaceOrientations) {
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldAutorotate {
    return ![self supportOnlyOneOrientation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.authViewModel.supportedInterfaceOrientations;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (size.width > size.height) { // 横屏
        [self setupLandscapeConstraints];
    } else {                        // 竖屏
        [self setupPortraitConstraints];
    }
}

- (void)forceOrientationPortrait {
    if ([self needForceOrientationPortrait]) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

/**
 * @abstract 判断退出页面时是否需要进行强制竖屏，不需要进行强制竖屏的情况如下：
 * 1、当前为竖屏
 * 2、进入到此页面的上一个页面为横屏
 *
 * @return YES 需要强制竖屏, NO 不需要强制竖屏
 */
- (BOOL)needForceOrientationPortrait {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationPortrait == orientation ||
        UIInterfaceOrientationPortraitUpsideDown == orientation ||
        UIInterfaceOrientationLandscapeLeft == self.authViewModel.defaultOrientation ||
        UIInterfaceOrientationLandscapeRight == self.authViewModel.defaultOrientation) {
        return NO;
    }
    
    return YES;
}

// MARK: Getter

- (BOOL)isDarkMode {
    BOOL isDarkMode = NO;
    if (@available(iOS 12.0, *)) {
        if (UIUserInterfaceStyleUnspecified == self.authViewModel.userInterfaceStyle.integerValue) {
            if (@available(iOS 13.0, *)) {
                if (UIUserInterfaceStyleDark == [OLKeyWindowUtil keyWindow].traitCollection.userInterfaceStyle) {
                    isDarkMode = YES;
                }
            }
        }
        
        if (@available(iOS 13.0, *)) {
            if (UIUserInterfaceStyleDark == self.authViewModel.userInterfaceStyle.integerValue) {
                isDarkMode = YES;
            }
        }
    }
    
    return isDarkMode;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.tag = GOPContainerViewTag;
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (GOPButton *)backButton {
    if (!_backButton) {
        _backButton = [GOPButton buttonWithType:UIButtonTypeCustom];
        _backButton.tag = GOPBackButtonTag;
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.tag = GOPLogoImageViewTag;
    }
    return _logoImageView;
}

- (UIView *)phoneView {
    if (!_phoneView) {
        _phoneView = [UIView new];
        _phoneView.tag = GOPPhoneViewTag;
    }
    return _phoneView;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [UITextField new];
        _phoneTextField.tag = GOPPhoneTextFieldTag;
    }
    return _phoneTextField;
}

- (GOPButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [GOPButton buttonWithType:UIButtonTypeCustom];
        _switchButton.tag = GOPSwitchButtonTag;
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (GOPButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [GOPButton buttonWithType:UIButtonTypeCustom];
        _loginButton.tag = GOPLoginButtonTag;
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIActivityIndicatorView *)loginIV {
    if (!_loginIV) {
        _loginIV = [[UIActivityIndicatorView alloc] init];
        _loginIV.tag = GOPLoginIVTag;
        _loginIV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _loginIV;
}

- (UITableView *)phoneTableView {
    if (!_phoneTableView) {
        _phoneTableView = [UITableView new];
        _phoneTableView.tag = GOPPhoneTableViewTag;
    }
    return _phoneTableView;
}

- (NSMutableArray<NSString *> *)phonesFromCache {
    if (!_phonesFromCache) {
        _phonesFromCache = [NSMutableArray array];
    }
    return _phonesFromCache;
}

- (NSArray<NSString *> *)phonesFromMemory {
    if (!_phonesFromMemory) {
        _phonesFromMemory = [NSArray array];
    }
    return _phonesFromMemory;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (dispatch_queue_t)serialQueue {
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("com.geetest.onepass.dbqueue", DISPATCH_QUEUE_SERIAL);
    }
    return _serialQueue;
}

- (UIColor *)backgroundColor {
    return self.authViewModel.backgroundColor ?: ([self isDarkMode] ? [GOPUtil colorFromHexString:@"2E2E30"] : UIColor.whiteColor);
}

- (UIImage *)backImage {
    return [UIImage imageNamed:[self isDarkMode] ? @"back" : @"back_gray"];
}

- (UIImage *)logoImage {
    return [UIImage imageNamed:[self isDarkMode] ? @"onepass_darkmode" : @"onepass"];
}

- (UIColor *)phoneBackgroundColor {
    return [GOPUtil colorFromHexString:[self isDarkMode] ? @"3F4144" : @"F1F4FC"];
}

- (UIColor *)phoneTextColor {
    return [GOPUtil colorFromHexString:[self isDarkMode] ? @"FFFFFF" : @"3B3E46"];
}

- (UIColor *)phoneEditFieldTintColor {
    return [GOPUtil colorFromHexString:[self isDarkMode] ? @"FFFFFF" : @"222222"];
}

- (UIColor *)phoneTableBackgroundColor {
    return [self isDarkMode] ? [GOPUtil colorFromHexString:@"3F4144"] : UIColor.whiteColor;
}

- (UIColor *)phoneTableBorderColor {
    return [GOPUtil colorFromHexString:[self isDarkMode] ? @"54575B" : @"DFE5EF"];
}

- (UIColor *)phoneLabelColor {
    return [self isDarkMode] ? UIColor.whiteColor : [GOPUtil colorFromHexString:@"3B3E46"];
}

- (UIColor *)phoneCellBackgroundColor {
    return [self isDarkMode] ? [GOPUtil colorFromHexString:@"3F4144"] : UIColor.whiteColor;
}

@end
