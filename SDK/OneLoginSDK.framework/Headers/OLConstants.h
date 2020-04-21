//
//  OLConstants.h
//  OneLoginSDK
//
//  Created by noctis on 2019/11/5.
//  Copyright © 2019 geetest. All rights reserved.
//

#ifndef OLConstants_h
#define OLConstants_h

// MARK: OneLogin

static NSString * const OneLoginURLPrefix           = @"https://onepass.geetest.com/";
static NSString * const OneLoginURLPreGetToken      = @"pre_get_token";
static NSString * const OneLoginURLTokenRecord      = @"token_record";
static NSString * const OneLoginURLClientReport     = @"clientreport_onelogin";

static NSString * const OLZero                 = @"0";
static NSString * const OLOne                  = @"1";

static NSString * const OLErrorDomain          = @"com.geetest.error.onelogin";
static NSString * const OLErrorCodeKey         = @"OLErrorCode";
static NSString * const OLErrorDescriptionKey  = @"OLErrorDescription";
static NSString * const OLFailureURLKey        = @"OLErrorFailureURL";
static NSString * const OLIsRsaErrorKey        = @"OLIsRsaError";

static NSString * const OLStatusKey            = @"status";
static NSString * const OLAppIDKey             = @"appID";
static NSString * const OLMessageKey           = @"msg";
static NSString * const OLProcessIDKey         = @"processID";
static NSString * const OLProcess_id           = @"process_id";
static NSString * const OLOperatorTypeKey      = @"operatorType";
static NSString * const OLOperatorKey          = @"operator";
static NSString * const OLMobileNumberKey      = @"number";
static NSString * const OLTokenKey             = @"token";
static NSString * const OLAccessCodeKey        = @"accessCode";
static NSString * const OLErrCodeKey           = @"errorCode";
static NSString * const OLMetaKey              = @"metadata";
static NSString * const OLPregetTokenTimeKey   = @"pre_token_time";
static NSString * const OLRequestTokenTimeKey  = @"request_token_time";
static NSString * const OLRiskInfoKey          = @"risk_info";
static NSString * const OLClientTypeKey        = @"clienttype";
static NSString * const OLClientIOS            = @"0";
static NSString * const OLSDKKey               = @"sdk";
static NSString * const OLOpsaltKey            = @"opsalt";
static NSString * const OLTimestampKey         = @"timestamp";
static NSString * const OLSignKey              = @"sign";
static NSString * const OLPreTokenTypeKey      = @"pre_token_type";
static NSString * const OLApp_id               = @"app_id";
static NSString * const OLCodeKey              = @"code";
static NSString * const OLResultCodeKey        = @"resultCode";
static NSString * const OLResultDataKey        = @"resultData";
static NSString * const OLResultMsgKey         = @"resultMsg";
static NSString * const OLAccess_token         = @"access_token";
static NSString * const OLResultKey            = @"result";
static NSString * const OLMobileKey            = @"mobile";
static NSString * const OLDescKey              = @"desc";
static NSString * const OLDataCache            = @"dataCache";
static NSString * const OLSecurityPhone        = @"securityPhone";
static NSString * const OLErrorMsgKey          = @"error_msg";
static NSString * const OLOperatorErrorCodeKey = @"operator_error_code";

static NSString * const OLGWAuthKey            = @"gwAuth";
static NSString * const OLAuthcodeKey          = @"authcode";

static NSString * const OLExpireTimeKey        = @"expire_time";
static NSString * const OLPreGetTokenSuccessedTimeKey = @"preGetTokenSuccessedTime";

static NSString * const OLSDKVersion           = @"2.1.3.1";

static NSString * const OLCM                   = @"CM";     // 移动
static NSString * const OLCU                   = @"CU";     // 联通
static NSString * const OLCT                   = @"CT";     // 电信

static NSString * const OLServerConfig         = @"server_config";
static NSString * const OLCarrierID            = @"get_token_id";
static NSString * const OLCarrierKey           = @"get_token_key";

static NSString * const OLCMTermTitle          = @"中国移动认证服务条款";
static NSString * const OLCMTermLink           = @"http://wap.cmpassport.com/resources/html/contract.html";
static NSString * const OLCMSlogan             = @"中国移动提供认证服务";

static NSString * const OLCUTermTitle          = @"联通统一认证服务条款";
static NSString * const OLCUTermLink           = @"https://opencloud.wostore.cn/authz/resource/html/disclaimer.html?fromsdk=true";
static NSString * const OLCUSlogan             = @"认证服务由联通统一认证提供";

static NSString * const OLCTTermTitle          = @"天翼账号服务与隐私协议";
static NSString * const OLCTTermLink           = @"https://e.189.cn/sdk/agreement/detail.do?hidetop=true";
static NSString * const OLCTSlogan             = @"天翼账号提供认证服务";

static NSString * const OLLeftQuotationMark    = @"《";
static NSString * const OLRightQuotationMark   = @"》";

static NSTimeInterval const OLDefaultTimeout   = 5;

static NSTimeInterval const OLMinTimeInterval  = 0.7;

static NSInteger const OLMaxKeyWindowNilRetryTime = 2;

// MARK: Deepknow

static NSString * const OLDeepKnowSessionKey   = @"deepknow_session_id";
static NSString * const OLDeepKnowAppId        = @"ca2a4725af052672f25faf64b181bb5b";

// MARK: Config

static NSString * const OLCustomedServerURLKey = @"CustomedServerURL";
static NSString * const OLPrivatizationKey     = @"Privatization";

// MARK: OnePass

static NSString * const OnePassURLPrefix       = @"https://onepass.geetest.com/v2.0/";
static NSString * const OnePassURLClientReport = @"clientreport";
static NSString * const OnePassURLPreGetway    = @"pre_gateway";

static NSString * const OPErrorData            = @"error_data";
static NSString * const OPErrorFailingURL      = @"GOPFailingURL";

static NSInteger const OPErrorInvalidPreGatewayReturns = -50100;
static NSString * const OPErrorInvalidPreGatewayReturnsDesc = @"Server return invalid data.";

static NSInteger const OPErrorSocketError      = -39901;
static NSString * const OPErrorSocketErrorDesc = @"Create socket fail.";
static NSString * const OPErrorSetSocketErrorDesc = @"Set socket option fail.";
static NSString * const OPErrorSocketErrorResolveHostnameDesc = @"Unable to resolve the hostname of the warehouse server.";
static NSString * const OPErrorSocketErrorConnectServerDesc = @"Error in connecting to the server.";
static NSString * const OPErrorSocketErrorSendDataDesc = @"Error in sending data to the server.";
static NSString * const OPErrorSocketErrorDropByRemoteDesc = @"Connection dropped by remote socket.";
static NSString * const OPErrorSocketErrorNullResponseDesc = @"Socket server return null response.";
static NSString * const OPErrorSocketOperatorReturnErrorDesc = @"Operator returns an error.";

static NSInteger const OPErrorReceiveEmptyDataError = -39902;
static NSInteger const OPErrorCUGetTokenFail = -40201;
static NSString * const OPErrorCUGetTokenFailDesc = @"Get token from china unicom failed.";
static NSInteger const OPErrorCUUnsupportedNetwork = -40204;
static NSInteger const OPErrorCTGetTokenFail = -40301;
static NSString * const OPErrorCTGetTokenFailDesc = @"Get token from china telecom failed.";
static NSInteger const OPErrorCMGetTokenFail = -40101;
static NSString * const OPErrorCMGetTokenFailDesc = @"Get token from china mobile failed.";

#endif /* OLConstants_h */
