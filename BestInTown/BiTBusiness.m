//
//  BiTBusiness.m
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTBusiness.h"
#import "BiTApiController.h"

@implementation BiTBusiness
@synthesize businessId;
@synthesize businessName;
@synthesize addressLines;
@synthesize city;
@synthesize lat;
@synthesize lon;
@synthesize phone;
@synthesize rankings;
@synthesize reviewSnippet;
@synthesize reviewUserImageUrl;
@synthesize reviewCount;
@synthesize yelpRating;
@synthesize yelpMobileUrl;
@synthesize imageUrl;


- (NSString *)addressString {
    NSString *formattedAddressString = @"";
    for(int i = 0; i < [self.addressLines count]; i++) {
        formattedAddressString = [formattedAddressString stringByAppendingFormat:@"%@\n",[self.addressLines objectAtIndex:i]];
        
    }
    return formattedAddressString;
}

+ (void)exploreForCity:(NSString *)cityId 
                    atLat:(double)lat 
                      lon:(double)lon 
                   radius:(int)radius 
                onSuccess:(void (^)(NSString *address, NSArray *businesses))success 
                  failure:(void (^)(NSError *error))failure
{

    NSString *apiPath = [NSString stringWithFormat:@"/api/nearby/lat/%f/lon/%f/radius/%d/cityid/%@", lat, lon, radius, cityId];
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Get out the address
        NSString *address = [responseObject valueForKey:@"address"];
        
        // Get out the businesses
        NSMutableArray *businessesArray = [NSMutableArray array];
        for(NSDictionary *businessData in [responseObject valueForKey:@"businesses"]) {
            BiTBusiness *business = [BiTBusiness buildBusinessfromDict:businessData];
            [businessesArray addObject:business];
        }
        success(address, [businessesArray copy]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);        
    }];
}

+ (BiTBusiness *)buildBusinessfromDict:(NSDictionary *)businessData
{
    BiTBusiness *business = [[BiTBusiness alloc] init];
    business.businessId = [businessData objectForKey:@"id"];
    business.businessName = [businessData objectForKey:@"name"];    
    business.addressLines = [businessData valueForKeyPath:@"location.display_address"];
    business.city = [businessData valueForKeyPath:@"location.city"];
    business.lat = [(NSNumber*)[businessData valueForKeyPath:@"location.coordinate.latitude"] doubleValue];
    business.lon = [(NSNumber*)[businessData valueForKeyPath:@"location.coordinate.longitude"] doubleValue];
    business.phone = [businessData objectForKey:@"display_phone"];
    
    // TODO: fill in rankings here
    
    business.reviewSnippet = [businessData objectForKey:@"snippet_text"];
    business.reviewUserImageUrl = [NSURL URLWithString:[businessData objectForKey:@"snippet_image_url"]];
    business.yelpMobileUrl = [NSURL URLWithString:[businessData objectForKey:@"mobile_url"]];
    business.imageUrl = [NSURL URLWithString:[businessData objectForKey:@"image_url"]];
    
    return business;
}

@end
