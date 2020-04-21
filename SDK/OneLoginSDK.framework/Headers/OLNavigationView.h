//
//  OLNavigationView.h
//  OneLoginSDK
//
//  Created by NikoXu on 2019/3/29.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLAuthViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OLNavigationViewDelegate;

@interface OLNavigationView : UIView

@property (nonatomic, weak) id<OLNavigationViewDelegate> delegate;

- (void)updateText:(NSAttributedString *)text bgColor:(UIColor *)bgColor backBtnImage:(UIImage *)image control:(nullable UIView *)control;

- (void)updatePortraitConstraints:(OLRect)backButtonRect;
- (void)updateLandscapeConstraints:(OLRect)backButtonRect;

- (void)hide;
- (void)setBackButtonHidden:(BOOL)hidden;

@end

@protocol OLNavigationViewDelegate <NSObject>

- (void)userDidTouchBack;

@end

NS_ASSUME_NONNULL_END
