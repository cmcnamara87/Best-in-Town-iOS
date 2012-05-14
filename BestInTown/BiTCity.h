//
//  BiTCity.h
//  BestInTown
//
//  Created by Craig McNamara on 14/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BiTCountry.h"


@interface BiTCity : NSObject
@property (nonatomic, assign) int cityId;
@property (nonatomic, assign) int countryId;
@property (nonatomic, strong) BiTCountry *country;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) CLLocation *coordinate;

// Bounding box properties for the city (may not be set)
@property (nonatomic, strong) CLLocation *minCoordinate;
@property (nonatomic, strong) CLLocation *maxCoordinate;

+ (void)getCityForLat:(double)lat lon:(double)lon
            onSuccess:(void (^)(BiTCity *city))success 
              failure:(void (^)(NSError *error))failure;

@end

