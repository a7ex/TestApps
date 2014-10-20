//
//  CTA_AsyncImageView.m
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "CTA_AsyncImageView.h"

@interface CTA_AsyncImageView ()

@property (strong, nonatomic) NSURLSessionTask *sessionTask;

@end

@implementation CTA_AsyncImageView

- (void)loadImageFromRemoteURL:(NSURL *)remoteURL callback:(void(^)(UIImage *result, NSError *error))callback
{
    UIActivityIndicatorView *activityIndicator = [self showActivityIndicator];
    [activityIndicator startAnimating];
    
    CTA_AsyncImageView *__weak weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:remoteURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    self.sessionTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        
        if (!error){
            [weakSelf setImage:[UIImage imageWithData:data]];
        }
        else{
            NSLog(@"Failed to load image from url:%@ with error:%@", remoteURL, error);
            [weakSelf setImage:nil];
        }
        [weakSelf setSessionTask:nil];
        
        if (callback)
            callback(weakSelf.image, error);
    }];
    [self.sessionTask resume];
}

- (UIActivityIndicatorView *)showActivityIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    [activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
    return activityIndicator;
}

@end
