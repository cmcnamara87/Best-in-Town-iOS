//
//  BiTBestTableViewController.h
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiTBestTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, assign) BOOL isSubcategory;

- (void)refreshCategories;
@end
