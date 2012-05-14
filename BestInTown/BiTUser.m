//
//  BiTUser.m
//  BestInTown
//
//  Created by Craig McNamara on 9/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTUser.h"
#import "BiTApiController.h"

@implementation BiTUser
@synthesize created, lastName, firstName, fbId, email, profilePicUrl, userId;

+ (void)updateFBAccessTokenForUser:(int)userId 
                       accessToken:(NSString *)accessToken 
                        expiryDate:(NSDate *)expiryDate 
{
    
}

+ (void)addUserFromFBDict:(NSDictionary *)fBDict 
          withAccessToken:(NSString *)accessToken 
                andExpiry:(NSDate *)expiry
                onSuccess:(void (^)(BiTUser *user))success 
                  failure:(void (^)(NSError *error))failure
{
    NSLog(@"Saving the user");
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: 
                            [fBDict objectForKey:@"id"], @"fb_id",
                            [fBDict objectForKey:@"first_name"], @"first_name",
                            [fBDict objectForKey:@"last_name"], @"last_name",
                            accessToken, @"oauth_access_token",
                            expiry, @"oauth_expiry",
                            nil];
    
    [[BiTApiController sharedApi] postPath:@"index.php/api/user" parameters:params OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) 
     {
         NSLog(@"User created %@", responseObject);
         success([BiTUser buildUserfromDict:responseObject]);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"User failed to be created %@", error);
     }];
}

+ (BiTUser *)buildUserfromDict:(NSDictionary *)userData
{
    BiTUser *user = [[BiTUser alloc] init];
    user.userId = [(NSNumber*)[userData objectForKey:@"id"] intValue]; 
    user.fbId = [(NSNumber*)[userData objectForKey:@"fb_id"] intValue];
    user.firstName = [userData objectForKey:@"first_name"];
    user.lastName = [userData objectForKey:@"last_name"];
    if([userData objectForKey:@"email"] != [NSNull null]) {
        user.email = [userData objectForKey:@"email"];
    }
    if([userData objectForKey:@"profile_pic_url"] != [NSNull null]) {
        user.profilePicUrl = [[NSURL alloc] initWithString:[userData objectForKey:@"profile_pic_url"]];
    }
    user.created = [userData objectForKey:@"created"];
    
    return user;
}

@end
