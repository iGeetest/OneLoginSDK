//
//  OneLoginPro.h
//  OneLoginSDK
//
//  Created by liulian on 2019/3/18.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLAuthViewModel.h"
#import "OLNetworkInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface OneLoginPro : NSObject

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
 * 判断是否已经注册
 *
 * @return 已注册，返回 YES，未注册，返回 NO
 */
+ (BOOL)hasRegistered;

/**
 设置请求超时时长。默认时长5s。

 @param timeout 超时时长
 */
+ (void)setRequestTimeout:(NSTimeInterval)timeout;

/**
 进行用户认证授权, 获取网关 token 。
 
 @discussion 调用限制说明
 
 为避免授权页面多次弹出, 在调用该方法后, 授权页面弹出, 再次调用该方法时,
 该方法会直接跳出, 不执行授权逻辑。
 
 @discussion 需要用户在弹出的页面上同意服务意条款后, 才会进行免密认证。

 @param viewController  present认证页面控制器的vc
 @param viewModel       自定义授权页面的视图模型
 @param completion      结果处理回调
 
 @seealso OLAuthViewModel
 
 @discussion completion 的 result 数据如下：
 
 获取成功：
 {
   "model" : "iPhone9,1",
   "authcode" : "0000",
   "operatorType" : "CU",
   "release" : "13.5.1",
   "processID" : "967ceb230b3fdfb4d74ebcb470c5830c",
   "appID" : "b41a959b5cac4dd1277183e074630945",
   "pre_token_time" : "1012",
   "token" : "CU__0__b41a959b5cac4dd1277183e074630945__2.3.8__1__f632d01ab7c64efda96580c3274de971__NOTCUCC",
   "number" : "186****6173",
   "preGetTokenSuccessedTime" : 1604890895.807291,
   "errorCode" : "0",
   "msg" : "获取accessCode成功",
   "status" : 200,
   "expire_time" : 580
 }
 
 获取失败：
 {
   "status" : 500,
   "operatorType" : "CU",
   "appID" : "b41a959b5cac4dd1277183e074630945",
   "model" : "iPhone9,1",
   "release" : "13.5.1",
   "msg" : "Can't access cellular.",
   "errorCode" : "-20202"
 }
 
 status - 200 表示获取预取号结果成功，500 表示获取预取号结果失败
 token - 换取手机号需要的 token
 processID - 流水号
 appID - appId
 authcode - authcode
 operatorType - 运营商
 errorCode - 获取失败时的错误码
 msg - 获取失败时表示失败原因
 */
+ (void)requestTokenWithViewController:(nullable UIViewController *)viewController
                             viewModel:(nullable OLAuthViewModel *)viewModel
                            completion:(void(^)(NSDictionary * _Nullable result))completion;
+ (void)requestTokenWithCompletion:(void(^)(NSDictionary * _Nullable result))completion;

/**
 * @abstract 重新预取号
 *
 * @discussion 在通过requestTokenWithCompletion方法成功登录之后，为保证用户在退出登录之后，能快速拉起授权页面，请在用户退出登录时，调用此方法
 */
+ (void)renewPreGetToken;

/**
* @abstract 获取预取号结果
*
* @param completion 预取号结果
*
* @discussion completion 的 result 数据如下：
 获取成功：
 {
   "model" : "iPhone9,1",
   "accessCode" : "d3f3c605a2684a8fbb4b43ee0f94f1ff",
   "operatorType" : "CU",
   "release" : "13.5.1",
   "processID" : "1f1437fd0b3026ff44500c3d03cdd822",
   "appID" : "b41a959b5cac4dd1277183e074630945",
   "pre_token_time" : "1087",
   "number" : "186****6173",
   "preGetTokenSuccessedTime" : 1604890389.0020308,
   "msg" : "获取accessCode成功",
   "status" : 200,
   "expire_time" : 580
 }
 
 获取失败：
 {
   "status" : 500,
   "operatorType" : "CU",
   "appID" : "b41a959b5cac4dd1277183e074630945",
   "model" : "iPhone9,1",
   "release" : "13.5.1",
   "msg" : "Can't access cellular.",
   "errorCode" : "-20202"
 }
 
 status - 200 表示获取预取号结果成功，500 表示获取预取号结果失败
 number - 脱敏手机号
 operatorType - 运营商
 errorCode - 获取失败时的错误码
 msg - 获取失败时表示失败原因
*/
+ (void)getPreGetTokenResult:(void(^)(NSDictionary * _Nullable result))completion;

/**
 * @abstract 判断预取号结果是否有效
 *
 * @return YES: 预取号结果有效，可直接拉起授权页面 NO: 预取号结果无效，需加载进度条，等待预取号完成之后拉起授权页面
 */
+ (BOOL)isPreGetTokenResultValidate;

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
 * @abstract 获取当前授权页面对应的配置
 *
 * @return 当前授权页面对应的配置
 */
+ (OLAuthViewModel * _Nullable)currentAuthViewModel;

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
 获取SDK版本号
 
 @return SDK当前的版本号
 */
+ (NSString *)sdkVersion;

/**
 * @abstract 自定义接口，自定义之后，SDK内部HTTP请求就会使用该自定义的接口
 *
 * @param URL 接口URL
 */
+ (void)customInterfaceURL:(const NSString * __nullable)URL;

/**
 * @abstract 设置是否允许打印日志
 *
 * @param enabled YES，允许打印日志 NO，禁止打印日志
 */
+ (void)setLogEnabled:(BOOL)enabled;
+ (void)setCMLogEnabled:(BOOL)enabled;

/**
 * @abstract 指示是否打印日志的状态
 *
 * @return YES，允许打印日志 NO，禁止打印日志
 */
+ (BOOL)isLogEnabled;

/**
 * @abstract 删除预取号的缓存 
 */
+ (void)deletePreResultCache;

/**
 * @abstract 开始取号
 */
+ (void)startRequestToken;

+ (void)setOperatorParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
