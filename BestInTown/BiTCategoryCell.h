//
//  BiTCategoryCell.h
//  BestInTown
//
//  Created by Justin Marrington on 21/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "AQGridViewCell.h"

@interface BiTCategoryCell : AQGridViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

@end
