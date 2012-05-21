//
//  BiTNearbyBusinessCell.h
//  BestInTown
//
//  Created by Craig McNamara on 15/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTBusiness.h"

@interface BiTNearbyBusinessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localityLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryRankLabel;

- (void)displayBusiness:(BiTBusiness *)business;

@end
