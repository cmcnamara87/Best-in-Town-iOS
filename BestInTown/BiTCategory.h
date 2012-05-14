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
@property (nonatomic, assign) int categoryId;
@property (nonatomic, assign) int parentId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, copy) NSArray *subcategories;
@property (nonatomic, assign) int eloScore;
@property (nonatomic, assign) int rank;

+ (BiTCategory *)buildCategoryFromDict:(NSDictionary *)categoryData;
+ (void)getCategoriesOnSuccess:(void (^)(NSArray *categories))success 
                       failure:(void (^)(NSError *error))failure;
+ (void)addBusiness:(int)businessId 
         toCategory:(int)categoryId 
          onSuccess:(void (^)())success 
            failure:(void (^)(NSError *error))failure;
@end
