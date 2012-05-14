//
//  BiTVisit.h
//  BestInTown
//
//  Created by Craig McNamara on 6/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiTVisit : NSObject
@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) int businessId;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSDate *visitDate;
@property (nonatomic, assign) int visitId;

+ (void)addVisitForBusiness:(int)businessId 
                       user:(int)userId 
                  onSuccess:(void (^)(BiTVisit *visit))success 
                    failure:(void (^)(NSError *error))failure;

+ (void)getAllVisitsOnSuccess:(void (^)(NSArray *visits))success 
                      failure:(void (^)(NSError *error))failure;

@end
