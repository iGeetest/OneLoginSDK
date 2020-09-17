//
//  ResultViewController.h
//  OneLoginExample
//
//  Created by 刘练 on 2020/2/3.
//  Copyright © 2020 geetest. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ResultVCDelegate;

@interface ResultViewController : BaseViewController

@property (nonatomic, weak) id<ResultVCDelegate> delegate;

@end

@protocol ResultVCDelegate <NSObject>

@required
- (void)resultVCDidReturn;

@end

NS_ASSUME_NONNULL_END
