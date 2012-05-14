//
//  BiTLocationManager.h
//  BestInTown
//
//  Created by Craig McNamara on 14/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BiTLocationManager : NSObject
+ (BiTLocationManager *)locationManager;
- (void)locationOnSuccess:(void (^)(int cityId, CLLocation *location))success 
                  failure:(void (^)())failure;
@end
