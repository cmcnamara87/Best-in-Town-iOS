//
//  BiTTopTenCell.m
//  BestInTown
//
//  Created by Craig McNamara on 16/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTTopTenCell.h"
#import "BiTBusiness.h"
#import "BiTLocationManager.h"

@implementation BiTTopTenCell
@synthesize businessNameLabel, rankLabel, imageView, localityLabel, nearbyLabel;

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

- (void)displayBusiness:(BiTBusiness *)business withRank:(int)rank
{
    self.businessNameLabel.text = business.businessName;
    self.localityLabel.text = business.locality;
    self.rankLabel.text = [NSString stringWithFormat:@"%d", rank];
    
    // Work out if the place is close
    CLLocation *currentLocation = [[[BiTLocationManager locationManager] cllocationManager] location];
    CLLocationDistance distance = [currentLocation distanceFromLocation:business.location];
    NSString *unit = @"m";
    if(distance < 2500) {
        // The place is nearby
        if(distance > 1000) {
            distance = distance / 1000.0;
            unit = @"km";
        }
        self.nearbyLabel.text = @"Nearby";
    } else {
        // Not close
        self.nearbyLabel.text = @"";
    }
//    self.nearbyLabel.text = @"";
//    if(
}

@end

