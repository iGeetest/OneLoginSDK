//
//  GOPAuthViewController.h
//  OneLoginSDK
//
//  Created by noctis on 2021/1/13.
//  Copyright © 2021 geetest. All rights reserved.
//

#import "BaseViewController.h"
#import "GOPAuthViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GOPAuthViewController : BaseViewController

@property (nonatomic, strong) GOPAuthViewModel *authViewModel;

@end

NS_ASSUME_NONNULL_END
