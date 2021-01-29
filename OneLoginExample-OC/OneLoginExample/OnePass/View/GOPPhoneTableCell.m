//
//  GOPPhoneTableCell.m
//  OneLoginSDK
//
//  Created by noctis on 2021/1/14.
//  Copyright © 2021 geetest. All rights reserved.
//

#import "GOPPhoneTableCell.h"
#import "UIView+GOPAutoLayout.h"

@interface GOPPhoneTableCell ()

@end

@implementation GOPPhoneTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addConstraint:[self.phoneLabel gopConstraintCenterXEqualToView:self.contentView]];
    [self.contentView addConstraint:[self.phoneLabel gopConstraintCenterYEqualToView:self.contentView]];
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.backgroundColor = [UIColor clearColor];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = [UIFont systemFontOfSize:18.f];
    }
    return _phoneLabel;
}

@end
