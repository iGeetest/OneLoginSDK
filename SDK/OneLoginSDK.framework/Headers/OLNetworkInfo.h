//
//  OLNetworkInfo.h
//  OneLoginSDK
//
//  Created by NikoXu on 2019/6/20.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OLNetworkType) {
    /** 网络类型未知 */
    OLNetworkTypeNone = 0,
    /** 仅移动蜂窝数据网络 */
    OLNetworkTypeCellular,
    /** 仅 WIFI 网络 */
    OLNetworkTypeWIFI,
    /** 移动蜂窝数据网络及 WIFI 网络 */
    OLNetworkTypeCellularAndWIFI,
};

NS_ASSUME_NONNULL_BEGIN

@interface OLNetworkInfo : NSObject

/**
 运营商名称
 
 @discussion
 @"CM" 移动, @"CU" 联通, @"CT" 电信
 */
@property (nullable, nonatomic, copy) NSString *carrierName;

/**
 网络类型
 
 @discussion
 即使返回非 `OLNetworkTypeNone`, 也可能因为终端用户未授权
 数据网络网络权限而无法访问设备的移动蜂窝数据网络
 
 @seealso
 OLNetworkType
 */
@property (nonatomic, assign) OLNetworkType networkType;

/**
 具体的网络类型，如2G、3G、4G、WIFI
 */
@property (nonatomic, copy) NSString *detailNetworkType;

@end

NS_ASSUME_NONNULL_END
