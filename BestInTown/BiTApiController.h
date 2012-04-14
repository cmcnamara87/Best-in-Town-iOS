//
//  BiTApiController.h
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kApiBase @"http://bestintown.co/"

@class AFHTTPRequestOperation;
@interface BiTApiController : NSObject

+ (BiTApiController *)sharedApi;

- (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
