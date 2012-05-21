//
//  BiTAssignCategoryTableViewController.m
//  BestInTown
//
//  Created by Craig McNamara on 30/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTAssignCategoryTableViewController.h"
#import "BiTCategory.h"
#import "BiTRateSelectorTableViewController.h"

@interface BiTAssignCategoryTableViewController ()
@property (nonatomic, strong) NSArray *categories;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@end

@implementation BiTAssignCategoryTableViewController
@synthesize delegate;
@synthesize categories = _categories;
@synthesize actionButton = _actionButton;
@synthesize business = _business;

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
    
    [self refreshCategories];
}

- (void)viewDidUnload
{
    [self setActionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Show Rate"]) {
        // Segue to the rate controller
        // Send it the business its rating
        [segue.destinationViewController setBusiness:self.business];
    }
}

#pragma mark Accessors
- (void)setCategories:(NSArray *)categories {
    if(categories != _categories) {
        _categories = categories;
        [self.tableView reloadData];
    }
}
#pragma mark Actions
- (void)refreshCategories
{
    [BiTCategory getLeafCategoriesOnSuccess:^(NSArray *categories) {
        self.categories = categories;
    } failure:^(NSError *error) {
        NSLog(@"Categories are fucked %@", error);
    }];
}
- (IBAction)actionButtonPressed:(id)sender {
    NSArray *indexPathsOfSelectedRows = [self.tableView indexPathsForSelectedRows];
    
    if([indexPathsOfSelectedRows count]) {
        [self.delegate assignCategoryTableViewController:self assignedCategory:nil toBusiness:self.business];
    } else {
        [self.delegate assignCategoryTableViewControllerDidNotAssignCategory:self];
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
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Category Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    BiTCategory *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.categoryName;
    
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone; 
    NSLog(@"Deselecting row");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BiTCategory *selectedCategory = [self.categories objectAtIndex:indexPath.row];
    
    // Give it a tick mark
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"Selecting");
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Assign that category to a table
    [BiTBusiness addBusiness:self.business.businessId toCategory:selectedCategory.categoryId onSuccess:^(BiTBusiness *business) {
        NSLog(@"Category assigned");
    } failure:^(NSError *error) {
        NSLog(@"Failed to assign category");
    }];
}

@end
