//
//  BiTRatingTableViewController.h
//  BestInTown
//
//  Created by Craig McNamara on 4/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTBusiness.h"
#define kUserId 1;

@interface BiTRatingTableViewController : UITableViewController
@property (nonatomic, strong) BiTBusiness *business;
@end
