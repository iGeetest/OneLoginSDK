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

@interface OLAgreementView : UITextView

- (void)updateTermItems:(NSArray<OLPrivacyTermItem *> *)termItems
          withTextColor:(UIColor *)textColor
              termsAttr:(NSDictionary<NSAttributedStringKey, id> *)termsAttr
  auxiliaryPrivacyWords:(NSArray<NSString *> *)auxiliaryPrivacyWords
          textAlignment:(NSTextAlignment)textAlignment;

@end

NS_ASSUME_NONNULL_END
