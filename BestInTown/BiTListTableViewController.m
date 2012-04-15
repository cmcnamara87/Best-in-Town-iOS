//
//  BiTListTableViewController.m
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTListTableViewController.h"
#import "BiTApiController.h"

@interface BiTListTableViewController ()

@property (nonatomic, strong) NSArray *businesses;
@end

@implementation BiTListTableViewController
@synthesize businesses = _businesses;
@synthesize categoryId = _categoryId;
@synthesize cityId = _cityId;

- (void)setBusinesses:(NSArray *)businesses
{
    if (businesses != _businesses) {
        _businesses = businesses;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the 'top' list of businesses for this category
    if (!self.cityId) {
        // FIXME: Use Brisbane as default if there's no city id set (testing code)
        self.cityId = kBrisbaneCityId;
    }
    [[BiTApiController sharedApi] getBusinessListForCategory:self.categoryId inCity:self.cityId onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got these businesses:\n%@", [responseObject valueForKey:@"businesses"]);
        self.businesses = [responseObject valueForKey:@"businesses"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: Add actual error handling to the UI
        NSLog(@"We fucked the API call for business lists");
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show Business"]) {
        // TODO: Handle Business detail view model
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.businesses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Business Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    
    return cell;
}

@end
