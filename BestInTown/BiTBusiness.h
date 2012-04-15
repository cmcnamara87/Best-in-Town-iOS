//
//  BiTBusiness.h
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiTBusiness : NSObject
@property (nonatomic, strong) NSString *parentCategoryId;
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSArray *addressLines;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSArray *rankings;


@end
