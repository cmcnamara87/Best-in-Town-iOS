//
//  BiTStartupViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 11/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTStartupViewController.h"
#import "Facebook.h"
#import "BiTAppDelegate.h"
#import "BiTLocationManager.h"

#define kAppId @"1234"

@interface BiTStartupViewController () <FBRequestDelegate>
@property (nonatomic, weak) Facebook *facebook;
@end

@implementation BiTStartupViewController
@synthesize facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)logo:(id)sender {


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    
    NSLog(@"Loading BiTStartupViewController");
    
    // Setup the location manager
    [BiTLocationManager locationManager];
    
    self.facebook = [(BiTAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        
        NSLog(@"Acess token %@", self.facebook.accessToken);
        NSLog(@"Expiry date %@", self.facebook.expirationDate);
    }
    
    if (![self.facebook isSessionValid]) {
        // Show the login controller
        [self performSegueWithIdentifier:@"Show Login" sender:self];
    } else {
        
        // Already logged in
        // Do we already have the user stored?
        if ([defaults objectForKey:@"userId"]) {
            
            NSLog(@"User ID found, showing app");
            
            [self performSegueWithIdentifier:@"Show App" sender:self];
        } else {
            
            NSLog(@"No User Id Found, showing login");
            
            // dont have the user stored, so get it from facebook
            [self performSegueWithIdentifier:@"Show Login" sender:self];
        }
        
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing for segue %@", segue.identifier);
}

#pragma mark Actions


@end
