//
//  GOPManager.h
//  OneLoginSDK
//
//  Created by noctis on 2020/1/6.
//  Copyright © 2020 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOPError.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GOPPhoneNumEncryptOption) {
    GOPPhoneNumEncryptOptionNone = 0,   // none
    GOPPhoneNumEncryptOptionSha256      // sha256
};

@protocol GOPManagerDelegate;

typedef void(^GOPCompletion)(NSDictionary *dict);
typedef void(^GOPFailure)(NSError *error);

@interface GOPManager : NSObject

@property (nonatomic, weak) id<GOPManagerDelegate> delegate;

/**
 @abstract 判断当前的运营商状态和网络状态
 
 @discussion
 当前运营商为中国三大运营商(移动、联通、电信)时，且网络状态为 Celluar 或者 Wifi & Celluar 时，返回 YES，否则，返回 NO
 */
@property (nonatomic, readonly, assign) BOOL diagnosisStatus;

/**
 Return current phone number.
 If encrypted, return encrypted phone number.
 
 @discussion
 Before OnePass callback, `currentPhoneNum` return
 original phone number.
 */
@property (nonatomic, readonly, copy, nullable) NSString *currentPhoneNum;

/**
 Phone number Encryption Option.
 If encrypted, it will be hard to debug. We recommend developers not to use this option.
 If you want use this option, you should register this feature through us first.
 */
@property (nonatomic, assign) GOPPhoneNumEncryptOption phoneNumEncryptOption;

/**
 Initializes and returns a newly allocated GOPManager object.
 
 @discussion Register customID from `geetest.com`, and configure your verifyUrl
             API base on Server SDK. Check Docs on `docs.geetest.com`. If OnePass
             fail, GOPManager will request SMS URL that you set.
 @param customID custom ID, nonull
 @param timeout timeout interval
 @return A initialized GOPManager object.
 */
- (instancetype)initWithCustomID:(NSString * _Nonnull)customID timeout:(NSTimeInterval)timeout;

/**
 Verify phone number through OnePass.
 See a sample result from `https://github.com/GeeTeam/gop-ios-sdk/blob/master/SDK/gop-ios-dev-doc.md#verifyphonenumcompletionfailure`

 @param phoneNumber phone number
 */
- (void)verifyPhoneNumber:(NSString * _Nullable)phoneNumber;
- (void)verifyPhoneNumber;

/**
 * @abstract 自定义接口，自定义之后，SDK 内部 HTTP 请求就会使用该自定义的接口
 *
 * @param URL 接口 URL
 */
- (void)setServerURL:(const NSString * __nullable)URL;
+ (void)setServerURL:(const NSString * __nullable)URL;

/**
 * @abstract 设置是否允许打印日志
 *
 * @param enabled YES，允许打印日志 NO，禁止打印日志
 */
+ (void)setLogEnabled:(BOOL)enabled;

/**
 * @abstract 是否允许打印日志
 *
 * @return YES，允许打印日志 NO，禁止打印日志
 */
+ (BOOL)isLogEnabled;

@end

@protocol GOPManagerDelegate <NSObject>

@required

- (void)gtOnePass:(GOPManager *)manager errorHandler:(GOPError *)error;

- (void)gtOnePass:(GOPManager *)manager didReceiveDataToVerify:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
