//
//  BiTAddCategoryViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 8/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTAddCategoryViewController.h"

@interface BiTAddCategoryViewController ()

@end

@implementation BiTAddCategoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions
- (IBAction)cancelButtonPressed:(id)sender {
    NSLog(@"Should be dismissing modal");
    [self dismissModalViewControllerAnimated:YES];
}

@end
