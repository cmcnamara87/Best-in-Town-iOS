//
//  BiTBusiness.m
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTBusiness.h"
#import "BiTApiController.h"
#import "BiTCategory.h"

@implementation BiTBusiness
@synthesize businessId;
@synthesize cityId;
@synthesize businessName;
@synthesize address;
@synthesize lat;
@synthesize lon;
@synthesize phone;
@synthesize rankings;
@synthesize imageUrl;
@synthesize referenceId;
@synthesize dataSource;
@synthesize eloScore;
@synthesize hasDetails;
@synthesize rating;
@synthesize locality;
@synthesize modified;
@synthesize websiteUrl;
@synthesize categories;
@synthesize distance;
@synthesize selectedBusiness;


#pragma mark Class Methods
/**
 Get the best businesses in the city, for a particular category
 */
+ (void)getBestBusinessesForCategory:(int)categoryId 
                            inCity:(int)cityId
                         onSuccess:(void (^)(NSArray *businesses))success 
                           failure:(void (^)(NSError *error))failure 
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/businesses/type/best/category_id/%d/city_id/%d", categoryId, cityId];
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([BiTBusiness buildBusinessesFromData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

/**
 Get the best businesses that are nearby
 */
+ (void)getNearbyBestBusinessesInCity:(int)cityId 
                                atLat:(double)lat
                                  lon:(double)lon
                              radiusM:(int)radiusM
                        underCategory:(int)categoryId
                            onSuccess:(void (^)(NSString *address, NSArray *businesses))success 
                              failure:(void (^)(NSError *error))failure
{
    NSString *apiPath; 
    if(categoryId) {
        apiPath = [NSString stringWithFormat:@"index.php/api/businesses/type/explore/city_id/%d/lat/%f/lon/%f/radius_m/%d/category_id/%d", cityId, lat, lon, radiusM, categoryId];
    } else {
        apiPath = [NSString stringWithFormat:@"index.php/api/businesses/type/explore/city_id/%d/lat/%f/lon/%f/radius_m/%d", cityId, lat, lon, radiusM];
    }
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *address = [responseObject valueForKey:@"address"];
        
        success(address, [BiTBusiness buildBusinessesFromData:[responseObject valueForKey:@"businesses"]]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

+ (void)getNearbyAllBusinessesInCity:(int)cityId
                               atLat:(double)lat 
                                 lon:(double)lon 
                             radiusM:(int)radiusM
                           onSuccess:(void (^)(NSString *address, NSArray *businesses))success 
                             failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/businesses/type/nearby/city_id/%d/lat/%f/lon/%f/radius_m/%d", cityId, lat, lon, radiusM];
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *address = [responseObject valueForKey:@"address"];
        
        success(address, [BiTBusiness buildBusinessesFromData:[responseObject valueForKey:@"businesses"]]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}


+ (void)addRatingForBusiness:(int)businessId 
               verseBusiness:(int)businessId1 
                         won:(BOOL)won1 
                 andBusiness:(int)businessId2 
                         won:(BOOL)won2 
                     forUser:(int)userId
                   onSuccess:(void (^)(BiTBusiness *business))success 
                     failure:(void (^)(NSError *error))failure
{
    
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/rating"];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: 
                            [NSNumber numberWithInt:userId], @"user_id",
                            [NSNumber numberWithInt:businessId], @"business_id",
                            [NSNumber numberWithInt:businessId1], @"business_id_1",
                            [NSNumber numberWithInt:won1], @"won_1",
                            [NSNumber numberWithInt:businessId2], @"business_id_2",
                            [NSNumber numberWithInt:won2], @"won_2",
                            nil];
    
    [[BiTApiController sharedApi] postPath:apiPath parameters:params OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([BiTBusiness buildBusinessfromDict:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

+ (void)getBusinessesToRateForUser:(int)userId 
                         business:(int)businessId 
                        onSuccess:(void (^)(NSArray *businesses))success 
                          failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/businesses/type/rate/user_id/%d/business_id/%d", userId, businessId];
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([BiTBusiness buildBusinessesFromData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

/**
 Creates an array of BitBusiness objects for an array of business data
 */
+ (NSArray *)buildBusinessesFromData:(NSArray *)businessesData
{
    NSMutableArray *businessesArray = [NSMutableArray array];
    for(NSDictionary *businessData in businessesData) {
        BiTBusiness *business = [BiTBusiness buildBusinessfromDict:businessData];
        [businessesArray addObject:business];
    }
    return [businessesArray copy];
}



/**
 Creates a BitBusiness object for a Dictionary of data
 */
+ (BiTBusiness *)buildBusinessfromDict:(NSDictionary *)businessData
{
    NSLog(@"Adding business %@", businessData);
    BiTBusiness *business = [[BiTBusiness alloc] init];
    [business addData:businessData];
    return business;
}

#pragma mark Instance Methods
- (void)addData:(NSDictionary *)businessData {
    self.businessId = [(NSNumber*)[businessData objectForKey:@"id"] intValue];
    self.cityId = [(NSNumber*)[businessData objectForKey:@"city_id"] intValue];
    self.lat = [(NSNumber*)[businessData objectForKey:@"lat"] doubleValue];
    self.lon = [(NSNumber*)[businessData objectForKey:@"lon"] doubleValue];
    self.modified = [businessData objectForKey:@"modified"]; 
    self.businessName = [businessData objectForKey:@"name"];    
    if([businessData objectForKey:@"phone"] != [NSNull null]) {
        self.phone = [businessData objectForKey:@"phone"];
    }
    self.address = [businessData objectForKey:@"address"];
    if([businessData objectForKey:@"rating"] != 0) {
        self.rating = [(NSNumber*)[businessData objectForKey:@"rating"] intValue];
    }
    if([businessData objectForKey:@"website_url"] != [NSNull null]) {
        self.websiteUrl = [[NSURL alloc] initWithString:[businessData objectForKey:@"website_url"]];
    }
    if([businessData objectForKey:@"locality"] != [NSNull null]) {
        self.locality = [businessData objectForKey:@"locality"];
    }
    self.dataSource = [businessData objectForKey:@"data_source"];
    self.referenceId = [businessData objectForKey:@"reference_id"];
    self.hasDetails = (BOOL)[businessData objectForKey:@"has_details"];
    self.eloScore = [(NSNumber*)[businessData objectForKey:@"elo_score"] intValue];
    if([businessData objectForKey:@"distance"] != [NSNull null]) {
        self.distance = [(NSNumber*)[businessData objectForKey:@"distance"] floatValue];
    }
    
    NSMutableArray *categoryArray = [NSMutableArray array];
    for(NSDictionary *categoryData in [businessData objectForKey:@"categories"]) {
        BiTCategory *category = [[BiTCategory alloc] init];
        category.categoryId = [(NSNumber*)[categoryData objectForKey:@"id"] intValue];
        category.categoryName = [categoryData objectForKey:@"name"];
        if([categoryData objectForKey:@"image"] != [NSNull null]) {
            category.imageUrl = [[NSURL alloc] initWithString:[categoryData objectForKey:@"image"]];
        }
        if([categoryData objectForKey:@"parent_id"] != [NSNull null]) {
            category.parentId = [(NSNumber*)[categoryData objectForKey:@"parent_id"] intValue];
        }
        if([categoryData objectForKey:@"elo_score"] != [NSNull null]) {
            category.eloScore = [(NSNumber*)[categoryData objectForKey:@"elo_score"] intValue];
        }    
        if([categoryData objectForKey:@"rank"] != [NSNull null]) {
            category.rank = [(NSNumber*)[categoryData objectForKey:@"rank"] intValue];
        }
        [categoryArray addObject:category];
    }
    self.categories = [categoryArray copy];
}

@end
