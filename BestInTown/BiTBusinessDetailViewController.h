//
//  BiTBusinessDetailViewController.h
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTBusiness.h"

#define kNumberOfSections 4

#define kCategoryRanksSectionIndex 0
#define kContactSectionIndex 1
#define kReviewSectionIndex 2
#define kOpeningTimesSectionIndex 3

@interface BiTBusinessDetailViewController : UITableViewController
@property (nonatomic, strong) BiTBusiness* business;

- (CGFloat)heightOfCellForLabelWithString:(NSString *)string andWidth:(CGFloat)width;
@end
