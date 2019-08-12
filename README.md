# 更新日志
版本|更新内容|更新日期
-----|-----|-----
**1.6.1** |1、获取手机网络方法适配iOS13| 2019-08-09
**1.6.0** |1、增加授权页面弹窗支持；<br>2、增加设置横竖屏状态下各控件x轴偏移的功能；<br>3、增加设置返回按钮、logo、授权按钮等控件大小的功能；<br>4、增加设置切换账号按钮、slogan、服务条款字体的功能； <br>5、增加横竖屏自动切换功能；<br>6、增加服务条款排序功能；<br>7、实现服务条款SDK内部跳转功能| 2019-08-08
**1.5.1** |1、修复可能的循环引用问题 | 2019-08-07
**1.5.0** |1、横屏支持；<br>2、开放重复预取号；<br>3、优化布局<br>4、其他问题修复 | 2019-07-29
**1.4.2** |1、封装关闭授权页面的方法；<br>2、内存泄露处理； | 2019-07-16
**1.4.1** |1、支持双卡；<br>2、优化和统一错误码；<br>3、其他Bug修复。 | 2019-07-12
**1.3.0** |1、授权页UI自定义内容更新，三网统一，允许插入自定义控件；<br>2、授权页面切换逻辑优化，允许手动控制页面消失时间；<br>3、其他Bug修复。 | 2019-06-14


---
title: ios
type: ios
order: 0
---

# 概述及资源

## 环境需求

条目    	|资源             
----------|------------    
开发目标	|iOS8+      
开发环境	|Xcode 10 
系统依赖	|`libc++.1.tbd`、`libz.1.2.8.tbd`
SDK 三方依赖|`account_login_sdk_noui_core.framework`、`EAccountApiSDK.framework`、`TYRZSDK.framework`、`TYRZResource.bundle`

## 相关开发资料

条目         	|资源                
-------------	|----------------
产品结构流程   	|[交互流程](https://docs.geetest.com/onelogin/overview/flowchart/#交互流程), [通讯流程](https://docs.geetest.com/onelogin/overview/flowchart/#通讯流程)
接口文档      	|[OneLogin iOS API Ref](https://docs.geetest.com/onelogin/apirefer/api/ios/) 或查看头文件注释
错误码			|[Error Code 列表](https://docs.geetest.com/onelogin/apirefer/errorcode/ios)


# 安装

## 获取 SDK 及 Demo

### 下载获取

[点击下载](https://docs.geetest.com/downloads/onelogin-ios-1.6.1.zip)

## 导入 SDK 到项目工程并配置开发环境

1. 将下载获取的**`OneLogin.framework`**, `account_login_sdk_noui_core.framework`、`EAccountApiSDK.framework`、`TYRZSDK.framework`以及在**`OneLoginResource.bundle`**、`TYRZResource.bundle`共6个文件添加到工程中, 确保`Copy items if needed`已被勾选。

	此外, 需要添加`libc++.1.tbd`、`libz.1.2.8.tbd`库进行依赖。
    
   添加完后, 以`Linked Frameworks and Libraries`方式导入 framework。在拖入`OneLogin.framework`, `account_login_sdk_noui_core.framework`、`EAccountApiSDK.framework`、`TYRZSDK.framework`到工程后, 请检查所有的`.framework`是否被添加到`PROJECT -> Build Phases -> Linked Frameworks and Libraries`, 以确保正常编译。

2. 针对静态库中的`Category`, 需要在对应 target 的`Build Settings`->`Other Linker Flags`添加`-ObjC`编译选项。如果依然有问题，再添加`-all_load`。

3. 配置ATS，在 info.plist 文件中添加 App Transport Security Settings 项，并在其中添加 Allow Arbitrary Loads 子项，同时将该子项的值设置为 YES。

## 配置接口

开发者集成客户端 SDK 前, 必须先在您的服务器上搭建相应的[服务端获取登录信息的接口](https://docs.geetest.com/onelogin/deploy/server/api)，并配置从[极验后台](https://auth.geetest.com)获取的`AppID `。这里以服务端配置成功，客户端开发步骤为例，如下：

1. 用 `AppID` 注册 OneLogin

    ```objc
    [OneLogin registerWithAppID:@"---<申请的AppID>---"];
    ```

2. 调用预取号接口

	从回调中可以获取到预取号是否成功的状态
	
    ```objc
    [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
        NSLog(@"sender: %@", sender.description);
    }];    
    ```
    
3. 调用取号接口

	开发者在完成预取号后, 通过该接口获取用于获取该用户手机号信息的访问令牌, 使用该访问令牌去查询用户的手机号及相关信息。

    ```objc
    [OneLogin requestTokenWithViewController:self viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSNumber *status = [result objectForKey:@"status"];
        if ([@(200) isEqualToNumber:status]) { // 获取token成功
            // TO-DO
            // 校验和获取登录的用户的数据
            
        }
        else {
            NSLog(@"result: %@", result);
        }
    }];
    ```

> 集成代码参考下方的**代码示例**。更进一步的示例, 见相关Demo。


## 代码示例

在工程中的文件头部导入静态库 `OneLoginSDK.framework`

```objc
#import <OneLoginSDK/OneLoginSDK.h>
```

### 注册及预取号
    
在相应的控制页初始化方法中对`OneLoginSDK`实例调用注册方法:
    
```objc
[OneLogin registerWithAppID:@"---<申请的AppID>---"];
```

### 预取号

在每次获取免密登录的token之前, 需要调用预取号接口

```objc
[OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
    NSLog(@"sender: %@", sender.description);
    NSNumber *status = [sender objectForKey:@"status"];
    if (status && [@(200) isEqualToNumber:status]) {
        // 预取号成功
        
    }
    else {
#warning 请处理预取号的错误, 更多错误码请参考错误码文档
        NSString *errCode   = [sender objectForKey:@"errorCode"];
        NSString *msg       = [sender objectForKey:@"msg"];
        NSString *processID = [sender objectForKey:@"processID"];
        NSString *appID     = [sender objectForKey:@"appID"];
        NSString *operator  = [sender objectForKey:@"operatorType"];
        
        NSLog(@"[Operator: %@] - [Error Code: %@] - [Message: %@] - [ProccesID: %@] - [APPID: %@]", operator, errCode, msg, processID, appID);
        
        // 预取号失败
        if ([@"-20101" isEqualToString:errCode]) {
            // TO-DO
            // 未配置 AppID，请通过 registerWithAppID: 配置 AppID
        }
        else if ([@"-20102" isEqualToString:errCode]) {
            // TO-DO
            // 重复调用 preGetTokenWithCompletion:
        }
        else if ([@"-20202" isEqualToString:errCode]) {
            // TO-DO
            // 检测到未开启蜂窝网络
        }
        else if ([@"-20203" isEqualToString:errCode]) {
            // TO-DO
            // 不支持的运营商类型
        }
        else {
            // TO-DO
            // 其他错误类型
        }
    }
}];
```
    
### 获取免密登录 token 并使用 token 获取用户登录信息
    
通过`requestTokenWithViewController:viewModel:completion:`获取免密登录token后, 在使用token获取用户登录信息。在此过程中, 需要设置`UIViewController`, 以展示授权页面, 并让**用户接受使用条款**

自定义部分见Demo和[接口文档](https://docs.geetest.com/onelogin/apirefer/api/ios/)
    
```objc
- (void)requestToken {
    OLAuthViewModel *viewModel = [[OLAuthViewModel alloc] init];
    // TO-DO 自定义viewModel
    // viewModel...
    
    [OneLogin requestTokenWithViewController:self viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
        NSLog(@"token result: %@", result);
        NSNumber *status = [result objectForKey:@"status"];
        if ([@(200) isEqualToNumber:status]) {
            // TO-DO
            // 获取到token, 并进行手机号查询
            NSString *processID = [result objectForKey:@"processID"];
            NSString *appID     = [result objectForKey:@"appID"];
            NSString *token     = [result objectForKey:@"token"];
            
            [self validateTokenAndGetLoginInfo:token appID:appID processID:processID];
        }
        else {
#warning 请处理获取token的错误, 更多错误码请参考错误码文档
            NSString *errCode   = [result objectForKey:@"errorCode"];
            NSString *msg       = [result objectForKey:@"msg"];
            NSString *processID = [result objectForKey:@"processID"];
            NSString *appID     = [result objectForKey:@"appID"];
            NSString *operator  = [result objectForKey:@"operatorType"];
            
            // 获取网关token失败
            if ([@"-20103" isEqualToString:errCode]) {
                // TO-DO
                // 重复调用 requestTokenWithViewController:viewModel:completion:
            }
            else if ([@"-20202" isEqualToString:errCode]) {
                // TO-DO
                // 检测到未开启蜂窝网络
            }
            else if ([@"-20203" isEqualToString:errCode]) {
                // TO-DO
                // 不支持的运营商类型
            }
            else if ([@"-20204" isEqualToString:errCode]) {
                // TO-DO
                // 未获取有效的 `accessCode`, 请确保先调用过 preGetTokenWithCompletion:
            }
            else if ([@"-20302" isEqualToString:errCode]) {
                // TO-DO
                // 用户点击了授权页面上的返回按钮, 授权页面将自动关闭
            }
            else if ([@"-20303" isEqualToString:errCode]) {
                // TO-DO
                // 用户点击了授权页面上的切换账号按钮, 授权页面不会自动给关闭。如需关闭, 需调用 [OneLogin dismissAuthViewController]。
            }
            else {
                // TO-DO
                // 其他错误类型
            }
            
            NSLog(@"[Operator: %@] - [Error Code: %@] - [Message: %@] - [ProccesID: %@] - [APPID: %@]", operator, errCode, msg, processID, appID);
            
            // 一键登录失败手动关闭授权页面
            [OneLogin dismissAuthViewController];
        }
    }];
}

// 使用token进行校验, 并获取用户的登录信息
- (void)validateTokenAndGetLoginInfo:(NSString *)token appID:(NSString *)appID processID:(NSString *)processID {
    
    // 根据用户自己接口构造
    // 下面以POST, application/json 为例
    NSURL *url = [NSURL URLWithString:@"---<您的校验接口地址>---"];
    
    NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(NSURLRequestCachePolicy)0 timeoutInterval:10.0];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:processID  forKey:@"process_id"];
    [params setValue:appID      forKey:@"id_2_sign"];
    [params setValue:token      forKey:@"token"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:(NSJSONWritingOptions)0 error:nil];
    
    mRequest.HTTPMethod = @"POST";
    mRequest.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:mRequest
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                     // TO-DO
                                     // 处理用户信息
                                     NSLog(@"result data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
    
}
```

> 更详细示例代码见 Demo
> 
> 更详细的接口说明见接口文档或 SDK 头文件


---
title: ios
type: ios
order: 0
---

[TOC]

# OneLogin

`OneLogin` 的主要外部调用接口

## Protocol

### userDidDismissAuthViewController

用户点击了授权页面的返回按钮

**Declaration**

```objc
- (void)userDidDismissAuthViewController;
```

### userDidSwitchAccount

用户点击了授权页面的"切换账户"按钮

**Declaration**

```objc
- (void)userDidSwitchAccount;
```

## Method

### currentNetworkInfo

获取当前 OneLogin 可用的网络信息

**Declaration**

```objc
+ (nullable OLNetworkInfo *)currentNetworkInfo;
```

**Discussion**

1. 当使用的是非移动、联通、电信三大运营商, 则返回nil。
2. OneLogin 仅在大陆支持移动、联通、电信三大运营商。

**Return Value**

描述当前可用的网络信息

**Seealso**

[OLNetworkInfo](#OLNetworkInfo)

### registerWithAppID:

向SDK注册AppID

**Declaration**

```objc
+ (void)registerWithAppID:(NSString *)appID;
```

**Parameters**

Param		|Description
----------|---------------	
appID 		|产品id, 请在官网注册获取

### setDelegate:

设置代理对象

**Declaration**

```objc
+ (void)setDelegate:(nullable id<OneLoginDelegate>)delegate;
```

**Parameters**

Param		|Description
----------|---------------	
delegate 	|代理对象

### setRequestTimeout:

设置请求超时时长。默认8秒。

**Declaration**

```objc
+ (void)setRequestTimeout:(NSTimeInterval)timeout;
```

**Parameters**

Param		|Description
----------|---------------	
timeout 	|请求超时的时长

### preGetTokenWithCompletion:

预取号接口

**Declaration**

```objc
+ (void)preGetTokenWithCompletion:(void(^)(NSDictionary *sender))completion;
```

**Parameters**

Param		|Description
----------|---------------	
completion|预取号的处理回调

**Discussion**

调用限制说明: 在调用该方法后, 未回调之前, 再次调用该方法时, 方法会直接跳出, 不执行预取号逻辑, 并返回相关错误。

预取号成功后的有效期说明: 有效期内需要调用 `requestTokenWithViewController:viewModel:completion:`,
 否则需要重新访问 `preGetTokenWithCompletion:`。 其中中国移动有效期为 1 小时,
 中国联通和中国电信为 10 分钟。

回调返回数据示例:

```
 // 成功的返回格式
 {
 status = 200; // NSNumber, 200为成功的状态码
 processID = 47dab9b7c26629cd9bc117f88e2f9233; // NSString, 流水号
 appID = 2**************************d; // NSString, 产品ID
 operatorType = CU; // NSString, 运营商类型(CM/CU/CT)
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 相关的描述消息
 }
 
 // 失败的返回格式
 {
 status = 500; // NSNumber, 500为失败的状态码
 processID = 47dab9b7c26629********f88e2f9233; // NSString, 流水号
 appID = 2**************************d; // NSString, 产品ID
 operatorType = CT; // NSString, 运营商类型(CM/CU/CT)
 errorCode = -30003, // NSNumber, 当运营商不成功时的错误码
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 相关的描述消息
 }
```

### requestTokenWithViewController:viewModel:completion:

取号接口

**Declaration**

```objc
+ (void)requestTokenWithViewController:(UIViewController *)viewController viewModel:(nullable OLAuthViewModel *)viewModel completion:(void(^)(NSDictionary * _Nullable result))completion;
```

**Parameters**

Param		|Description
----------|---------------	
viewController|视图控制器
viewModel	|自定义的试图模型
completion|取号接口的处理回调

**Discussion**

调用限制说明: 为避免授权页面多次弹出, 在调用该方法后, 授权页面弹出后, 再次调用该方法时, 该方法会直接跳出, 不执行授权逻辑。

需要用户在弹出的页面上同意服务意条款后, 才会进行免密认证。

授权页面弹出后, 需要手动调用`[OneLogin dismissAuthViewController];`关闭`OLAuthViewContorller`。

token有效期: 中国移动的有效期为 2 分钟，中国联通的为 30 分钟，中国电信的为 30 天。

回调返回数据示例:

```
 // 成功返回的格式:
 {
 status = 200; // NSNumber, 200为成功的状态码
 processID = 47dab9b7c26629cd9bc117********33; // NSString, 流水号
 appID = 2**************************d; // NSString, 产品ID
 token = 62718774ad1247188bc678********d3; // NSString, 运营商返回的accessToken, 用于查询真实的本机号
 operatorType = CU; // NSString, 运营商类型(CM/CU/CT)
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 运营商返回的Msg
 }
 
 // 失败返回的格式
 {
 status = 500; // NSNumber, 500为失败的状态码
 processID = 47dab9b7c26629cd9bc117********33; // NSString, 流水号
 appID = 2**************************d; // NSString, 产品ID
 operatorType = CT; // NSString, 运营商类型(CM/CU/CT)
 errorCode = -30003, // NSNumber, 运营商返回的错误码
 msg = "\U83b7\U53d6accessCode\U6210\U529f"; // NSString, 相关的描述消息
 }
```

### dismissAuthViewController

关闭当前的授权页面

**Declaration**

```objc
+ (void)dismissAuthViewController:(void (^ __nullable)(void))completion;
```

**Discussion**

请不要使用其他方式关闭授权页面, 否则可能导致 OneLogin 无法再次调起

### sdkVersion

获取SDK版本号

**Declaration**

```objc
+ (NSString *)sdkVersion;
```

**Return Value**

当前的SDK版本号

### setLogEnabled:

关闭日志

**Declaration**

```objc
+ (void)setLogEnabled:(BOOL)enabled;
```

**Parameters**

Param		|Description
----------|---------------	
enabled 	|YES，允许打印日志 NO，禁止打印日志

**Discussion**

OneLogin SDK内部的日志可以通过 `👁‍🗨[OneLoginSDK]👁‍🗨` 来筛选

**Return Value**

当前的SDK版本号

### isLogEnabled

获取日志开关状态

**Declaration**

```objc
+ (BOOL)isLogEnabled;
```

**Return Value**

YES，允许打印日志 NO，禁止打印日志

# OLAuthViewModel

授权页面自定义UI模型

## Enum

### OLRect

布局结构体

**Declaration**

```objc
typedef struct OLRect {
    /**
     竖屏时
     导航栏隐藏时，为控件顶部到状态栏的距离；导航栏显示时，为控件顶部到导航栏底部的距离
     弹窗时
     为控件顶部到弹窗顶部的距离
     */
    CGFloat portraitTopYOffset;
    
    /**
     竖屏时
     控件的x轴中点到屏幕x轴中点的距离，默认为0
     弹窗时
     控件的x轴中点到弹窗x轴中点的距离，默认为0
     */
    CGFloat portraitCenterXOffset;
    
    /**
     竖屏时
     控件的左边缘到屏幕左边缘的距离，默认为0
     弹窗时
     控件的左边缘到屏幕左边缘的距离，默认为0
     
     portraitLeftXOffset与portraitCenterXOffset设置一个即可，portraitLeftXOffset优先级大于portraitCenterXOffset，
     设置此属性时，portraitCenterXOffset属性失效
     */
    CGFloat portraitLeftXOffset;
    
    /**
     横屏时
     导航栏隐藏时，为控件顶部到屏幕顶部的距离；导航栏显示时，为控件顶部到导航栏底部的距离
     弹窗时
     为控件顶部到弹窗顶部的距离
     */
    CGFloat landscapeTopYOffset;
    
    /**
     横屏时
     控件的x轴中点到屏幕x轴中点的距离，默认为0
     弹窗时
     控件的x轴中点到弹窗x轴中点的距离，默认为0
     */
    CGFloat landscapeCenterXOffset;
    
    /**
     横屏时
     控件的左边缘到屏幕左边缘的距离，默认为0
     弹窗时
     控件的左边缘到屏幕左边缘的距离，默认为0
     
     landscapeLeftXOffset与landscapeCenterXOffset设置一个即可，landscapeLeftXOffset优先级大于landscapeCenterXOffset，
     设置此属性时，landscapeCenterXOffset属性失效
     */
    CGFloat landscapeLeftXOffset;
    
    /**
     控件大小，只有宽度、高度同时大于0，设置的size才会生效，否则为控件默认的size
     */
    CGSize size;
} OLRect;
```

**Discussion**

1. 若授权页面只支持竖屏，只设置竖屏方向偏移；
2. 若授权页面只支持横屏，只设置横屏方向偏移；
3. 若授权页面支持旋转自动切换横竖屏，则同时设置竖屏方向和横屏方向偏移；
4. 弹窗模式，同以上1、2、3；
5. size默认都可以不用设置，会根据字体大小自适应；
6. x轴方向偏移量有两个值可以设置，portraitCenterXOffset为控件的x轴中点到弹窗x轴中点的距离，portraitLeftXOffset为控件的左边缘到屏幕左边缘的距离，两者选其一即可。

### OLAuthPopupAnimationStyle

弹窗模式时支持的动画类型

**Declaration**

```objc
/**
 * @abstract 弹窗模式时支持的动画类型
 */
typedef NS_ENUM(NSInteger, OLAuthPopupAnimationStyle) {
    OLAuthPopupAnimationStyleCoverVertical = 0,
    OLAuthPopupAnimationStyleFlipHorizontal,
    OLAuthPopupAnimationStyleCrossDissolve,
    OLAuthPopupAnimationStyleCustom
};
```

### OLLoadingViewBlock

授权页自定义Loading的Block

**Declaration**

```objc
typedef void(^OLLoadingViewBlock)(UIView *containerView);
```

**Discussion**

授权页自定义Loading，会在点击登录按钮之后触发`containerView`为loading的全屏蒙版view。请自行在`containerView`添加自定义loading。设置block后，默认loading将无效。

### OLCustomUIHandler

授权登录页面自定义视图

**Declaration**

```objc
typedef void(^OLCustomUIHandler)(UIView *customAreaView);
```

**Discussion**

`customAreaView`为授权页面的 view，如，可将三方登录添加到授权登录页面

## Property

### statusBarStyle

状态栏样式。 默认 `UIStatusBarStyleDefault`。

**Declaration**

```objc
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
```

### naviTitle

授权页导航的标题。默认为空字符串。

**Declaration**

```objc
@property (nullable, nonatomic, strong) NSAttributedString *naviTitle;
```

### naviBgColor

授权页导航的背景颜色。默认白色。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIColor *naviBgColor;
```

### naviBackImage

授权页导航左边的返回按钮的图片。默认白色系统样式返回图片。尺寸约束为22x22。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIImage *naviBackImage;
```

### naviRightControl

授权页导航右边的自定义控件。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIView *naviRightControl;
```

### naviHidden

导航栏隐藏。默认不隐藏。

**Declaration**

```objc
@property (nonatomic, assign) BOOL naviHidden;
```

### backButtonRect

返回按钮位置及大小，返回按钮最大size为CGSizeMake(40, 40)。

**Declaration**

```objc
@property (nonatomic, assign) OLRect backButtonRect;
```

### backButtonHidden

返回按钮隐藏。默认不隐藏。

**Declaration**

```objc
@property (nonatomic, assign) OLRect backButtonHidden;
```

### appLogo

授权页面上展示的图标。默认为 "OneLogin" 图标。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIImage *appLogo;
```

### logoRect

Logo 位置及大小。

**Declaration**

```objc
@property (nonatomic, assign) OLRect logoRect;
```

### logoHidden

Logo 图片隐藏。默认不隐藏。

**Declaration**

```objc
@property (nonatomic, assign) BOOL logoHidden;
```

### phoneNumColor

号码预览文字的颜色。默认黑色。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIColor *phoneNumColor;
```

### phoneNumFont

号码预览文字的字体。默认粗体，24pt。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIFont *phoneNumFont;
```

### phoneNumRect

号码预览 位置及大小，电话号码不支持设置大小，大小根据电话号码文字自适应。

**Declaration**

```objc
@property (nonatomic, assign) OLRect phoneNumRect;
```

### switchButtonText

授权页切换账号按钮的文案。默认为“切换账号”。

**Declaration**

```objc
@property (nullable, nonatomic, copy) NSString *switchButtonText;
```

### switchButtonColor

授权页切换账号按钮的颜色。默认蓝色。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIColor *switchButtonColor;
```

### switchButtonFont

授权页切换账号的字体。默认字体，15pt。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIFont *switchButtonFont;
```

### switchButtonRect

授权页切换账号按钮 位置及大小。

**Declaration**

```objc
@property (nonatomic, assign) OLRect switchButtonRect;
```

### switchButtonHidden

隐藏切换账号按钮。默认不隐藏。

**Declaration**

```objc
@property (nonatomic, assign) BOOL switchButtonHidden;
```

### authButtonImages

授权页认证按钮的背景图片, @[正常状态的背景图片, 不可用状态的背景图片, 高亮状态的背景图片]。默认正常状态为蓝色纯色, 不可用状态的背景图片时为灰色, 高亮状态为灰蓝色。

**Declaration**

```objc
@property (nullable, nonatomic, strong) NSArray<UIImage *> *authButtonImages;
```

### authButtonTitle

授权按钮文案。默认白色的"一键登录"。

**Declaration**

```objc
@property (nullable, nonatomic, strong) NSAttributedString *authButtonTitle;
```

### authButtonRect

授权按钮 位置及大小。

**Declaration**

```objc
@property (nonatomic, assign) OLRect authButtonRect;
```

### sloganRect

Slogan 位置及大小。

**Declaration**

```objc
@property (nonatomic, assign) OLRect sloganRect;
```

### sloganTextColor

Slogan 文字颜色。默认灰色, 12pt。

**Declaration**

```objc
@property (nonatomic, strong) UIColor *sloganTextColor;
```

### sloganTextFont

Slogan字体。默认字体, 12pt。

**Declaration**

```objc
@property (nonatomic, strong) UIFont *sloganTextFont;
```

### defaultCheckBoxState

授权页面上条款勾选框初始状态。默认 YES。

**Declaration**

```objc
@property (nonatomic, assign) BOOL defaultCheckBoxState;
```

### checkedImage

授权页面上勾选框勾选的图标。默认为蓝色图标。推荐尺寸为12x12。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIImage *checkedImage;
```

### uncheckedImage

授权页面上勾选框未勾选的图标。默认为白色图标。推荐尺寸为12x12。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIImage *uncheckedImage;
```
### checkBoxSize

授权页面上条款勾选框大小。

**Declaration**

```objc
@property (nonatomic, assign) CGSize checkBoxSize;
```

### privacyTermsAttributes

隐私条款文字属性。默认基础文字灰色, 条款蓝色高亮, 12pt。

**Declaration**

```objc
@property (nullable, nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *privacyTermsAttributes;
```

### additionalPrivacyTerms

额外的条款。默认为空。

**Declaration**

```objc
@property (nullable, nonatomic, strong) NSArray<OLPrivacyTermItem *> *additionalPrivacyTerms;
```

**Seealso**

[OLPrivacyTermItem](#OLPrivacyTermItem)

### termTextColor

服务条款普通文字的颜色。默认灰色。

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIColor *termTextColor;
```

### termsRect

隐私条款 位置及大小，隐私条款，宽需大于50，高需大于20，才会生效。

**Declaration**

```objc
@property (nonatomic, assign) OLRect termsRect;
```

### customUIHandler

自定义区域视图的处理block

**Declaration**

```objc
@property (nullable, nonatomic, copy) OLCustomUIHandler customUIHandler;
```

**Discussion**

提供的视图容器使用NSLayoutConstraint与相关的视图进行布局约束。
如果导航栏没有隐藏, 顶部与导航栏底部对齐, 左边与屏幕左边对齐, 右边与屏幕右边对齐, 底部与屏幕底部对齐。
如果导航栏隐藏, 顶部与状态栏底部对齐, 左边与屏幕左边对齐, 右边与屏幕右边对齐, 底部与屏幕底部对齐。

**Seealso**

```objc
typedef void(^OLCustomUIHandler)(UIView *customAreaView);
```

### backgroundImage

授权页面背景图片

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIImage *backgroundImage;
```

### landscapeBackgroundImage

横屏模式授权页面背景图片

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIImage *landscapeBackgroundImage;
```

### supportedInterfaceOrientations

 授权页面支持的横竖屏方向

**Declaration**

```objc
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;
```

### isPopup

 是否为弹窗模式

**Declaration**

```objc
@property (nonatomic, assign) BOOL isPopup;
```

### popupRect

 弹窗 位置及大小。弹窗模式时，x轴偏移只支持portraitLeftXOffset和landscapeLeftXOffset

**Declaration**

```objc
@property (nonatomic, assign) OLRect popupRect;
```

### popupCornerRadius

 弹窗圆角，默认为6

**Declaration**

```objc
@property (nonatomic, assign) CGFloat popupCornerRadius;
```

### popupAnimationStyle

 弹窗动画类型，当popupAnimationStyle为OLAuthPopupAnimationStyleStyleCustom时，动画为用户自定义，用户需要传一个CATransition对象来设置动画

**Declaration**

```objc
@property (nonatomic, assign) OLAuthPopupAnimationStyle popupAnimationStyle;
```

### popupTransitionAnimation

 弹窗自定义动画

**Declaration**

```objc
@property (nonatomic, strong) CATransition *popupTransitionAnimation;
```

### closePopupImage

 弹窗关闭按钮图片，弹窗关闭按钮的尺寸跟图片尺寸保持一致。
 弹窗关闭按钮位于弹窗右上角，目前只支持设置其距顶部偏移和距右边偏移

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIImage *closePopupImage;
```

### closePopupTopOffset

 弹窗关闭按钮距弹窗顶部偏移

**Declaration**

```objc
@property (nonatomic, strong) NSNumber *closePopupTopOffset;
```

### closePopupRightOffset

 弹窗关闭按钮距弹窗右边偏移

**Declaration**

```objc
@property (nonatomic, strong) NSNumber *closePopupRightOffset;
```

### loadingViewBlock

 授权页面，点击登录按钮之后的回调

**Declaration**

```objc
@property (nonatomic, copy, nullable) OLLoadingViewBlock loadingViewBlock;
```

### webNaviHidden

 服务条款页面导航栏隐藏。默认不隐藏

**Declaration**

```objc
@property (nonatomic, assign) BOOL webNaviHidden;
```

### webNaviTitle

 服务条款页面导航的标题。默认为"服务条款"，粗体、17pt

**Declaration**

```objc
@property (nullable, nonatomic, strong) NSAttributedString *webNaviTitle;
```

### webNaviBgColor

 服务条款页面导航的背景颜色。默认白色

**Declaration**

```objc
@property (nullable, nonatomic, strong) UIColor *webNaviBgColor;
```

# OLNetworkInfo

## Enum

### OLNetworkType

设备网络的类型

**Declaration**

```objc
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
```

## Property

### carrierName

运营商名称

**Declaration**

```objc
@property (nullable, nonatomic, strong) NSString *carrierName;
```

### networkType

网络类型

**Declaration**

```objc
@property (nonatomic, assign) OLNetworkType networkType;
```

**Discussion**

即使返回非 `OLNetworkTypeNone`, 也可能因为终端用户未授权数据网络网络权限而无法访问设备的移动蜂窝数据网络

**Seealso**

[OLNetworkType](#OLNetworkType)

### detailNetworkType

具体的网络类型，如2G、3G、4G、WIFI

**Declaration**

```objc
@property (nonatomic, copy) NSString *detailNetworkType;
```

**Discussion**

即使返回非 `OLNetworkTypeNone`, 也可能因为终端用户未授权数据网络网络权限而无法访问设备的移动蜂窝数据网络

# OLPrivacyTermItem

隐私和条款条目

## Property

### termTitle

隐私和条款的标题

**Declaration**

```objc
@property (nonatomic, strong) NSString *termTitle;
```

### termTitle

隐私和条款的链接

**Declaration**

```objc
@property (nonatomic, strong) NSURL *termLink;
```

### index

条款索引，默认为0，当有多条条款时，会根据此属性升序排列条款

**Declaration**

```objc
@property (nonatomic, assign) NSInteger index;
```

## Method

### initWithTitle:linkURL:

使用标题和链接创建实例

**Declaration**

```objc
- (instancetype)initWithTitle:(NSString *)title linkURL:(NSURL *)url;
- (instancetype)initWithTitle:(NSString *)title linkURL:(NSURL *)url index:(NSInteger)index;
```

**Return Value**

返回新的`OLPrivacyTermItem`实例



---
title: ios
type: ios
order: 0
---

## 状态码

在返回中的`"status"`字段下的内容, 用于判断当前操作是否成功。

状态码 	|说明
------	|------
200	  	|操作成功
500	  	|操作失败

## 错误码

### `OneLogin`定义的业务错误码

在返回中的`"errorCode"`字段下的内容, 用于判断错误的类型。

错误码 	|说明
------	|----------
-20101       |未配置 AppID, 请先配置 AppID 。
-20102       |重复预取号。存在一次预取号操作未完成, 重复调用了`preGetTokenWithCompletion:`, 请稍后重试。
-20103       |重复取号。授权页面已调起, 重复调用`requestTokenWithViewController:viewModel:completion:`。
-20202       |当前可以访问的蜂窝数据网络, 请检查是否开启蜂窝网络。
-20203       |不支持的运营商。OneLogin 仅支持在大陆地区支持三大运营商
-20204			|无效的 `accessCode` 。确保每次调用 `requestTokenWithViewController:viewModel:completion:` 之前，都成功调用 `preGetTokenWithCompletion:`
-20302       |用户点击返回键并退出取号页面。授权页面会自动关闭。
-20303       |用户点击了切换账号按钮。授权页面不会自动关闭。
-40101       |移动运营商预取号失败。请检查数据网络可用性。
-40102       |移动运营商取号失败。请检查数据网络可用性。
-40198       |移动运营商预取号异常。请检查数据网络可用性。
-40199       |移动运营商取号异常。请检查数据网络可用性。
-40201       |联通运营商预取号失败。请检查数据网络可用性。
-40202       |联通运营商取号失败。请检查数据网络可用性。
-40298       |联通运营商预取号异常。请检查数据网络可用性。
-40299       |联通运营商取号异常。请检查数据网络可用性。
-40301       |电信运营商预取号失败。请检查数据网络可用性。
-40302       |电信运营商取号失败。请检查数据网络可用性。
-40398       |电信运营商预取号异常。请检查数据网络可用性。
-40399       |电信运营商取号异常。请检查数据网络可用性。
-50100       |OneLogin 服务接口返回异常
-50101       |OneLogin 服务返回业务失败
-50102       |OneLogin 服务接口网络异常。请检查网络可用性。

>无法使用数据网络(2G, 3G, 4G)的可能原因:
>1. 应用没有提供数据网络权限, 导致无法访问
>2. 手机卡欠费, 导致无法访问数据网络
>3. 所在区域的数据网络信号不佳, 导致访问超时
>4. 如果设备连接的数据网络自动降级了, 部分运营商对较旧的网络制式支持并不稳定
>5. 设备没有使用有效的 SIM 卡

### Cocoa 错误码参考

在 `metaData` 中可能含有Cocoa的错误码, 来自`NSURLErrorDomain`的错误

ErrorCode	|Description	
----------|------------	
-999		|`NSURLErrorCancelled`请求被取消
-1000		|`NSURLErrorBadURL`URL异常
-1001 		|`NSURLErrorTimedOut`请求超时	
-1002		|`NSURLErrorUnsupportedURL `不支持的URL
-1003		|`NSURLErrorCannotFindHost `无法找到主机
-1004		|`NSURLErrorCannotConnectToHost `无法连接到服务器
-1005		|`NSURLErrorNetworkConnectionLost `网络丢失, 一般弱网或者网络突然中断导致
-1006		|`NSURLErrorDNSLookupFailed `DNS查询失败
-1007		|`NSURLErrorHTTPTooManyRedirects `过多的请求跳转, 服务器返回过多的302
-1008		|`NSURLErrorResourceUnavailable `访问的资源不可用
-1009		|`NSURLErrorNotConnectedToInternet `未连接到互联网
-1010		|`NSURLErrorRedirectToNonExistentLocation `重定向到不存在的地址
-1011		|`NSURLErrorBadServerResponse `服务器无响应
-1012		|`NSURLErrorUserCancelledAuthentication `客户端取消了安全认证, 或者证书不匹配或服务端不支持ssl和tls
-1013		|`NSURLErrorUserAuthenticationRequired `客户端要求安全认证, 服务端不支持ssl或tls
-1014		|`NSURLErrorZeroByteResource `返回字节流为空
-1015		|`NSURLErrorCannotDecodeRawData `无法解析的原始数据
-1016		|`NSURLErrorCannotDecodeContentData `解析返回内容错误
-1017		|`NSURLErrorCannotParseResponse `无法解析响应体
-1102		|`NSURLErrorNoPermissionsToReadFile `无资源访问权限, 一般为`challenge`等参数有误, `challenge`只可被用来请求一次, 失效后可能会遇到该问题
-1200		|`NSURLErrorSecureConnectionFailed `创建安全连接失败
-1201		|`NSURLErrorServerCertificateHasBadDate `服务端证书异常
-1202		|`NSURLErrorServerCertificateUntrusted `服务端证书不可信
-1203		|`NSURLErrorServerCertificateHasUnknownRoot `服务端使用未知的根证书
