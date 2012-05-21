//
//  BiTCategory.m
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTCategory.h"
#import "BiTApiController.h"

@implementation BiTCategory
@synthesize parentCategory = _parentCategory;
@synthesize categoryId = _categoryId;
@synthesize categoryName = _name;
@synthesize imageUrl = _imageUrl;
@synthesize subcategories = _subcategories;
@synthesize parentId = _parentId;
@synthesize rank = _rank;
@synthesize eloScore = _eloScore;

+ (void)getCategoriesOnSuccess:(void (^)(NSArray *categories))success 
                       failure:(void (^)(NSError *error))failure
{
    [[BiTApiController sharedApi] getPath:@"index.php/api/categories" parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        success([BiTCategory buildCategoriesFromData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get categories");
        failure(error);
    }];
}

+ (void)getLeafCategoriesOnSuccess:(void (^)(NSArray *categories))success 
                           failure:(void (^)(NSError *error))failure 
{
 
    [[BiTApiController sharedApi] getPath:@"index.php/api/categories_leaf" parameters:nil OnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success([BiTCategory buildCategoriesFromData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get categories");
        failure(error);
    }];
}

#pragma mark Class methods

/**
 Creates an array of BitCategory objects for an array of category data
 */
+ (NSArray *)buildCategoriesFromData:(NSArray *)categoriesData
{
    NSMutableArray *categories = [NSMutableArray array];
    for(NSDictionary *categoryData in categoriesData) {
        BiTCategory *category = [BiTCategory buildCategoryFromDict:categoryData];
        [categories addObject:category];
    }
    return [categories copy];
}

+ (BiTCategory *)buildCategoryFromDict:(NSDictionary *)categoryData
{
    BiTCategory *category = [[BiTCategory alloc] init];
    category.categoryName = [categoryData objectForKey:@"name"];
    category.categoryId = [(NSNumber*)[categoryData objectForKey:@"id"] intValue];
    
    if([categoryData objectForKey:@"image"] != [NSNull null]) {
        category.imageUrl = [[NSURL alloc] initWithString:[categoryData objectForKey:@"image"]];
    }
    
    if([categoryData objectForKey:@"parent_id"] != [NSNull null]) {
        category.imageUrl = [[NSURL alloc] initWithString:[categoryData objectForKey:@"parent_id"]];
    } 
    
    // Business specific category data (we can add here too)
    if([categoryData objectForKey:@"elo_score"] != [NSNull null]) {
        category.eloScore = [(NSNumber*)[categoryData objectForKey:@"elo_score"] intValue];
    } 
    if([categoryData objectForKey:@"rank"] != [NSNull null]) {
        category.eloScore = [(NSNumber*)[categoryData objectForKey:@"rank"] intValue];
    }
    
    // Add in the subcategories (only if its there, and there is more than 1 sub-category)
    if([categoryData objectForKey:@"categories"] != [NSNull null] && [[categoryData objectForKey:@"categories"] count]) {
        category.subcategories = [BiTCategory buildCategoriesFromData:[categoryData objectForKey:@"categories"]];
    }

    return category;
}

@end
