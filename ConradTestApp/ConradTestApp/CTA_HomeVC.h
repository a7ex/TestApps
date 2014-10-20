//
//  CTA_HomeVC.h
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTA_NavigationProtocol <NSObject>

- (UIViewController *)navigateToController;

@end

@interface CTA_HomeVC : UIViewController <CTA_NavigationProtocol>

@end
