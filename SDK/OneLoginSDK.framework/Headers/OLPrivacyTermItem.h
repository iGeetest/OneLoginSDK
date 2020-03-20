//
//  OLPrivacyTermsItem.h
//  OneLoginSDK
//
//  Created by NikoXu on 2019/6/4.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OLPrivacyTermItem;

typedef void(^OLViewPrivacyTermItemBlock)(OLPrivacyTermItem *termItem, UIViewController *controller);

@interface OLPrivacyTermItem : NSObject

/**
 条款标题
 */
@property (nonatomic, copy) NSString *termTitle;

/**
 条款链接
 */
@property (nonatomic, strong) NSURL *termLink;

/**
 条款链接
 */
@property (nonatomic, strong) NSURLRequest *urlRequest;

/**
 查看条款链接回调，当设置该回调时，查看服务条款时不进入SDK内部服务条款页面，由客户自定义处理
 */
@property (nonatomic, copy, nullable) OLViewPrivacyTermItemBlock block;

/**
 条款索引，默认为0，当有多条条款时，会根据此属性升序排列条款
 */
@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithTitle:(NSString *)title linkURL:(NSURL *)url;
- (instancetype)initWithTitle:(NSString *)title linkURL:(NSURL *)url index:(NSInteger)index;
- (instancetype)initWithTitle:(NSString *)title linkURL:(NSURL *)url index:(NSInteger)index block:(OLViewPrivacyTermItemBlock _Nullable)block;
- (instancetype)initWithTitle:(NSString *)title urlRequest:(NSURLRequest *)urlRequest index:(NSInteger)index block:(OLViewPrivacyTermItemBlock _Nullable)block;

@end

NS_ASSUME_NONNULL_END
