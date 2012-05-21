//
//  BiTLocationManager.h
//  BestInTown
//
//  Created by Craig McNamara on 14/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BiTCity.h"

@interface BiTLocationManager : NSObject
// No guarantee of data
@property (nonatomic, strong) CLLocationManager *cllocationManager;

+ (BiTLocationManager *)locationManager;

// Guarantee of data
- (void)locationOnSuccess:(void (^)(BiTCity *city, CLLocation *location))success 
                  failure:(void (^)())failure;
@end
