//
//  CTA_DataLoader.h
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTA_DataEntity : NSObject

@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSNumber *population;
@property (assign, nonatomic) NSInteger rank;

@end

@interface CTA_DataLoader : NSObject

@property (strong, nonatomic) NSURL *remoteURL;
@property (assign, nonatomic) NSInteger currentEntityIndex;

- (BOOL)loadJSONFromRemoteURL:(NSURL *)remoteURL callback:(void(^)(NSArray *result, NSError *error))callback;

- (NSArray *)allEntities;
- (NSUInteger)totalNumberOfEntities;
- (CTA_DataEntity *)firstEntity;
- (CTA_DataEntity *)lastEntity;
- (CTA_DataEntity *)nextEntity;
- (CTA_DataEntity *)previousEntity;
- (CTA_DataEntity *)randomEntity;

@end
