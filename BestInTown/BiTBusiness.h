//
//  BiTBusiness.h
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BiTBusiness : NSObject
@property (nonatomic, assign) int businessId;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, assign) int cityId;
//@property (nonatomic, assign) double lat;
//@property (nonatomic, assign) double lon;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *modified;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) float rating;
@property (nonatomic, strong) NSURL *websiteUrl;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSArray *rankings;
@property (nonatomic, strong) NSString *dataSource;
@property (nonatomic, strong) NSString *referenceId;
@property (nonatomic, assign) BOOL hasDetails;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, assign) int eloScore;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) BOOL selectedBusiness; // stores if this is the business we are focusing on in an array

//+ (BiTBusiness *)buildBusinessfromDict:(NSDictionary *)businessData;

+ (void)addBusiness:(int)businessId 
         toCategory:(int)categoryId 
          onSuccess:(void (^)(BiTBusiness *business))success 
            failure:(void (^)(NSError *error))failure;

+ (void)getBestBusinessesForCategory:(int)categoryId 
                              inCity:(int)cityId
                           onSuccess:(void (^)(NSArray *businesses))success 
                             failure:(void (^)(NSError *error))failure;

+ (void)getNearbyBestBusinessesInCity:(int)cityId 
                                atLat:(double)lat
                                  lon:(double)lon
                              radiusM:(int)radiusM
                        underCategory:(int)categoryId
                            onSuccess:(void (^)(NSString *address, NSArray *businesses))success 
                              failure:(void (^)(NSError *error))failure;

+ (void)getNearbyAllBusinessesInCity:(int)cityId
                               atLat:(double)lat 
                                 lon:(double)lon 
                             radiusM:(int)radiusM
                           onSuccess:(void (^)(NSString *address, NSArray *businesses))success 
                             failure:(void (^)(NSError *error))failure;

+ (void)getBusinessesToRateForUser:(int)userId 
                          business:(int)businessId 
                         onSuccess:(void (^)(NSArray *businesses))success 
                           failure:(void (^)(NSError *error))failure;

+ (void)addRatingForBusiness:(int)businessId 
               verseBusiness:(int)businessId1 
                         won:(BOOL)won1 
                 andBusiness:(int)businessId2 
                         won:(BOOL)won2 
                     forUser:(int)userId
                   onSuccess:(void (^)(BiTBusiness *business))success 
                     failure:(void (^)(NSError *error))failure;

+ (BiTBusiness *)buildBusinessfromDict:(NSDictionary *)businessData;

@end
