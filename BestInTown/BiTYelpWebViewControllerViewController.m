//
//  BiTYelpWebViewControllerViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 18/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTYelpWebViewControllerViewController.h"

@interface BiTYelpWebViewControllerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BiTYelpWebViewControllerViewController
@synthesize webView = _webView;
@synthesize yelpMobileURL = _yelpMobileURL;

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
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.yelpMobileURL]];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
