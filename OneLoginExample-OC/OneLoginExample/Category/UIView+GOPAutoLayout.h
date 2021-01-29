#import <UIKit/UIKit.h>

@protocol GOPAutoLayout <NSObject>

- (void)addConstraints;

@end

@interface UIView (GOPAutoLayout)

// height
- (NSLayoutConstraint *)gopConstraintHeight:(CGFloat)height;
- (NSLayoutConstraint *)gopConstraintHeightEqualToView:(UIView *)view;

// width
- (NSLayoutConstraint *)gopConstraintWidth:(CGFloat)width;
- (NSLayoutConstraint *)gopConstraintWidthEqualToView:(UIView *)view;

// center
- (NSLayoutConstraint *)gopConstraintCenterXEqualToView:(UIView *)view;
- (NSLayoutConstraint *)gopConstraintCenterYEqualToView:(UIView *)view;

// top, bottom, left, right
- (NSArray *)gopConstraintsTop:(CGFloat)top fromView:(UIView *)view;
- (NSArray *)gopConstraintsBottom:(CGFloat)bottom fromView:(UIView *)view;
- (NSArray *)gopConstraintsLeft:(CGFloat)left fromView:(UIView *)view;
- (NSArray *)gopConstraintsRight:(CGFloat)right fromView:(UIView *)view;

- (NSArray *)gopConstraintsTopInContainer:(CGFloat)top;
- (NSArray *)gopConstraintsBottomInContainer:(CGFloat)bottom;
- (NSArray *)gopConstraintsLeftInContainer:(CGFloat)left;
- (NSArray *)gopConstraintsRightInContainer:(CGFloat)right;

- (NSLayoutConstraint *)gopConstraintTopEqualToView:(UIView *)view;
- (NSLayoutConstraint *)gopConstraintBottomEqualToView:(UIView *)view;
- (NSLayoutConstraint *)gopConstraintLeftEqualToView:(UIView *)view;
- (NSLayoutConstraint *)gopConstraintRightEqualToView:(UIView *)view;

// size
- (NSArray *)gopConstraintsSize:(CGSize)size;
- (NSArray *)gopConstraintsSizeEqualToView:(UIView *)view;

// imbue
- (NSArray *)gopConstraintsFillWidth;
- (NSArray *)gopConstraintsFillHeight;
- (NSArray *)gopConstraintsFill;

// assign
- (NSArray *)gopConstraintsAssignLeft;
- (NSArray *)gopConstraintsAssignRight;
- (NSArray *)gopConstraintsAssignTop;
- (NSArray *)gopConstraintsAssignBottom;

@end
