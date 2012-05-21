//
//  BiTCategoryCell.m
//  BestInTown
//
//  Created by Justin Marrington on 21/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTCategoryCell.h"

@implementation BiTCategoryCell
@synthesize iconView;
@synthesize categoryLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.categoryLabel.backgroundColor = [UIColor colorWithRed:26.0/255 green:26.0/255 blue:26.0/255 alpha:1.0];
        self.categoryLabel.textColor = [UIColor whiteColor];
        self.categoryLabel.textAlignment = UITextAlignmentCenter;
        self.categoryLabel.font = [UIFont fontWithName:@"Intro" size:16.0];
        [self addSubview:self.iconView];
        [self addSubview:self.categoryLabel];
        
        self.backgroundColor = [UIColor colorWithRed:26.0/255 green:26.0/255 blue:26.0/255 alpha:1.0];;
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    CGRect imageRect = CGRectMake(26.0, 15.0, 60.0, 60.0);
    self.iconView.frame = imageRect;
    
    self.categoryLabel.frame = CGRectMake(13.0, 78.0, 89.0, 26.0);
}

@end
