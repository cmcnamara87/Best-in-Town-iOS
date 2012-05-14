//
//  BiTMatch.m
//  BestInTown
//
//  Created by Craig McNamara on 6/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTMatch.h"
#import "BiTApiController.h"

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
@end
