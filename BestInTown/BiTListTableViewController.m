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
#import "BiTLocationManager.h"
#import "BiTTopTenCell.h"

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
    
    [[BiTLocationManager locationManager] locationOnSuccess:^(BiTCity *city, CLLocation *location) {
        // Get the best businesses for the category
        [BiTBusiness getBestBusinessesForCategory:self.category.categoryId inCity:city.cityId onSuccess:^(NSArray *businesses) {
            self.businesses = businesses;
        } failure:^(NSError *error) {
            NSLog(@"Fucked up Business List %@", error);
        }];
    } failure:^{
        
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
    BiTTopTenCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    BiTBusiness *currentBusiness = [self.businesses objectAtIndex:indexPath.row];
    
    [cell displayBusiness:currentBusiness withRank:(indexPath.row + 1)];

    return cell;
}

@end
