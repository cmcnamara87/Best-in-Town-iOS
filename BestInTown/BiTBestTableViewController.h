//
//  BiTBestTableViewController.h
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiTBestTableViewController : UITableViewController
// Array of categories
@property (nonatomic, strong) NSArray *categories;
// Says if this tvc is showing a subcategory or not
@property (nonatomic, assign) BOOL isSubcategory;
// The name of the category (for sub-categories)
@property (nonatomic, strong) NSString *categoryName;

- (void)refreshCategories;
@end
