//
//  BiTApiController.m
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTApiController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@interface BiTApiController ()

@property (nonatomic, strong) AFHTTPClient *httpClient;
@end

@implementation BiTApiController
@synthesize httpClient;

+ (BiTApiController *)sharedApi
{
    static BiTApiController *instance;
    if (!instance) {
        // Make sure we have a AFHttpClient before anybody tries to use the API.
        instance = [[BiTApiController alloc] init];
//        instance.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kApiBase]];
        instance.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kApiBaseOnline]];
        [instance.httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [instance.httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return instance;
}

- (void)getPath:(NSString *)path 
     parameters:(NSDictionary *)parameters
      OnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure 
{
    
    NSLog(@"URL %@", path);
    NSLog(@"Params: %@", parameters);
    [httpClient getPath:path parameters:parameters success:success failure:failure];
}

- (void)postPath:(NSString *)path 
      parameters:(NSDictionary *)parameters 
       OnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"URL %@", path);
    NSLog(@"Params: %@", parameters);
    [httpClient postPath:path parameters:parameters success:success failure:failure];
}

/**
    Get all the categories
 */
- (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [httpClient getPath:@"/api/categories" parameters:nil success:success failure:failure];
}

/** 
    Get the top ten list for a category and city
 */
- (void)getBusinessListForCategory:(NSString *)categoryId 
                            inCity:(NSString *)cityId
                         onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"/api/topten/category/%@/cityid/%@", categoryId, cityId];
    NSLog(@"apiPath: http://bestintown.co%@", apiPath);
    [httpClient getPath:apiPath parameters:nil success:success failure:failure];
}

@end
