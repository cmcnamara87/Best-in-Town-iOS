//
//  BiTFadeSegue.m
//  BestInTown
//
//  Created by Craig McNamara on 20/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTFadeSegue.h"

@implementation BiTFadeSegue

- (void)perform
{
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}



@end
