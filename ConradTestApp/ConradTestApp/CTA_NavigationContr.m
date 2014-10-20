//
//  CTA_NavigationContr.m
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "CTA_NavigationContr.h"

#import "CTA_HomeVC.h"
#import "CTA_PushTransition.h"
#import "CTA_PopTransition.h"

@interface CTA_NavigationContr () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactivePercTransition;
@property (strong, nonatomic) UIPanGestureRecognizer *interactiveGestureRecognizer;

@end

@implementation CTA_NavigationContr

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // setup pan gesture recognizer and attach it to this naviogation controllers view;
        self.interactiveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        self.interactiveGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:self.interactiveGestureRecognizer];
        
        self.interactivePopGestureRecognizer.delegate = self;
        
        // register as animation controller provider:
        self.delegate = self;
    }
    return self;
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    switch (operation){
        
        case UINavigationControllerOperationPush:
            return [[CTA_PushTransition alloc] init];
            break;
            
        case UINavigationControllerOperationPop:
            return [[CTA_PopTransition alloc] init];
            break;
            
        default:
            break;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactivePercTransition;
}

#pragma mark - UIGestureRecognizer

- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat percentDone = ABS(translation.x / recognizer.view.frame.size.width);
    
    UIViewController <CTA_NavigationProtocol> *topVC;
    
    switch (recognizer.state){
            
        case UIGestureRecognizerStateBegan:
            
            if (translation.x < 0) {
                if ([self.viewControllers count] < 2) {
                    topVC = (UIViewController <CTA_NavigationProtocol> *)self.topViewController;
                    if ([topVC conformsToProtocol:@protocol(CTA_NavigationProtocol)]){
                        self.interactivePercTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
                        [self pushViewController:[topVC navigateToController] animated:YES];
                    }
                }
            }
            else if (translation.x > 0) {
                if ([self.viewControllers count] > 1) {
                    self.interactivePercTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
                    [self popViewControllerAnimated:YES];
                }
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.interactivePercTransition updateInteractiveTransition:percentDone];
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
            if (percentDone > 0.3)
                [self.interactivePercTransition finishInteractiveTransition];
            else
                [self.interactivePercTransition cancelInteractiveTransition];
            
            self.interactivePercTransition = nil;
            break;
            
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.transitionCoordinator isAnimated])
        return NO;
    
    if (gestureRecognizer == self.interactiveGestureRecognizer)
        return YES;
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer)
        return YES;
    
    return NO;
}



/* Instead of having this navigationcontroller "decide" the statusbar appearance for all its viewcontroller stack
 we rather forward the events to the current visible view controller */

-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}

-(UIViewController *)childViewControllerForStatusBarHidden
{
    return self.visibleViewController;
}

@end
