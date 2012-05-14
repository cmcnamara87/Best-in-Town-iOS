//
//  BiTNearbyViewController.h
//  BestInTown
//
//  Created by Craig McNamara on 18/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTCategory.h"
@interface BiTNearbyViewController : UITableViewController
// Best businesses nearby
@property (nonatomic, strong) NSArray* businesses;
@property (nonatomic, strong) BiTCategory *category;
@end
