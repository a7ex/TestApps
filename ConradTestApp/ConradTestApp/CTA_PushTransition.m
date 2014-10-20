//
//  CTA_PushTransition.m
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "CTA_PushTransition.h"

@implementation CTA_PushTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:toVC.view];
    
    toVC.view.transform = CGAffineTransformMakeTranslation(toVC.view.frame.size.width, 0);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toVC.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
