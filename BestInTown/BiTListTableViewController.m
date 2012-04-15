//
//  BiTListTableViewController.m
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTListTableViewController.h"
#import "BiTApiController.h"
#import "BiTBusiness.h"
#import "BiTBusinessDetailViewController.h"

@interface BiTListTableViewController ()

@property (nonatomic, strong) NSArray *businesses;
@end

@implementation BiTListTableViewController
@synthesize businesses = _businesses;
@synthesize category = _category;
@synthesize cityId = _cityId;

#pragma mark - Accessors
- (void)setCategory:(BiTCategory *)category {
    if(category != _category) {
        _category = category;
        self.title = category.categoryName;
    }
}
- (void)setBusinesses:(NSArray *)businesses
{
    if (businesses != _businesses) {
        _businesses = businesses;
        [self.tableView reloadData];
    }
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the 'top' list of businesses for this category
    if (!self.cityId) {
        // FIXME: Use Brisbane as default if there's no city id set (testing code)
        self.cityId = kBrisbaneCityId;
    }
    
    // Download the business list
    [[BiTApiController sharedApi] getBusinessListForCategory:self.category.categoryId inCity:self.cityId onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got these businesses:\n%@", [responseObject valueForKey:@"businesses"]);
        
        // Convert data to an array of business objects
        NSMutableArray *businessesArray = [NSMutableArray array];
        for(NSDictionary *businessData in [responseObject valueForKey:@"businesses"]) {
            BiTBusiness *business = [BiTBusiness buildBusinessfromDict:businessData];
            [businessesArray addObject:business];
        }
        
        self.businesses = [businessesArray copy];
        
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
        BiTBusiness *currentBusiness = [self.businesses objectAtIndex:[self.tableView indexPathForCell:sender].row];
        [[segue destinationViewController] setBusiness:currentBusiness];
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
    BiTBusiness *currentBusiness = [self.businesses objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%i. %@", (indexPath.row + 1), currentBusiness.businessName];
    cell.detailTextLabel.text = currentBusiness.city;
    return cell;
}

@end
