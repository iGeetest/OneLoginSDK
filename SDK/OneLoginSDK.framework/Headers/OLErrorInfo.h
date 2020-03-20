//
//  OLErrorInfo.h
//  OneLoginSDK
//
//  Created by noctis on 2019/11/8.
//  Copyright © 2019 geetest. All rights reserved.
//

#ifndef OLErrorInfo_h
#define OLErrorInfo_h

static NSInteger const OLStatusCode_200         = 200;
static NSInteger const OLStatusCode_400         = 400;
static NSInteger const OLStatusCode_500         = 500;

// ****************** -201.. ******************/

static NSString * const OLErrorCode_20101 = @"-20101";  // AppID无效
static NSString * const OLErrorDesc_20101 = @"Invalid App ID.";

static NSString * const OLErrorCode_20102 = @"-20102";  // 没有预取号，就直接调用取号接口，1.9.0及以上版本，在SDK内部控制预取号结果，理论上不再出现此错误
static NSString * const OLErrorDesc_20102 = @"Invalid AccessCode. You should get a valid AccessCode by `preGetToken` method first.";

static NSString * const OLErrorCode_20105 = @"-20105";  // 拉起授权页面超时
static NSString * const OLErrorDesc_20105 = @"Request token timeout.";

static NSString * const OLErrorCode_20106 = @"-20106";  // 取号时更换了不同运营商的 SIM 卡
static NSString * const OLErrorDesc_20106 = @"SIM is changed while requesting token.";

// ****************** -202.. ******************/

static NSString * const OLErrorCode_20200 = @"-20200";  // 当前网络不可用
static NSString * const OLErrorDesc_20200 = @"No valid network.";

static NSString * const OLErrorCode_20202 = @"-20202";  // 未开启蜂窝移动网络
static NSString * const OLErrorDesc_20202 = @"Can't access cellular.";

static NSString * const OLErrorCode_20203 = @"-20203";  // 未获取到正确的运营商
static NSString * const OLErrorDesc_20203 = @"Do not get right operator.";

// ****************** -203.. ******************/

static NSString * const OLErrorCode_20302 = @"-20302";  // 点击授权页面返回按钮退出授权页面
static NSString * const OLErrorDesc_20302 = @"User click back button to dismiss auth view controller.";

static NSString * const OLErrorCode_20303 = @"-20303";  // 点击授权页面切换账号按钮
static NSString * const OLErrorDesc_20303 = @"User click switch button to dismiss auth view controller.";

// ****************** -204.. iOS专用 ******************/

static NSString * const OLErrorCode_20402 = @"-20402";  // 正在拉起授权页面，仍然调用requestTokenWithViewController方法进入授权页面，若要重新拉起授权页面，请先关闭当前授权页面
static NSString * const OLErrorDesc_20402 = @"Auth ViewController is been prsented.";

static NSString * const OLErrorCode_20403 = @"-20403";  // AuthViewController已经拉起的情况下，仍然调用requestTokenWithViewController方法进入授权页面，若要重新拉起授权页面，请先关闭当前授权页面
static NSString * const OLErrorDesc_20403 = @"AuthViewController has been prsented, donot present again.";

static NSString * const OLErrorCode_20404 = @"-20404";  // 当前正在预取号，不要重复调用预取号接口
static NSString * const OLErrorDesc_20404 = @"Is pregetting token, donot preget token again.";

static NSString * const OLErrorCode_20405 = @"-20405";  // 当前正在取号，不要重复调用取号接口
static NSString * const OLErrorDesc_20405 = @"Is requesting token, donot request token again.";

static NSString * const OLErrorCode_20406 = @"-20406";  // 预取号超时
static NSString * const OLErrorDesc_20406 = @"Preget token timeout.";

static NSString * const OLCarrierSDKErrorDomain  = @"com.geetest.carriersdkerror";
static NSString * const OLErrorCode_20407 = @"-20407";  // 移动 SDK TYRZSDK.framework 有误
static NSString * const OLErrorCode_20408 = @"-20408";  // 联通 SDK account_login_sdk_noui_core.framework 有误
static NSString * const OLErrorCode_20409 = @"-20409";  // 移动 SDK EAccountApiSDK.framework 有误

static NSString * const OLErrorCode_20410 = @"-20410";  // 未获取到 key window
static NSString * const OLErrorDesc_20410 = @"Key window is nil.";

// ****************** -2041. iOS专用，rsa加密失败 ******************/
static NSString * const OLRsaErrorDomain  = @"com.geetest.rsaencrypterror";
static NSString * const OLRsaErrorMsg     = @"Rsa encrypt failed.";
static NSString * const OLErrorCode_20411 = @"-20411";
static NSString * const OLErrorCode_20412 = @"-20412";
static NSString * const OLErrorCode_20413 = @"-20413";
static NSString * const OLErrorCode_20414 = @"-20414";
static NSString * const OLErrorCode_20415 = @"-20415";
static NSString * const OLErrorCode_20416 = @"-20416";
static NSString * const OLErrorCode_20417 = @"-20417";

// ****************** -40... ******************/

static NSString * const OLErrorCode_40101 = @"-40101";  // 移动预取号，未返回正确结果
static NSString * const OLErrorDesc_40101 = @"China Mobile return invalid data.";
static NSString * const OLErrorCode_40102 = @"-40102";  // 移动取号，未返回正确结果

static NSString * const OLErrorCode_40201 = @"-40201";  // 联通预取号，未返回正确结果
static NSString * const OLErrorCode_40202 = @"-40202";  // 联通取号，未返回正确结果

static NSString * const OLErrorCode_40301 = @"-40301";  // 电信预取号，未返回正确结果

// ****************** -501.. ******************/

static NSString * const OLErrorCode_50100 = @"-50100";  // pregettoken接口返回异常
static NSString * const OLErrorDesc_50100 = @"Pregettoken interface return exception.";

static NSString * const OLErrorCode_50101 = @"-50101";  // pregettoken接口返回的数据解密失败
static NSString * const OLErrorDesc_50101 = @"Pregettoken return data decrypt failed.";

#endif /* OLErrorInfo_h */

