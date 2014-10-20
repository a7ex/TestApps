//
//  CTA_DetailVC.h
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTA_DataLoader.h"

@interface CTA_DetailVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) CTA_DataEntity *currentCountry;

@end
