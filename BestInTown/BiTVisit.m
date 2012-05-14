//
//  BiTVisit.m
//  BestInTown
//
//  Created by Craig McNamara on 6/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTVisit.h"
#import "BiTApiController.h"

@implementation BiTVisit
@synthesize  businessId, visitId, visitDate, userId, businessName, userName;

+ (void)getAllVisitsOnSuccess:(void (^)(NSArray *visits))success 
                      failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/visits"];
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"VISITS RESPONSE OBJECT %@", responseObject);
        
        success([BiTVisit buildVisitsFromData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

+ (void)addVisitForBusiness:(int)businessId 
                       user:(int)userId 
                  onSuccess:(void (^)(BiTVisit *visit))success 
                    failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/visit"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: 
                            [NSNumber numberWithInt:userId], @"user_id",
                            [NSNumber numberWithInt:businessId], @"business_id",
                            nil];
    
    [[BiTApiController sharedApi] postPath:apiPath parameters:params OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"VISIT RESPONSE OBJECT %@", responseObject);
        
        BiTVisit *visit = [BiTVisit buildVisitfromDict:responseObject];
        success(visit);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];
}

/**
 Creates an array of BitBusiness objects for an array of business data
 */
+ (NSArray *)buildVisitsFromData:(NSArray *)visitsData
{
    NSMutableArray *visitsArray = [NSMutableArray array];
    for(NSDictionary *visitData in visitsData) {

        BiTVisit *visit = [BiTVisit buildVisitfromDict:visitData];
        [visitsArray addObject:visit];
    }

    return [visitsArray copy];
}


/**
 Creates a BitVisit object for a Dictionary of data
 */
+ (BiTVisit *)buildVisitfromDict:(NSDictionary *)visitData
{
    BiTVisit *visit = [[BiTVisit alloc] init];
    visit.userId = [(NSNumber*)[visitData objectForKey:@"user_id"] intValue];
    visit.businessId = [(NSNumber*)[visitData objectForKey:@"business_id"] intValue];

    visit.visitDate = [visitData objectForKey:@"visit_date"];
    visit.visitId = [(NSNumber*)[visitData objectForKey:@"id"] intValue];
    
    if([visitData objectForKey:@"business_name"] != [NSNull null]) {
        visit.businessName = [visitData objectForKey:@"business_name"];
        visit.userName = [visitData objectForKey:@"user_name"];
    }
    
    NSLog(@"Visit id is %d", [(NSNumber*)[visitData objectForKey:@"id"] intValue]);
    return visit;
}

@end
