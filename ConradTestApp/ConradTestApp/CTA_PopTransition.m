//
//  CTA_PopTransition.m
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "CTA_PopTransition.h"

@implementation CTA_PopTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [transitionContext.containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromVC.view.transform = CGAffineTransformMakeTranslation(toVC.view.frame.size.width, 0);
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
