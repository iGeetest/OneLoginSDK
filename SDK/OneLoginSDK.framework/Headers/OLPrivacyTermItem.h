//
//  OLPrivacyTermsItem.h
//  OneLoginSDK
//
//  Created by NikoXu on 2019/6/4.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OLPrivacyTermItem : NSObject

/**
 条款标题
 */
@property (nonatomic, strong) NSString *termTitle;

/**
 条款链接
 */
@property (nonatomic, strong) NSURL *termLink;

/**
 条款索引，默认为0，当有多条条款时，会根据此属性升序排列条款
 */
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithTitle:(NSString *)title linkURL:(NSURL *)url;
- (instancetype)initWithTitle:(NSString *)title linkURL:(NSURL *)url index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
