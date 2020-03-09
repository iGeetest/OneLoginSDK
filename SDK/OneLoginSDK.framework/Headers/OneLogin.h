//
//  OneLogin.h
//  OneLoginSDK
//
//  Created by NikoXu on 2019/3/18.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLAuthViewModel.h"
#import "OLNetworkInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OneLoginDelegate;

@interface OneLogin : NSObject

/**
 获取当前 OneLogin 可用的网络信息
 
 @discussion
 当使用的是非移动、联通、电信三大运营商, 则返回nil。
 OneLogin 仅在大陆支持移动、联通、电信三大运营商。
 
 @seealso
 OLNetworkInfo 中有属性的详细描述
 */
+ (nullable OLNetworkInfo *)currentNetworkInfo;

/**
 向SDK注册AppID
 
 @discussion `AppID`通过后台注册获得，从极验后台获取该AppID，AppID需与bundleID配套

 @param appID 产品ID
 */
+ (void)registerWithAppID:(NSString *)appID;

/**
 设置代理对象

 @param delegate 代理对象
 */
+ (void)setDelegate:(nullable id<OneLoginDelegate>)delegate;

/**
 设置请求超时时长。默认时长5s。

 @param timeout 超时时长
 */
+ (void)setRequestTimeout:(NSTimeInterval)timeout;

/**
 预取号接口
 
 @discussion 调用限制说明
 
 在调用该方法后, 未回调之前, 再次调用该方法时, 方法会直接跳出, 不执行预取号逻辑。
 
 @discussion 成功的返回格式
 
 {
 status = 200; // NSNumber, 200为成功的状态码
 
 processID = 47dab9b7c26629cd9bc117f88e2f9233; // NSString, 流水号
 
 appID = 2**************************d; // NSString, 产品ID
 
 operatorType = CU; // NSString, 运营商类型(CM/CU/CT)
 
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 相关的描述消息
 }
 
 @discussion 失败的返回格式
 
 {
 status = 500; // NSNumber, 500为失败的状态码
 
 processID = 47dab9b7c26629********f88e2f9233; // NSString, 流水号
 
 appID = 2**************************d; // NSString, 产品ID
 
 operatorType = CT; // NSString, 运营商类型(CM/CU/CT)
 
 errorCode = "-30003", // NSString, 预取号不成功时的错误码
 
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 相关的描述消息
 
 metadata = {}; // NSDictionary, 失败时运营商的响应内容。
 }
 
 @discussion 预取号成功后存在的有效期
 
 有效期内需要调用 `requestTokenWithViewController:viewModel:completion:`,
 否则需要重新访问 `preGetTokenWithCompletion:`。 其中中国移动有效期为 1 小时,
 中国联通和中国电信为 10 分钟。

 @param completion 处理回调
 */
+ (void)preGetTokenWithCompletion:(void(^)(NSDictionary *sender))completion;


/**
 进行用户认证授权, 获取网关 token 。
 
 @discussion 调用限制说明
 
 为避免授权页面多次弹出, 在调用该方法后, 授权页面弹出, 再次调用该方法时,
 该方法会直接跳出, 不执行授权逻辑。
 
 @discussion 需要用户在弹出的页面上同意服务意条款后, 才会进行免密认证。
 
 @discussion 回调后, 需要手动关闭`OLAuthViewContorller`。可以参考的代码是:
 
 `[OneLogin dismissAuthViewController];`
 
 @discussion 成功返回的格式:
 
 {
 status = 200; // NSNumber, 200为成功的状态码
 
 processID = 47dab9b7c26629cd9bc117********33; // NSString, 流水号
 
 appID = 2**************************d; // NSString, 产品ID
 
 token = 62718774ad1247188bc678********d3; // NSString, 运营商返回的accessToken, 用于查询真实的本机号
 
 operatorType = CU; // NSString, 运营商类型(CM/CU/CT)
 
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 运营商返回的Msg
 }
 
 @discussion 失败返回的格式:
 
 {
 status = 500; // NSNumber, 500为失败的状态码
 
 processID = 47dab9b7c26629cd9bc117f88e2f9233; // NSString, 流水号
 
 appID = 2**************************d; // NSString, 产品ID
 
 operatorType = CT; // NSString, 运营商类型(CM/CU/CT)
 
 errorCode = "-30003", // NSString, 运营商返回的错误码
 
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 运营商返回的描述消息
 
 metadata = {}; // NSDictionary, 失败时, 运营商的响应内容。
 }
 
 @discussion token 有效期
 中国移动的有效期为 2 分钟，中国联通的为 30 分钟，中国电信的为 30 天。

 @param viewController  present认证页面控制器的vc
 @param viewModel       自定义授权页面的视图模型
 @param completion      结果处理回调
 
 @seealso OLAuthViewModel
 
 */
+ (void)requestTokenWithViewController:(nullable UIViewController *)viewController
                             viewModel:(nullable OLAuthViewModel *)viewModel
                            completion:(void(^)(NSDictionary * _Nullable result))completion;

/**
 进行用户认证授权, 获取网关 token 。
 
 @param completion 结果处理回调
 
 */
+ (void)requestTokenWithCompletion:(void(^)(NSDictionary * _Nullable result))completion;

/**
 @abstract 关闭当前的授权页面
 
 @param animated 是否需要动画
 @param completion 关闭页面后的回调
 
 @discussion
 请不要使用其他方式关闭授权页面, 否则可能导致 OneLogin 无法再次调起
 */
+ (void)dismissAuthViewController:(BOOL)animated completion:(void (^ __nullable)(void))completion;
+ (void)dismissAuthViewController:(void (^ __nullable)(void))completion;

/**
 停止点击授权页面登录按钮之后的加载进度条
 */
+ (void)stopLoading;

/**
 enable授权页面登录按钮
 */
+ (void)enableAuthButton;

/**
 disable授权页面登录按钮
 */
+ (void)disableAuthButton;

/**
 * @abstract 服务条款左边复选框是否勾选
 */
+ (BOOL)isProtocolCheckboxChecked;

/**
 * @abstract 预取号拿到的token是否还在有效期
 *
 * @return YES - 还在有效期，可直接调用requestTokenWithViewController方法进行取号
 *         NO  - 已失效，需重新调用preGetTokenWithCompletion进行预取号之后再调用requestTokenWithViewController方法进行取号
 */
+ (BOOL)isPreGettedTokenValidate;

/**
 获取SDK版本号

 @return SDK当前的版本号
 */
+ (NSString *)sdkVersion;

/**
 * @abstract 设置是否允许打印日志
 *
 * @param enabled YES，允许打印日志 NO，禁止打印日志
 */
+ (void)setLogEnabled:(BOOL)enabled;

/**
 * @abstract 指示是否打印日志的状态
 *
 * @return YES，允许打印日志 NO，禁止打印日志
 */
+ (BOOL)isLogEnabled;

/**
 * @abstract 自定义接口，自定义之后，SDK内部HTTP请求就会使用该自定义的接口
 *
 * @param URL 接口URL
 */
+ (void)customInterfaceURL:(const NSString * __nullable)URL;

/**
 * @abstract 获取当前授权页面对应的ViewController
 *
 * @return 当前授权页面对应的ViewController
 */
+ (UIViewController * _Nullable)currentAuthViewController;

/**
 * @abstract 更新授权页面一键登录按钮的文案
 *
 * @param authButtonTitle 一键登录按钮的文案
 */
+ (void)updateAuthButtonTitle:(NSAttributedString *)authButtonTitle;

/**
 * @abstract 删除预取号的缓存
 */
+ (void)deletePreResultCache;

/**
 * @abstract 开始取号
 */
+ (void)startRequestToken;

@end

@protocol OneLoginDelegate <NSObject>

@optional

/**
 用户点击了授权页面的返回按钮
 */
- (void)userDidDismissAuthViewController;

/**
 用户点击了授权页面的"切换账户"按钮
 */
- (void)userDidSwitchAccount;

@end

NS_ASSUME_NONNULL_END
