//
//  BiTLocationManager.m
//  BestInTown
//
//  Created by Craig McNamara on 14/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTLocationManager.h"
#import "BiTAppDelegate.h"
#import "BiTCity.h"
@interface BiTLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation BiTLocationManager
@synthesize cllocationManager, managedObjectContext;

+ (BiTLocationManager *)locationManager
{
    static BiTLocationManager *instance;
    if (!instance) {
        // Make sure we have a AFHttpClient before anybody tries to use the API.
        instance = [[BiTLocationManager alloc] init];
        instance.cllocationManager = [[CLLocationManager alloc] init];
        instance.cllocationManager.delegate = instance;
        [instance.cllocationManager startMonitoringSignificantLocationChanges];
        
        instance.managedObjectContext = [(BiTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return instance;
}

- (void)locationOnSuccess:(void (^)(BiTCity *city, CLLocation *location))success 
                  failure:(void (^)())failure
{
    if(cllocationManager.location) {
        // we have a location
        CLLocationCoordinate2D coordinate = cllocationManager.location.coordinate;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BiTCity *city = (BiTCity *)[defaults objectForKey:@"city"];
        
        if (city && 
            coordinate.latitude < city.maxCoordinate.coordinate.latitude && 
            coordinate.latitude > city.minCoordinate.coordinate.latitude && 
            coordinate.longitude < city.maxCoordinate.coordinate.longitude && 
            coordinate.longitude > city.minCoordinate.coordinate.longitude) {
            
            success(city, cllocationManager.location);
        } else {
            
            // We need to get an updated city from the server
            [BiTCity getCityForLat:coordinate.latitude lon:coordinate.longitude onSuccess:^(BiTCity *city) {
                
                // Store it for next time in defaults
                [defaults setObject:city forKey:@"city"];
                [defaults synchronize];
                
                success(city, cllocationManager.location);
                
            } failure:^(NSError *error) {
                failure();
            }];
        }
    } else {
        failure();
    }
}

/**
 Get array of past locations
 (locations filtered for distance changes, since there might be 
 times where it triggers a write, but its not a large distance change)
 */
- (NSArray *)getPastLocations
{
    // Get the managed object context from the delegate
    NSManagedObjectContext * managedObjectContext = [(BiTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    [fetch setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"LocationCache"];
    NSError *error;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Failed to fetch locations: %@", error);
    }
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location changed %@", newLocation);
    NSEntityDescription *locEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    [locEntity setValue:[NSNumber numberWithDouble:newLocation.coordinate.latitude] forKey:@"latitude"];
    [locEntity setValue:[NSNumber numberWithDouble:newLocation.coordinate.longitude] forKey:@"longitude"];
    [locEntity setValue:[NSDate date] forKey:@"timestamp"];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // handle errors
        NSLog(@"Location write error: %@", error);
    }
}

- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error
{
    NSLog(@"Error with location");
}

@end
