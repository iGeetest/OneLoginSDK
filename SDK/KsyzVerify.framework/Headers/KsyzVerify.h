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
 @param config 配置信息 {"codeUrl":@"xxxx"}

*/
- (void)registerAppKey:(NSString * _Nonnull)appKey appSecret:(NSString * _Nonnull)appSecret;

/**
 预取号
 
 @timeout 超时时间
 @completion 完成回调
*/
- (void)preLogin:(NSTimeInterval)timeout completion:(void(^)(NSDictionary * _Nullable resultDic))completion;

/**
登录

@timeout 超时时间
@completion 完成回调
*/
- (void)login:(NSTimeInterval)timeout completion:(void(^)(NSDictionary * _Nullable resultDic))completion;

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

@end

NS_ASSUME_NONNULL_END
