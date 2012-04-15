//
//  BiTCategory.m
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTCategory.h"

@implementation BiTCategory
@synthesize parentCategory = _parentCategory;
@synthesize categoryId = _categoryId;
@synthesize categoryName = _name;
@synthesize imageUrl = _imageUrl;
@synthesize subcategories = _subcategories;

+ (BiTCategory *)buildCategory:(NSString *)categoryId fromDict:(NSDictionary *)categoryData
{
    BiTCategory *topLevel = [[BiTCategory alloc] init];
    topLevel.categoryId = categoryId;
    topLevel.categoryName = [categoryData valueForKey:@"name"];
    topLevel.imageUrl = [categoryData valueForKey:@"image_url"];
    
    if ([categoryData valueForKey:@"sub"]) {
        NSMutableArray *subArray = [NSMutableArray array];
        NSDictionary *subs = [categoryData valueForKey:@"sub"];
        for (NSString *subCatId in subs) {
            BiTCategory *subcategory = [[BiTCategory alloc] init];
            subcategory.categoryId = subCatId;
            subcategory.parentCategory = topLevel;
            subcategory.categoryName = [subs valueForKey:subCatId];
            [subArray addObject:subcategory];
        }
        
        topLevel.subcategories = [subArray copy];
    }

    return topLevel;
}

@end
