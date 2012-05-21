//
//  BiTRatingResultViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 16/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTRatingResultViewController.h"

@interface BiTRatingResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BiTRatingResultViewController
@synthesize imageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [TestFlight passCheckpoint:@"RATING_COMPLETE"];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions
- (IBAction)doneButton:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

@end
