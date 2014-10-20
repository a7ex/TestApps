//
//  UIView+AutoLayoutHelpers.m
//
//  Created by alex da franca on 05/02/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayoutHelpers)

- (NSArray *)ffs_constraintsAttached;
- (NSLayoutConstraint *)ffs_layoutConstraintWithAttribute:(NSLayoutAttribute)layoutAttribute;
- (void)ffs_removeLayoutConstraintWithAttribute:(NSLayoutAttribute)layoutAttribute;
- (UIEdgeInsets)ffs_edgeInsetsToParentView;
- (UIEdgeInsets)ffs_edgeInsetsToView:(UIView *)referenceView;

- (void)ffs_addSubview:(UIView *)subViewToAdd withEdgeInsets:(UIEdgeInsets)edgeInsets;

- (void)ffs_hideViewBySettingHeightConstraintToZero;

@end
