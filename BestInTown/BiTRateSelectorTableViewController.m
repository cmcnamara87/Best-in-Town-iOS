//
//  BiTRateSelectorTableViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 30/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTRateSelectorTableViewController.h"
#import "BiTBusiness.h"
#import "BiTAssignCategoryTableViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface BiTRateSelectorTableViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSString *address;
@end

@implementation BiTRateSelectorTableViewController
@synthesize locationManager;
@synthesize businesses = _businesses;
@synthesize address = _address;

- (void)setBusinesses:(NSArray *)businesses 
{
    if(businesses != _businesses) {
        _businesses = businesses;
        [self.tableView reloadData];
    }
}

- (void)setAddress:(NSString *)address
{
    if(address != _address) {
        _address = address;
        NSLog(@"Address is %@", self.address);
    }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Setup location manager
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //Only applies when in foreground otherwise it is very significant changes (maybe???)
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Start getting locations
    [self.locationManager startUpdatingLocation];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Show Assign Category"]) {
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger rowNumber = selectedIndexPath.row;
        
        // Get out the business
        BiTBusiness *business = [self.businesses objectAtIndex:rowNumber];
        [segue.destinationViewController setBusiness:business];
    } else if ([segue.identifier isEqualToString:@"Show Rate"]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger rowNumber = selectedIndexPath.row;
        
        // Get out the business
        BiTBusiness *business = [self.businesses objectAtIndex:rowNumber];
        [segue.destinationViewController setBusiness:business];
    }

}

#pragma mark Actions
- (void)refreshNearbyBusinessesAtLat:(double)lat lon:(double)lon
{
    int cityId = 1;
    int radiusM = 500;
    
    [BiTBusiness getNearbyAllBusinessesInCity:cityId atLat:lat lon:lon radiusM:radiusM onSuccess:^(NSString *address, NSArray *businesses) {
        
        self.businesses = businesses;
        self.address = address;
        
    } failure:^(NSError *error) {
        NSLog(@"Rate selector is fucked %@", error);
    }];
}
- (IBAction)refreshButtonClicked:(id)sender {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // Stop updating location
    // Rely on the user manually refreshing to update the list of locations
    [self.locationManager stopUpdatingLocation];
    
    [self refreshNearbyBusinessesAtLat:newLocation.coordinate.latitude lon:newLocation.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //    NSLog(@"Unable to start location manager. Error:%@", [error description]);
    
    //    [alertLabel setHidden:NO];
    NSLog(@"Failed to get location %@", error);
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
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Business Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    BiTBusiness *business = [self.businesses objectAtIndex:indexPath.row];
    cell.textLabel.text = business.businessName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f m", (business.distance * 1000)];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    BiTBusiness *business = [self.businesses objectAtIndex:indexPath.row];
    NSLog(@"Selected business %@", business);
    
    // check if the selected business has a category
    if(business.categories && business.categories.count > 0) {
        NSLog(@"We have categories, so segue to the rating area.");
        [self performSegueWithIdentifier:@"Show Rate" sender:self];
    } else {
        NSLog(@"We dont have categories, so lets assign one. Cat %@ Count %d", business.categories, business.categories.count);
        [self performSegueWithIdentifier:@"Show Assign Category" sender:self];
    }
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
