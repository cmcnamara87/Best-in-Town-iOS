//
//  BiTListTableViewController.h
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTCategory.h"

@interface BiTListTableViewController : UITableViewController
@property (nonatomic, strong) BiTCategory *category;
@property (nonatomic, strong) NSString *cityId;
@end
