//
//  BiTMatch.m
//  BestInTown
//
//  Created by Craig McNamara on 6/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTMatch.h"
#import "BiTBusiness.h"
#import "BiTApiController.h"
#import "BiTVisit.h"

@implementation BiTMatch

+ (void)addMatchForWinningBusiness:(int)businessIdWin 
                    losingBusiness:(int)businessIdLose 
                          forVisit:(int)visitId
                         onSuccess:(void (^)())success 
                           failure:(void (^)(NSError *error))failure
{
    NSString *apiPath = [NSString stringWithFormat:@"index.php/api/match"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: 
                            [NSNumber numberWithInt:businessIdWin], @"winner_business_id",
                            [NSNumber numberWithInt:businessIdLose], @"loser_business_id",
                            [NSNumber numberWithInt:visitId], @"visit_id",
                            nil];
    
    [[BiTApiController sharedApi] postPath:apiPath parameters:params OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);        
    }];

}

+ (void)addTwoMatchesWinningBusiness1:(int)winningBusiness1Id 
                      losingBusiness1:(int)losingBusiness1Id 
                     winningBusiness2:(int)winningBusiness2Id 
                      losingBusiness2:(int)losingBusiness2Id 
                             forVisit:(int)visitId
                            onSuccess:(void (^)())success 
                              failure:(void (^)(NSError *error))failure
{
    [BiTMatch addMatchForWinningBusiness:winningBusiness1Id 
                          losingBusiness:losingBusiness1Id 
                                forVisit:visitId onSuccess:^{
                                    
        [BiTMatch addMatchForWinningBusiness:winningBusiness2Id 
                              losingBusiness:losingBusiness2Id 
                                    forVisit:visitId onSuccess:^{
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}
+ (void)addRankingResult:(NSArray *)businesses 
           forBusinesses:(BiTBusiness *)business 
                forVisit:(BiTVisit *)visit
               onSuccess:(void (^)())success 
                 failure:(void (^)(NSError *error))failure
{
    // Add match results
    // lets find where the current business is after they have finished rating
    int selectedBusinessIndex = 0;
    for(BiTBusiness *currentBusiness in businesses) {
        if(currentBusiness.businessId = business.businessId) {
            break;
        }
        selectedBusinessIndex++;
    }
    
    if(businesses.count == 2) {
        // Work out the winning and losing businesses
        BiTBusiness *losingBusiness;
        BiTBusiness *winningBusiness;
        if(selectedBusinessIndex == 0) {
            winningBusiness = business;
            losingBusiness = [businesses objectAtIndex:1];
        } else {
            winningBusiness = business;
            losingBusiness = [businesses objectAtIndex:1];
        }
        
        [BiTMatch addMatchForWinningBusiness:winningBusiness.businessId losingBusiness:losingBusiness.businessId forVisit:visit.visitId onSuccess:^{
            success();
        } failure:^(NSError *error) {
            failure(error);
        }];
    } else {
        // There are 3 businesses
        // lets work out the winning and losing businesses
        BiTBusiness *winningBusiness1;
        BiTBusiness *losingBusiness1;
        BiTBusiness *winningBusiness2;
        BiTBusiness *losingBusiness2;
        
        switch (selectedBusinessIndex) {
            case 0:
                winningBusiness1 = business;
                winningBusiness2 = business;
                losingBusiness1 = [businesses objectAtIndex:1];
                losingBusiness2 = [businesses objectAtIndex:2];
                break;
            case 1:
                winningBusiness1 = [businesses objectAtIndex:0];
                winningBusiness2 = business;
                losingBusiness1 = business;
                losingBusiness2 = [businesses objectAtIndex:2];
                break;
            case 2:
                winningBusiness1 = [businesses objectAtIndex:0];
                winningBusiness2 = [businesses objectAtIndex:1];
                losingBusiness1 = business;
                losingBusiness2 = business;
                break;
            default:
                break;
        }
        
        [BiTMatch addTwoMatchesWinningBusiness1:winningBusiness1.businessId 
                                losingBusiness1:losingBusiness1.businessId 
                               winningBusiness2:winningBusiness2.businessId 
                                losingBusiness2:losingBusiness2.businessId 
                                       forVisit:visit.visitId 
                                      onSuccess:^{
                                          success(); 
                                      } failure:^(NSError *error) {
                                          failure(error);
                                      }];
    }
}
@end
