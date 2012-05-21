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
#import "BiTLocationManager.h"
#import "BiTNearbyBusinessCell.h"
#import "BiTCategory.h"
#import <CoreLocation/CoreLocation.h>

@interface BiTRateSelectorTableViewController () <BiTAssignCategoryTableViewControllerDelegate>
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSString *address;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) CLLocation *lastGotLocation;
@end

@implementation BiTRateSelectorTableViewController
@synthesize lastGotLocation;
@synthesize businesses = _businesses;
@synthesize address = _address;
@synthesize addressLabel = _addressLabel;


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
    
    

}

- (void)viewDidUnload
{
    [self setAddressLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
}
- (void)viewDidAppear:(BOOL)animated
{

    [self refreshNearbyBusinesses];
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
        [segue.destinationViewController setDelegate:self];
    } else if ([segue.identifier isEqualToString:@"Show Rate"]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger rowNumber = selectedIndexPath.row;
        
        // Get out the business
        BiTBusiness *business = [self.businesses objectAtIndex:rowNumber];
        [segue.destinationViewController setBusiness:business];
    }

}

#pragma mark Accessors
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
        self.addressLabel.text = address;
    }
}

#pragma mark Actions
- (void)refreshNearbyBusinesses
{
    [[BiTLocationManager locationManager] locationOnSuccess:^(BiTCity *city, CLLocation *location) {
        
        int radiusM = 500;
        
        // Check how far it is from the previous location
        if(![self lastGotLocation] || [location distanceFromLocation:[self lastGotLocation]] > 100) {
            
            self.businesses = nil;
            self.address = @"Finding location...";
            
            [BiTBusiness getNearbyAllBusinessesInCity:city.cityId atLat:location.coordinate.latitude lon:location.coordinate.longitude radiusM:radiusM onSuccess:^(NSString *address, NSArray *businesses) {
                
                // save the location we fetched from
                self.lastGotLocation = location;
                
                // Set the data
                self.businesses = businesses;
                self.address = address;
                
            } failure:^(NSError *error) {
                NSLog(@"Rate selector is fucked %@", error);
            }];
        } else {

        }
        
    } failure:^{
        
    }];
}
- (IBAction)refreshButtonClicked:(id)sender {
    [self refreshNearbyBusinesses];
}

- (void)assignCategoryTableViewController:(BiTAssignCategoryTableViewController *)assignCategoryTableViewController
                   didAddCategory:(BiTCategory *)category
                               toBusiness:(BiTBusiness *)business
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"Business Distance Cell";
    BiTNearbyBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    [cell displayBusiness:[self.businesses objectAtIndex:indexPath.row]];
    
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
}


#pragma mark - BiTAssignCategoryTableViewController Delegate
- (void)assignCategoryTableViewController:(BiTAssignCategoryTableViewController *)sender assignedCategory:(BiTCategory *)category toBusiness:(BiTBusiness *)business
{
    NSLog(@"Category assigned to Business");

    [self.presentedViewController dismissModalViewControllerAnimated:YES];
    
    [self performSegueWithIdentifier:@"Show Rate" sender:self];
    
    /* Update the tableview */
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSInteger rowNumber = selectedIndexPath.row;
    NSMutableArray *updatedBusinesses = [self.businesses mutableCopy];
    [updatedBusinesses replaceObjectAtIndex:rowNumber withObject:business];
    self.businesses = [updatedBusinesses copy]; 
    
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}
- (void)assignCategoryTableViewControllerDidNotAssignCategory:(BiTAssignCategoryTableViewController *)sender
{
    NSLog(@"No category assigned");
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}


@end
