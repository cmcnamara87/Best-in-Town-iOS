//
//  BiTRatingTableViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 4/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTRatingTableViewController.h"
#import "BiTVisit.h"
#import "BiTMatch.h"
#import <CoreLocation/CoreLocation.h>

@interface BiTRatingTableViewController () 
@property (nonatomic, strong) NSArray *businesses;
@end

@implementation BiTRatingTableViewController 
@synthesize business = _business;
@synthesize businesses = _businesses;

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
    
    self.tableView.scrollEnabled = false;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Showing root view controller for rating table view");
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions
- (IBAction)saveButton:(id)sender {
    NSLog(@"Save Rating");
    
    // Create visit
    [BiTVisit addVisitForBusiness:self.business.businessId user:1 onSuccess:^(BiTVisit *visit) {
        NSLog(@"Visit added");  
        
        // Add match results
        // lets find where the current business is after they have finished rating
        int selectedBusinessIndex = 0;
        for(BiTBusiness *currentBusiness in self.businesses) {
            if(currentBusiness.businessId = self.business.businessId) {
                break;
            }
            selectedBusinessIndex++;
        }
        
        for(int i = 0; i < self.businesses.count; i++) {
            BiTBusiness *pastBusiness = [self.businesses objectAtIndex:i];
            
            if(i == selectedBusinessIndex) continue;
            
            if(selectedBusinessIndex < i) {
                // the selected business won
                [BiTMatch addMatchForWinningBusiness:self.business.businessId losingBusiness:pastBusiness.businessId forVisit:visit.visitId onSuccess:^{
                   
                    NSLog(@"Match added");
                } failure:^(NSError *error) {
                    NSLog(@"Failed to add match %@", error);
                }];
            } else if(selectedBusinessIndex > i) {
                // the selected business won
                [BiTMatch addMatchForWinningBusiness:pastBusiness.businessId losingBusiness:self.business.businessId forVisit:visit.visitId onSuccess:^{
                    
                    NSLog(@"Match added");
                } failure:^(NSError *error) {
                    NSLog(@"Failed to add match %@", error);
                }];
            }
        }
//        [self.navigationController setViewControllers:[NSArray array]];
        
//        UINavigationController * navigationController = [self.tabBarController.viewControllers objectAtIndex:1];
//        
//        [navigationController pushViewController:detailViewController animated:NO];
//        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        

  
    } failure:^(NSError *error) {
        NSLog(@"Failed to log visit %@", error);
    }];
    
    
    }



#pragma mark Accessors
- (void)setBusiness:(BiTBusiness *)business
{
    if(business != _business) {
        _business = business;
        
        business.selectedBusiness = YES;
        
        // Get the other businesses to rate
        [BiTBusiness getBusinessesToRateForUser:1 business:self.business.businessId onSuccess:^(NSArray *businesses) {
            NSLog(@"GOT BUSINESSES TO RATE %@", businesses);
            
            // Add the current business into the list
            NSMutableArray *mutableBusinesses = businesses.mutableCopy;
            if(mutableBusinesses.count == 0) {
                [mutableBusinesses insertObject:self.business atIndex:0];
            } else {
                [mutableBusinesses insertObject:self.business atIndex:1]; 
            }
            
            // Store the businesses
            self.businesses = mutableBusinesses.copy;
            
        } failure:^(NSError *error) {
            NSLog(@"Failed to get businesses to rank %@", error);
        }];
    }
}
- (void)setBusinesses:(NSArray *)businesses
{
    if(businesses != _businesses) {
        _businesses = businesses;
        
        // if we only have one business (no previous similar visits)
        // we will just submit the visit automatically)
        if(self.businesses.count == 1) {
            [BiTVisit addVisitForBusiness:self.business.businessId user:1 onSuccess:^(BiTVisit *visit) {
                NSLog(@"Visit added");                
            } failure:^(NSError *error) {
                NSLog(@"Failed to log visit %@", error);
            }];
        } else {
            [self.tableView reloadData];  
            [self.tableView setEditing:YES];
        }
    }
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
    static NSString *CellIdentifier = @"Selected Business Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    BiTBusiness *business = [self.businesses objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1, business.businessName];
    cell.detailTextLabel.text = @"Should be the date";
    if(business.selectedBusiness) {
        cell.backgroundColor = [UIColor greenColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];        
    }
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


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView 
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
      toIndexPath:(NSIndexPath *)destinationIndexPath 
{
    
    NSMutableArray *mutableBusinesses = self.businesses.mutableCopy;
    
    BiTBusiness *movingBusiness = [mutableBusinesses objectAtIndex:sourceIndexPath.row];
    [mutableBusinesses removeObjectAtIndex:sourceIndexPath.row];
    [mutableBusinesses insertObject:movingBusiness atIndex:destinationIndexPath.row];
    
    self.businesses = mutableBusinesses.copy;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    BiTBusiness *business = [self.businesses objectAtIndex:indexPath.row];
    if(business.selectedBusiness == YES) return YES;

    return NO;
}

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
