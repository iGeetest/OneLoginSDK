//
//  OLAgreementView.h
//  OneLoginSDK
//
//  Created by NikoXu on 2019/6/11.
//  Copyright © 2019 geetest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLPrivacyTermItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OLAgreementViewDelegate;

@interface OLAgreementView : UITextView

@property (nonatomic, weak) id<OLAgreementViewDelegate> agreementDelegate;

- (void)updateTermItems:(NSArray<OLPrivacyTermItem *> *)termItems
          withTextColor:(UIColor *)textColor
              termsAttr:(NSDictionary<NSAttributedStringKey, id> *)termsAttr
  auxiliaryPrivacyWords:(NSArray<NSString *> *)auxiliaryPrivacyWords
          textAlignment:(NSTextAlignment)textAlignment;

@end

@protocol OLAgreementViewDelegate <NSObject>

- (BOOL)agreementView:(OLAgreementView *)agreementView shouldInteractWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
