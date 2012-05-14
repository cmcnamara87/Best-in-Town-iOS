//
//  BiTCity.m
//  BestInTown
//
//  Created by Craig McNamara on 14/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTCity.h"
#import "BiTApiController.h"

@implementation BiTCity
@synthesize country,cityName, countryId, cityId, coordinate, minCoordinate, maxCoordinate;

+ (void)getCityForLat:(double)lat lon:(double)lon
              onSuccess:(void (^)(BiTCity *city))success 
                failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/city/lat/%f/lon/%f", lat, lon];
    
    [[BiTApiController sharedApi] getPath:apiPath parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"City RESPONSE OBJECT %@", responseObject);
        
        success([BiTCity buildCityfromDict:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get a city, %@", error);
        failure(error);        
    }];
}

+ (BiTCity *)buildCityfromDict:(NSDictionary *)cityData
{
    BiTCity *city = [[BiTCity alloc] init];
    
    city.cityId = [(NSNumber*)[cityData objectForKey:@"id"] intValue];
    city.countryId = [(NSNumber*)[cityData objectForKey:@"country_id"] intValue];
    // TODO: Add in country object processing for building city
    city.cityName = [cityData objectForKey:@"city_name"];
    city.coordinate = [[CLLocation alloc] initWithLatitude:[(NSNumber *)[cityData objectForKey:@"lat"] doubleValue] 
                                                 longitude:[(NSNumber *)[cityData objectForKey:@"lon"] doubleValue]];


    if([cityData objectForKey:@"bounding_box"] != [NSNull null]) {
        // We have the bounding box information for the city
        NSDictionary *boundingBox = [cityData objectForKey:@"bounding_box"];
                
        city.minCoordinate = [[CLLocation alloc] initWithLatitude:[(NSNumber *)[boundingBox objectForKey:@"min_lat"] doubleValue] 
                                                        longitude:[(NSNumber *)[boundingBox objectForKey:@"min_lon"] doubleValue]];
        city.maxCoordinate = [[CLLocation alloc] initWithLatitude:[(NSNumber *)[boundingBox objectForKey:@"max_lat"] doubleValue] 
                                                        longitude:[(NSNumber *)[boundingBox objectForKey:@"max_lon"] doubleValue]];
    }
    
    return city;
}

@end
