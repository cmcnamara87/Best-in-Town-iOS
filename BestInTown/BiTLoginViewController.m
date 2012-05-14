//
//  BiTLoginViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 12/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTLoginViewController.h"
#import "Facebook.h"
#import "BiTAppDelegate.h"
#import "BiTUser.h"

@interface BiTLoginViewController () <FBSessionDelegate, FBRequestDelegate
>
@property (nonatomic, weak) Facebook *facebook;
@end

@implementation BiTLoginViewController
@synthesize facebook = _facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.facebook = [(BiTAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
    self.facebook.sessionDelegate = self;

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

#pragma mark Actions
- (IBAction)loginWithFacebook:(id)sender 
{
    // Login with facebook
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            nil];
    
    [self.facebook authorize:permissions];
}


#pragma mark - FBRequestDelegate methods
/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Error in facebook request %@, %@", request, error);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    if([request.url isEqualToString:@"https://graph.facebook.com/me"]) {
        // Save the user
        [BiTUser addUserFromFBDict:result withAccessToken:self.facebook.accessToken andExpiry:self.facebook.expirationDate onSuccess:^(BiTUser *user) {
           
            NSLog(@"Made a new user, saving the ID in user defaults");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSNumber numberWithInt:user.userId] forKey:@"userId"];
            
            
            // Close the login prompt
            [self performSegueWithIdentifier:@"Show App" sender:self];
//            [self dismissModalViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            NSLog(@"Failed to make user from fb object, %@", error);
        }];
        
        // TODO: get back a user object
        
        
    }
}

#pragma mark - FBSessionDelegate Methods
- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    // Get the user object from facebook
    NSLog(@"Facebook did login");
    
    // Close the login prompt
    [self performSegueWithIdentifier:@"Show App" sender:self];
//    [self dismissModalViewControllerAnimated:YES];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    
}

@end
