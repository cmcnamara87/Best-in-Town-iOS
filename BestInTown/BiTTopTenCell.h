//
//  BiTTopTenCell.h
//  BestInTown
//
//  Created by Craig McNamara on 16/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiTBusiness.h"

@interface BiTTopTenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *localityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nearbyLabel;

- (void)displayBusiness:(BiTBusiness *)business withRank:(int)rank;
@end
