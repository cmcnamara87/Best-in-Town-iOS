//
//  BiTBestTableViewController.m
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTCategoryTableViewController.h"
#import "BiTApiController.h"
#import "BiTBusiness.h"
#import "UIImageView+AFNetworking.h"
#import "BiTListTableViewController.h"
#import "BiTLocationManager.h"
#import "BiTNearbyViewController.h"

@interface BiTCategoryTableViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *nearbyBusinesses;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nearbyButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) NSString *address;
@end

@implementation BiTCategoryTableViewController
@synthesize locationManager = _locationManager;
@synthesize nearbyBusinesses = _nearbyBusinesses;
@synthesize address = _address;
@synthesize nearbyButton = _nearbyButton;
@synthesize cityLabel = _cityLabel;
@synthesize categories = _categories;
@synthesize isSubcategory = _isSubcategory;
@synthesize category = _category;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the categories (if this isnt a sub-category...)
    self.tableView.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidUnload
{
    [self setNearbyButton:nil];
    [self setCityLabel:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshCategories];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([[segue identifier] isEqualToString:@"Show Subcategory"]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSInteger row = indexPath.row;
        NSLog(@"Row selected: %d", row);
        
        // Get out the current category
        BiTCategory *currentCategory = [self.categories objectAtIndex:row];
        
        [[segue destinationViewController] setIsSubcategory:YES];
        [[segue destinationViewController] setCategories:currentCategory.subcategories];
        
        NSLog(@"Setting destination name to be %@", currentCategory.categoryName);
        [[segue destinationViewController] setCategory:currentCategory];
        
    } else if ([[segue identifier] isEqualToString:@"Show List"]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSInteger row = indexPath.row;
        NSLog(@"Row selected: %d", row);
        
        // Get out the current category
        BiTCategory *currentCategory = [self.categories objectAtIndex:row];
        
        // TODO: Add city id to loading controller
        [[segue destinationViewController] setCategory:currentCategory];
    } else if ([segue.identifier isEqualToString:@"Show Nearby"]) {
        [[segue destinationViewController] setCategory:[self category]];
        [[segue destinationViewController] setBusinesses:[self nearbyBusinesses]];
        [[segue destinationViewController] setAddress:[self address]];
    }
}

#pragma mark Accessors
- (void) setCategories:(NSArray *)categories {
    NSLog(@"Categories set");
    if(categories != _categories) {
        _categories = categories;
        [self.tableView reloadData];
        
    }
}

- (void)setCategory:(BiTCategory *)category
{
    if(category != _category) {
        _category = category;
        self.title = category.categoryName;
    }
}

- (void)setNearbyBusinesses:(NSArray *)nearbyBusinesses
{
    if(nearbyBusinesses != _nearbyBusinesses) {
        _nearbyBusinesses = nearbyBusinesses;
        
        // Badge the nearby icon
        self.nearbyButton.title = [NSString stringWithFormat:@"Nearby (%d)", nearbyBusinesses.count];
        
        [self.tableView reloadData];
    }
}

#pragma mark Actions
- (void)refreshCategories
{
    if (!self.isSubcategory) {
            
        [BiTCategory getCategoriesOnSuccess:^(NSArray *categories) {
            self.categories = categories;
            
            [self refreshNearbyBusinesses];
            
        } failure:^(NSError *error) {
            NSLog(@"Categories are fucked %@", error);
        }];
    } else {
        [self refreshNearbyBusinesses];
    }
}

- (void)refreshNearbyBusinesses
{
    [[BiTLocationManager locationManager] locationOnSuccess:^(BiTCity *city, CLLocation *location) {
        
        // TODO: make it show the actual country for the nearby 
        self.cityLabel.text = [NSString stringWithFormat:@"%@, %@", city.cityName, @"Australia"];
        
        [BiTBusiness getNearbyBestBusinessesInCity:city.cityId 
                                             atLat:location.coordinate.latitude 
                                               lon:location.coordinate.longitude 
                                           radiusM:2000 underCategory:[[self category] categoryId] 
                                         onSuccess:^(NSString *address, NSArray *businesses) {
                                             self.nearbyBusinesses = businesses;
                                             self.address = address;
                                         } failure:^(NSError *error) {
                                             NSLog(@"Failed to get nearby businesses %@", error);
                                         }];
        
    } failure:^{
        NSLog(@"Failed to get city/lat lon");
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categories count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NewCategoryCellIdentifier = @"New Category Cell";
    static NSString *CategoryCellIdentifier = @"Category Cell";
    UITableViewCell *cell = nil;
    
    if(indexPath.row == self.categories.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:NewCategoryCellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
        
        BiTCategory *cat = [self.categories objectAtIndex:indexPath.row];
        cell.textLabel.text = cat.categoryName;
        
        // Calculate the nearby count
        int nearbyCount = 0;
        // TODO: make this count for more than 2 levels deep
        for(BiTBusiness *nearbyBusiness in self.nearbyBusinesses) {
            for(BiTCategory *nearbyCategory in nearbyBusiness.categories) {
                if(nearbyCategory.categoryId == cat.categoryId ||
                   nearbyCategory.parentId == cat.categoryId) {
                    nearbyCount++;
                }
            }
        }
        if(nearbyCount) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Places Nearby", nearbyCount];
        } else {
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check if its the add new category button
    if(indexPath.row == self.categories.count) {
        // do nothing, its the new cat button
    } else {
        // Get out the category clicked on
        BiTCategory *category = [self.categories objectAtIndex:indexPath.row];
        
        // If there are sub-categories, show them, else, go to the list
        if(category.subcategories) {
            [self performSegueWithIdentifier:@"Show Subcategory" sender:indexPath];
        } else {
            [self performSegueWithIdentifier:@"Show List" sender:indexPath];
        }
    }
}

@end
