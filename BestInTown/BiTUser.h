//
//  BiTUser.h
//  BestInTown
//
//  Created by Craig McNamara on 9/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiTUser : NSObject
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int fbId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSURL *profilePicUrl;
@property (nonatomic, strong) NSDate *created;

+ (void)addUserFromFBDict:(NSDictionary *)fBDict 
          withAccessToken:(NSString *)accessToken 
                andExpiry:(NSDate *)expiry
                onSuccess:(void (^)(BiTUser *user))success 
                  failure:(void (^)(NSError *error))failure;

@end
