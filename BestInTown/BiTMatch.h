//
//  BiTMatch.h
//  BestInTown
//
//  Created by Craig McNamara on 6/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BiTBusiness.h"
#import "BiTVisit.h"

@interface BiTMatch : NSObject

+ (void)addMatchForWinningBusiness:(int)businessIdWin 
                    losingBusiness:(int)businessIdLose 
                          forVisit:(int)visitId
                         onSuccess:(void (^)())success 
                           failure:(void (^)(NSError *error))failure;

+ (void)addRankingResult:(NSArray *)businesses 
           forBusinesses:(BiTBusiness *)business 
                forVisit:(BiTVisit *)visit
               onSuccess:(void (^)())success 
                 failure:(void (^)(NSError *error))failure;
@end
