//
//  KsyzVerify.h
//  KsyzVerify
//
//  Created by ksyz on 2019/5/16.
//  Copyright © 2019 ksyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KsyzVerify : NSObject

/**
单例对象
*/
+ (instancetype)defaultVerify;

/**
 注册应用
 
 @param appKey appkey
 @param appSecret appscret
*/
- (void)registerAppKey:(NSString * _Nonnull)appKey appSecret:(NSString * _Nonnull)appSecret;

/**
开启debug模式

@param enable 是否开启debug模式
*/
- (void)setDebug:(BOOL)enable;

/**
 当前sdk版本号

 @return 版本号
 */
- (NSString * _Nonnull)sdkVersion;


/**
 设置置换token所需的
 注意：*********login函数，getMobileBridgeToken函数之前调用******
 @params  params 参数
         (duid  唯一id string
         idfa  idfa string
         idfv  idfv string
         phone  脱敏号码 string ,联通必须要穿，移动可以不传
         )

*/
- (void)setTokenParams:(NSDictionary *)params;


#pragma mark- 联通相关接口
/**
 联通预取号
 
 @timeout 超时时间
 @completion 完成回调
*/
- (void)preLogin:(NSTimeInterval)timeout completion:(void(^)(NSDictionary * _Nullable resultDic))completion;

/**
联通登录

@timeout 超时时间
@completion 完成回调
*/
- (void)login:(NSTimeInterval)timeout completion:(void(^)(NSDictionary * _Nullable resultDic))completion;

#pragma mark- 移动相关接口

/**
 获取移动配置信息
 
 @completion 完成回调
*/
- (void)getMobileConfig:(void(^)(NSDictionary * _Nullable resultDic))completion;

/**
 置换移动号码所需的token
 
 @completion 完成回调
*/
- (void)getMobileBridgeToken:(void(^)(NSDictionary * _Nullable resultDic))completion;

@end

NS_ASSUME_NONNULL_END
