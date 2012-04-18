//
//  BiTNearbyViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 18/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTNearbyViewController.h"
#import "BiTBusiness.h"
#import "BiTBusinessDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface BiTNearbyViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
// Best businesses nearby
@property (nonatomic, strong) NSArray* businesses;
// Lookup of users current address based on lat/lon
@property (nonatomic, strong) NSString* address;
@end

@implementation BiTNearbyViewController
@synthesize locationManager;
@synthesize businesses = _businesses;
@synthesize address = _address;

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show Business"]) {
        // TODO: Handle Business detail view model
        BiTBusiness *currentBusiness = [self.businesses objectAtIndex:[self.tableView indexPathForCell:sender].row];
        [[segue destinationViewController] setBusiness:currentBusiness];
    }
}
#pragma mark Accessors
- (void)setAddress:(NSString *)address {
    if(_address != address) {
        _address = address;
        // TODO: set the address to display
    }
}
- (void)setBusinesses:(NSArray *)businesses {
    if(_businesses != businesses) {
        _businesses = businesses;
        [self.tableView reloadData];
    }
}

#pragma mark - CLLocationDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // Stop updating location
    // Rely on the user manually refreshing to update the list of locations
    [self.locationManager stopUpdatingLocation];
    
    [BiTBusiness exploreForCity:@"1213" 
                          atLat:newLocation.coordinate.latitude 
                            lon:newLocation.coordinate.longitude 
                         radius:5000 
                      onSuccess:^(NSString *address, NSArray *businesses) {
                          self.businesses = businesses;
                          self.address = address;
                      } 
                        failure:^(NSError *error) {
                            NSLog(@"Failed to get nearby businesses %@", error);
                        }
     ];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //    NSLog(@"Unable to start location manager. Error:%@", [error description]);
    
    //    [alertLabel setHidden:NO];
    NSLog(@"Failed to get location %@", error);
}

#pragma mark - Table view data source
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
    // Get out the current business
    BiTBusiness *business = [self.businesses objectAtIndex:indexPath.row];
    cell.textLabel.text = business.businessName;
    cell.detailTextLabel.text = business.city;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
