//
//  BiTBestTableViewController.m
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTBestTableViewController.h"
#import "BiTApiController.h"
#import "BiTCategory.h"
#import "UIImageView+AFNetworking.h"
#import "BiTListTableViewController.h"

@interface BiTBestTableViewController ()
@end

@implementation BiTBestTableViewController
@synthesize categories = _categories;
@synthesize isSubcategory = _isSubcategory;
@synthesize categoryName = _categoryName;

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
    if (!self.isSubcategory) {
        [self refreshCategories];
    } 
    
    /*if(self.navigationItem.backBarButtonItem) {
      self.navigationItem.backBarButtonItem.title = @"Best";  
    }*/
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

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    NSInteger row = indexPath.row;
    NSLog(@"Row selected: %d", row);
    
    // Get out the current category
    BiTCategory *currentCategory = [self.categories objectAtIndex:row];
    
    if ([[segue identifier] isEqualToString:@"Show Subcategory"]) {
        [[segue destinationViewController] setIsSubcategory:YES];
        [[segue destinationViewController] setCategories:currentCategory.subcategories];
        
        NSLog(@"Setting destination name to be %@", currentCategory.categoryName);
        [[segue destinationViewController] setCategoryName:currentCategory.categoryName];
        
    } else if ([[segue identifier] isEqualToString:@"Show List"]) {
        // TODO: Add city id to loading controller
        [[segue destinationViewController] setCategory:currentCategory];
    }
}

#pragma mark Accessors
- (void) setCategories:(NSArray *)categories {
    if(categories != _categories) {
        _categories = categories;
        [self.tableView reloadData];
        
    }
}
- (void) setCategoryName:(NSString *)categoryName {
    if(categoryName != _categoryName) {
        _categoryName = categoryName;
        self.title = categoryName;
    }
}

#pragma mark Actions
- (void)refreshCategories
{
    [[BiTApiController sharedApi] getCategoriesOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Data:\n %@", responseObject);
        NSMutableArray *categoriesArray = [NSMutableArray array];
        for (NSString *categoryId in responseObject) {
            NSDictionary *categoryData = [responseObject valueForKey:categoryId];
            BiTCategory *category = [BiTCategory buildCategory:categoryId fromDict:categoryData];
            [categoriesArray addObject:category];
        }
        
        self.categories = [categoriesArray copy];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fuck it.");
    }];
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
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Category Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BiTCategory *cat = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = cat.categoryName;
    // Configure the cell...
    
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
    if (self.isSubcategory) {
        [self performSegueWithIdentifier:@"Show List" sender:indexPath];
    } else {
        [self performSegueWithIdentifier:@"Show Subcategory" sender:indexPath];
    }
}

@end
