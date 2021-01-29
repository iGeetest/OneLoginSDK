#import "UIView+GOPAutoLayout.h"

@implementation UIView (GOPAutoLayout)

- (NSLayoutConstraint *)gopConstraintHeight:(CGFloat)height {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:height];
}

- (NSLayoutConstraint *)gopConstraintWidth:(CGFloat)width {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:width];
}

- (NSLayoutConstraint *)gopConstraintCenterXEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)gopConstraintCenterYEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)gopConstraintHeightEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)gopConstraintWidthEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
}

- (NSArray *)gopConstraintsTop:(CGFloat)top fromView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(top)-[selfView]" options:0 metrics:@{@"top":@(top)} views:NSDictionaryOfVariableBindings(view, selfView)];
}

- (NSArray *)gopConstraintsBottom:(CGFloat)bottom fromView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[selfView]-(bottom)-[view]" options:0 metrics:@{@"bottom":@(bottom)} views:NSDictionaryOfVariableBindings(selfView, view)];
}

- (NSArray *)gopConstraintsLeft:(CGFloat)left fromView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[selfView]-(left)-[view]" options:0 metrics:@{@"left":@(left)} views:NSDictionaryOfVariableBindings(selfView, view)];
}

- (NSArray *)gopConstraintsRight:(CGFloat)right fromView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(right)-[selfView]" options:0 metrics:@{@"right":@(right)} views:NSDictionaryOfVariableBindings(view, selfView)];
}

- (NSArray *)gopConstraintsSizeEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return @[
        [self gopConstraintHeightEqualToView:view],
        [self gopConstraintWidthEqualToView:view]
    ];
}

- (NSArray *)gopConstraintsSize:(CGSize)size {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return @[
        [self gopConstraintHeight:size.height],
        [self gopConstraintWidth:size.width]
    ];
}

- (NSArray *)gopConstraintsFillWidth {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[selfView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)gopConstraintsFillHeight {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[selfView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)gopConstraintsFill {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *resultConstraints = [[NSMutableArray alloc] initWithArray:[self gopConstraintsFillWidth]];
    [resultConstraints addObjectsFromArray:[self gopConstraintsFillHeight]];
    return [NSArray arrayWithArray:resultConstraints];
}

- (NSArray *)gopConstraintsAssignLeft {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self gopConstraintsLeftInContainer:0];
}

- (NSArray *)gopConstraintsAssignRight {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self gopConstraintsRightInContainer:0];
}

- (NSArray *)gopConstraintsAssignTop {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self gopConstraintsTopInContainer:0];
}

- (NSArray *)gopConstraintsAssignBottom {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [self gopConstraintsBottomInContainer:0];
}

- (NSArray *)gopConstraintsTopInContainer:(CGFloat)top {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selfView]" options:0 metrics:@{@"top":@(top)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)gopConstraintsBottomInContainer:(CGFloat)bottom {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:[selfView]-(bottom)-|" options:0 metrics:@{@"bottom":@(bottom)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)gopConstraintsLeftInContainer:(CGFloat)left {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[selfView]" options:0 metrics:@{@"left":@(left)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSArray *)gopConstraintsRightInContainer:(CGFloat)right {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *selfView = self;
    return [NSLayoutConstraint constraintsWithVisualFormat:@"H:[selfView]-(right)-|" options:0 metrics:@{@"right":@(right)} views:NSDictionaryOfVariableBindings(selfView)];
}

- (NSLayoutConstraint *)gopConstraintTopEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)gopConstraintBottomEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)gopConstraintLeftEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
}

- (NSLayoutConstraint *)gopConstraintRightEqualToView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
}

@end
