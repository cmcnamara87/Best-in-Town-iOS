//
//  BiTBestTableViewController.h
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTCategory.h"

@interface BiTCategoryTableViewController : UITableViewController
// Array of categories
@property (nonatomic, strong) NSArray *categories;
// Says if this tvc is showing a subcategory or not
@property (nonatomic, assign) BOOL isSubcategory;
// The current category (nil for top level, next is like, 'food' etc)
@property (nonatomic, strong) BiTCategory *category;

- (void)refreshCategories;
@end
