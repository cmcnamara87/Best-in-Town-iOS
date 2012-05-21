//
//  BiTAssignCategoryTableViewController.h
//  BestInTown
//
//  Created by Craig McNamara on 30/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTBusiness.h"
#import "BiTCategory.h"

@class BiTAssignCategoryTableViewController;

@protocol BiTAssignCategoryTableViewControllerDelegate <NSObject> 
- (void)assignCategoryTableViewController:(BiTAssignCategoryTableViewController *)sender assignedCategory:(BiTCategory *)category toBusiness:(BiTBusiness *)business;
- (void)assignCategoryTableViewControllerDidNotAssignCategory:(BiTAssignCategoryTableViewController *)sender ;
@end

@interface BiTAssignCategoryTableViewController : UITableViewController
// The business we are assigning a category to
@property (nonatomic, strong) BiTBusiness *business;
@property (nonatomic, weak) id <BiTAssignCategoryTableViewControllerDelegate> delegate;
@end
