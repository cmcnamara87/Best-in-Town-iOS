//
//  BiTLocationManager.m
//  BestInTown
//
//  Created by Craig McNamara on 14/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTLocationManager.h"
#import "BiTCity.h"
@interface BiTLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *cllocationManager;
@end

@implementation BiTLocationManager
@synthesize cllocationManager;

+ (BiTLocationManager *)locationManager
{
    static BiTLocationManager *instance;
    if (!instance) {
        // Make sure we have a AFHttpClient before anybody tries to use the API.
        instance = [[BiTLocationManager alloc] init];
        instance.cllocationManager = [[CLLocationManager alloc] init];
        instance.cllocationManager.delegate = instance;
        [instance.cllocationManager startMonitoringSignificantLocationChanges];
    }
    return instance;
}

- (void)locationOnSuccess:(void (^)(int cityId, CLLocation *location))success 
                  failure:(void (^)())failure
{
    if(cllocationManager.location) {
        // we have a location
        CLLocationCoordinate2D coordinate = cllocationManager.location.coordinate;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int cityId = [(NSNumber *)[defaults objectForKey:@"cityId"] intValue];
        double cityMaxLat = [(NSNumber *)[defaults objectForKey:@"cityMaxLat"] doubleValue];
        double cityMinLat = [(NSNumber *)[defaults objectForKey:@"cityMinLat"] doubleValue];
        double cityMaxLon = [(NSNumber *)[defaults objectForKey:@"cityMaxLon"] doubleValue];
        double cityMinLon = [(NSNumber *)[defaults objectForKey:@"cityMinLon"] doubleValue];
        
        if (cityId && coordinate.latitude < cityMaxLat && coordinate.latitude > cityMinLat && coordinate.longitude < cityMaxLon && coordinate.longitude > cityMinLon) {
            success(cityId, cllocationManager.location);
        } else {
            
            // We need to get an updated city from the server
            [BiTCity getCityForLat:coordinate.latitude lon:coordinate.longitude onSuccess:^(BiTCity *city) {
                
                // Store it for next time in defaults
                [defaults setObject:[NSNumber numberWithInt:city.cityId] forKey:@"userId"];
                [defaults setObject:[NSNumber numberWithDouble:city.maxCoordinate.coordinate.latitude] forKey:@"cityMaxLat"];
                [defaults setObject:[NSNumber numberWithDouble:city.maxCoordinate.coordinate.longitude] forKey:@"cityMaxLon"];
                [defaults setObject:[NSNumber numberWithDouble:city.minCoordinate.coordinate.latitude] forKey:@"cityMinLat"];
                [defaults setObject:[NSNumber numberWithDouble:city.minCoordinate.coordinate.longitude] forKey:@"cityMinLon"];
                
                success(city.cityId, cllocationManager.location);
            } failure:^(NSError *error) {
                failure();
            }];
        }
    } else {
        failure();
    }
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location changed %@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error
{
    NSLog(@"Error with location");
}

@end
