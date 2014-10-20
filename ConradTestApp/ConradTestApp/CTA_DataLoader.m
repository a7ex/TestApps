//
//  CTA_DataLoader.m
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "CTA_DataLoader.h"

@implementation CTA_DataEntity

@end


@interface CTA_DataLoader ()

@property (strong, nonatomic) NSURLSessionTask *sessionTask;
@property (strong, nonatomic) NSArray *entities;
@property (strong, nonatomic) NSError *lastError;

@end

@implementation CTA_DataLoader

- (BOOL)loadJSONFromRemoteURL:(NSURL *)remoteURL callback:(void(^)(NSArray *result, NSError *error))callback
{
    if (self.sessionTask)
        return NO;
    
    if ([[self.remoteURL absoluteString] isEqualToString:[remoteURL absoluteString]]) {
        callback([self allEntities], self.lastError);
        return YES;
    }
    
    self.remoteURL = remoteURL;
    NSAssert(callback, @"Please provide a block for the result of the operation!");
    
    [self setEntities:nil];
    
    CTA_DataLoader *__weak weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:remoteURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    self.sessionTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.entities = @[];
        if (!error) {
            [weakSelf processRemoteResult:data];
            callback([weakSelf allEntities], error);
        }
        else{
            callback(nil, error);
        }
        [self setSessionTask:nil];
    }];
    
    [self.sessionTask resume];
    return YES;
}

- (NSArray *)allEntities
{
    return self.entities;
}

- (NSUInteger)totalNumberOfEntities
{
    return [[self allEntities] count];
}

- (CTA_DataEntity *)firstEntity
{
    self.currentEntityIndex = -1;
    
    if ([self totalNumberOfEntities] < 1)
        return nil;
    
    self.currentEntityIndex = 0;
    return [[self allEntities] objectAtIndex:self.currentEntityIndex];
}

- (CTA_DataEntity *)lastEntity
{
    self.currentEntityIndex = -1;
    
    if ([self totalNumberOfEntities] < 1)
        return nil;
    
    self.currentEntityIndex = [self totalNumberOfEntities] - 1;
    return [[self allEntities] objectAtIndex:self.currentEntityIndex];
}

- (CTA_DataEntity *)nextEntity
{
    if (![self totalNumberOfEntities] > (self.currentEntityIndex + 1))
        return nil;
    
    self.currentEntityIndex++;
    return [[self allEntities] objectAtIndex:self.currentEntityIndex];
}

- (CTA_DataEntity *)previousEntity
{
    if ((self.currentEntityIndex - 1) < 0)
        return nil;
    
    self.currentEntityIndex--;
    return [[self allEntities] objectAtIndex:self.currentEntityIndex];
}

- (CTA_DataEntity *)randomEntity
{
    self.currentEntityIndex = -1;
    
    if ([self totalNumberOfEntities] < 1)
        return nil;
    
    self.currentEntityIndex = arc4random() % [self totalNumberOfEntities];
    return [[self allEntities] objectAtIndex:self.currentEntityIndex];
}


#pragma mark - private interface

- (void)processRemoteResult:(NSData *)inputData
{
    if (inputData) {
        
        NSError *__autoreleasing err;
        id object = [NSJSONSerialization JSONObjectWithData:inputData options:NSJSONReadingAllowFragments error:&err];
        
        if (!err) {
            
            NSArray *objects = [self arrayFromJSONResult:object];
            
            if (objects) {
                
                CTA_DataEntity *thisEntity;
                NSMutableArray *entities = [[NSMutableArray alloc] init];
                for (NSDictionary *thisObject in objects) {
                    if ([thisObject isKindOfClass:[NSDictionary class]]) {
                        thisEntity = [[CTA_DataEntity alloc] init];
                        thisEntity.country = [thisObject objectForKey:@"country"]?:@"";
                        thisEntity.imageURL = [thisObject objectForKey:@"flag"]?:@"";
                        thisEntity.population = [thisObject objectForKey:@"population"]?:@(0);
                        thisEntity.rank = [[thisObject objectForKey:@"rank"] integerValue];
                        [entities addObject:thisEntity];
                    }
                }
                self.entities = [NSArray arrayWithArray:entities];
                
            }
        }
    }
}

// try to get an array of objects from the json result

- (NSArray *)arrayFromJSONResult:(id)jsonResult
{
    if ([jsonResult isKindOfClass:[NSArray class]])
        return jsonResult;
    
    // if it is not an Array, it must be a dictionary and we just get the first child of type array;
    
    NSArray *objects = [jsonResult allValues];
    
    if (![objects count] > 0)
        return nil;
    
    for (NSArray *thisArray in objects) {
        if ([thisArray isKindOfClass:[NSArray class]])
            return thisArray;
    }
    
    return nil;
}


@end
