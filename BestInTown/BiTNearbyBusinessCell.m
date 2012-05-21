//
//  BiTNearbyBusinessCell.m
//  BestInTown
//
//  Created by Craig McNamara on 15/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTNearbyBusinessCell.h"
#import "BiTCategory.h"


@implementation BiTNearbyBusinessCell
@synthesize businessNameLabel, localityLabel, distanceLabel, categoryRankLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayBusiness:(BiTBusiness *)business
{
    self.businessNameLabel.text = business.businessName;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1fKM", business.distance];
    self.localityLabel.text = business.locality;
    self.categoryRankLabel.text = @"";
//    NSLog(@"Creating business %@", business.businessName);
    
    for(BiTCategory *category in business.categories) {
//        NSLog(@"Category %@ %d", category.categoryName, category.rank);
        if(category.rank) {
            self.categoryRankLabel.text = [NSString stringWithFormat:@"%@#%d %@\n", self.categoryRankLabel.text, category.rank, category.categoryName];
        } else {
            self.categoryRankLabel.text = [NSString stringWithFormat:@"%@%@\n", self.categoryRankLabel.text, category.categoryName];
        }
    }
}

@end
