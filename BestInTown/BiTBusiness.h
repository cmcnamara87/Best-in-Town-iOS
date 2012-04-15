//
//  BiTBusiness.h
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiTBusiness : NSObject
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSArray *addressLines;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSArray *rankings;
@property (nonatomic, assign) int reviewCount;
@property (nonatomic, strong) NSString *reviewSnippet;
@property (nonatomic, strong) NSURL *reviewUserImageUrl;
@property (nonatomic, strong) NSURL* yelpMobileUrl;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, assign) int yelpRating;

+ (BiTBusiness *)buildBusinessfromDict:(NSDictionary *)businessData;
- (NSString *)addressString;

@end
