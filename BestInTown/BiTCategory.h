//
//  BiTCategory.h
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiTCategory : NSObject
@property (nonatomic, weak) BiTCategory *parentCategory;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, copy) NSArray *subcategories;

+ (BiTCategory *)buildCategory:(NSString *)categoryId fromDict:(NSDictionary *)categoryData;
@end
