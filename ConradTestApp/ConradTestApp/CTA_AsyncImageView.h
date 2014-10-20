//
//  CTA_AsyncImageView.h
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTA_AsyncImageView : UIImageView

- (void)loadImageFromRemoteURL:(NSURL *)remoteURL callback:(void(^)(UIImage *result, NSError *error))callback;

@end
