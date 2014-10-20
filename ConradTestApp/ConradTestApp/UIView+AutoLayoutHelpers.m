//
//  UIView+AutoLayoutHelpers.m
//
//  Created by alex da franca on 05/02/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "UIView+AutoLayoutHelpers.h"

@implementation UIView (AutoLayoutHelpers)

- (NSArray *)ffs_constraintsAttached
{
    NSMutableArray *constrs = [[NSMutableArray alloc] init];
    UIView *parentView = self.superview;
    while (parentView) {
        NSArray *superViewConstraints = [parentView constraints];
        for (NSLayoutConstraint *thisConstraint in superViewConstraints) {
            if (thisConstraint.firstItem == self || thisConstraint.secondItem == self) {
                [constrs addObject:thisConstraint];
            }
        }
        parentView = parentView.superview;
    }
    return [NSArray arrayWithArray:constrs];
}

- (NSLayoutConstraint *)ffs_layoutConstraintWithAttribute:(NSLayoutAttribute)layoutAttribute
{
    if (layoutAttribute == NSLayoutAttributeHeight || layoutAttribute == NSLayoutAttributeWidth) {
        for (NSLayoutConstraint *thisConstraint in [self constraints]) {
            if (thisConstraint.firstItem == self){
                if (thisConstraint.firstAttribute == layoutAttribute)
                    return thisConstraint;
            }
        }
    }
    
    UIView *parentView = self.superview;
    while (parentView) {
        for (NSLayoutConstraint *thisConstraint in [parentView constraints]) {
            if (thisConstraint.firstItem == self && thisConstraint.firstAttribute == layoutAttribute)
                return thisConstraint;
            if (thisConstraint.secondItem == self && thisConstraint.secondAttribute == layoutAttribute)
                return thisConstraint;
        }
        parentView = parentView.superview;
    }
    
    return nil;
}

- (void)ffs_removeLayoutConstraintWithAttribute:(NSLayoutAttribute)layoutAttribute
{
    if (layoutAttribute == NSLayoutAttributeHeight || layoutAttribute == NSLayoutAttributeWidth) {
        for (NSLayoutConstraint *thisConstraint in [self constraints]) {
            if (thisConstraint.firstItem == self){
                if (thisConstraint.firstAttribute == layoutAttribute){
                    [self removeConstraint:thisConstraint];
                    return;
                }
            }
        }
    }
    
    UIView *parentView = self.superview;
    while (parentView) {
        for (NSLayoutConstraint *thisConstraint in [parentView constraints]) {
            if (thisConstraint.firstItem == self && thisConstraint.firstAttribute == layoutAttribute){
                [parentView removeConstraint:thisConstraint];
                return;
            }
            if (thisConstraint.secondItem == self && thisConstraint.secondAttribute == layoutAttribute){
                [parentView removeConstraint:thisConstraint];
                return;
            }
        }
        parentView = parentView.superview;
    }
}

- (UIEdgeInsets)ffs_edgeInsetsToParentView
{
    if (!self.superview)
        return UIEdgeInsetsZero;
    
    CGFloat left = self.frame.origin.x;
    CGFloat top = self.frame.origin.y;
    CGFloat right = self.superview.frame.size.width - left - self.frame.size.width;
    CGFloat bottom = self.superview.frame.size.height - top - self.frame.size.height;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (UIEdgeInsets)ffs_edgeInsetsToView:(UIView *)referenceView
{
    if (!self.superview)
        return UIEdgeInsetsZero;
    
    CGRect translatedRect = [self.superview convertRect:self.frame toView:referenceView];
    CGFloat left = translatedRect.origin.x;
    CGFloat top = translatedRect.origin.y;
    CGFloat right = referenceView.frame.size.width - left - translatedRect.size.width;
    CGFloat bottom = referenceView.frame.size.height - top - translatedRect.size.height;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (void)ffs_addSubview:(UIView *)subViewToAdd withEdgeInsets:(UIEdgeInsets)edgeInsets
{
    [self addSubview:subViewToAdd];
    
    NSDictionary *metrics = @{@"left":@(edgeInsets.left), @"top":@(edgeInsets.top), @"right":@(edgeInsets.right), @"bottom":@(edgeInsets.bottom)};
    NSDictionary *views = NSDictionaryOfVariableBindings(subViewToAdd);
    //    NSDictionary *views = @{@"subViewToAdd":subViewToAdd};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[subViewToAdd]-(right)-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[subViewToAdd]-(bottom)-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:metrics
                                                                   views:views]];
}

- (void)ffs_hideViewBySettingHeightConstraintToZero
{
    NSLayoutConstraint *constr = [self ffs_layoutConstraintWithAttribute:NSLayoutAttributeHeight];
    constr.constant = 0.0;
    constr = [self ffs_layoutConstraintWithAttribute:NSLayoutAttributeBottom];
    constr.constant = 0.0;
}
@end
