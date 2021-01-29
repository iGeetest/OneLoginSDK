//
//  GOPAuthViewModel.h
//  OneLoginSDK
//
//  Created by noctis on 2021/1/13.
//  Copyright © 2021 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 授权页面视图生命周期回调
 * @param viewLifeCycle 值为viewDidLoad、viewWillAppear、viewWillDisappear、viewDidAppear、viewDidDisappear
 * @param animated 是否有动画
 */
typedef void(^GOPAuthViewLifeCycleBlock)(NSString *viewLifeCycle, BOOL animated);

/**
 * @abstract 授权页面自定义回调，可在该回调中，对控件通过 masonry 或者其他方式进行自动布局，若需要自定义视图，请直接在该回调中添加，实现该回调后，授权页面所有视图的约束都会被删除，您需要重新设置所有视图的约束，也可以在该回调中自定义所有控件属性
 *
 * containerView 为 backButton、logoImageView、phoneView、switchButton、loginButton、phoneTableView 的父视图
 * phoneView 为 phoneTextField 的父视图
 * loginButton 为 loginIV 的父视图
 */
typedef void(^GOPCustomAuthVCBlock)(UIViewController *viewController, UIView *containerView, UIButton *backButton, UIImageView *logoImageView, UIView *phoneView, UITextField *phoneTextField, UIButton *switchButton, UIButton *loginButton, UIActivityIndicatorView *loginIV, UITableView *phoneTableView);

/**
 * @abstract 进入授权页面的方式，默认为 modal 方式，即 present 到授权页面
 *
 * @discussion push 模式时，进入授权页面时，会隐藏导航栏，退出授权页面时，会显示导航栏，如果您进入授权页面的当前页面导航栏为隐藏状态，在授权页面消失时，请注意将导航栏隐藏
 */
typedef NS_ENUM(NSInteger, GOPPullAuthVCStyle) {
    GOPPullAuthVCStyleModal,
    GOPPullAuthVCStylePush
};

@interface GOPAuthViewModel : NSObject

/**
 进入本页面之前的横竖屏方向
 */
@property (nonatomic, assign) UIInterfaceOrientation defaultOrientation;

// MARK: StatusBar

/**
 状态栏样式。 默认 `UIStatusBarStyleDefault`。
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

// MARK: Background Color

/**
 授权页面背景色
 */
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

// MARK: Autolayout

/**
 重新进行 autolayout，默认为 NO，设置为 YES 时，会删除授权页面所有控件的约束，需要对所有控件进行重新设置约束
 */
@property (nonatomic, assign) BOOL autolayoutAgain;

// MARK: Custom Block

@property (nonatomic, copy, nullable) GOPCustomAuthVCBlock customBlock;

// MARK: View Life Cycle Block

@property (nonatomic, copy, nullable) GOPAuthViewLifeCycleBlock viewLifeCycleBlock;

// MARK: UIUserInterfaceStyle

/**
 * @abstract 授权页面 UIUserInterfaceStyle，iOS 12 及以上系统，默认为 UIUserInterfaceStyleLight
 *
 * UIUserInterfaceStyle
 * UIUserInterfaceStyleUnspecified - 不指定样式，跟随系统设置进行展示
 * UIUserInterfaceStyleLight       - 明亮
 * UIUserInterfaceStyleDark        - 暗黑 仅对 iOS 13+ 系统有效
 */
@property (nonatomic, strong) NSNumber *userInterfaceStyle;

// MARK: GOPPullAuthVCStyle

/**
 * @abstract 进入授权页面的方式，默认为 modal 方式，即 present 到授权页面
 */
@property (nonatomic, assign) GOPPullAuthVCStyle pullAuthVCStyle;

// MARK: Orientation

/**
 * 授权页面支持的横竖屏方向
 */
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;

// MARK: Phone Table Cell

/**
 默认为 NO，使用 SDK 提供的手机号关联列表，SDK 只提供字体大小和字体颜色的设置，若需完全自定义，可设置为 YES ， 此时，在输入手机号时，SDK 不显示关联列表，可在 GOPCustomAuthVCBlock 中重写 phoneTextField 的 delegate 方法自行实现关联列表功能，GOPManager 中有提供查询缓存手机号列表的方法 getCachedPhonesWithCompletionHandler:
 */
@property (nonatomic, assign) BOOL customPhoneTable;

/**
 手机号关联列表背景颜色
 */
@property (nonatomic, strong, nullable) UIColor *phoneTableCellBackgroundColor;

/**
 手机号关联列表中手机号的颜色
 */
@property (nonatomic, strong, nullable) UIColor *phoneTableCellTextColor;

/**
 手机号关联列表中手机号的字体
 */
@property (nonatomic, strong, nullable) UIFont *phoneTableCellTextFont;

@end

NS_ASSUME_NONNULL_END
