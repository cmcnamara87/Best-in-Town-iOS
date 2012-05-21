//
//  BiTRateSelectorTableViewController.h
//  BestInTown
//
//  Created by Craig McNamara on 30/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTAssignCategoryTableViewController.h"
#import "BiTCategory.h"
#import "BiTBusiness.h"

@interface BiTRateSelectorTableViewController : UITableViewController
- (void)assignCategoryTableViewController:(BiTAssignCategoryTableViewController *)assignCategoryTableViewController
                           didAddCategory:(BiTCategory *)category
                               toBusiness:(BiTBusiness *)business;
@end
