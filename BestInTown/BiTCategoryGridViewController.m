//
//  BiTCategoryGridViewController.m
//  BestInTown
//
//  Created by Justin Marrington on 21/05/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTCategoryGridViewController.h"
#import "BiTCategoryCell.h"
#import "BiTCategory.h"
#import "BiTBusiness.h"
#import "BiTLocationManager.h"

#define kCategoryCellSize 113.0
#define kCategoryMargin 4.0

@interface BiTCategoryGridViewController ()

@property (nonatomic, assign) BOOL isSubcategory;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) BiTCategory *category;
@property (nonatomic, strong) NSArray *nearbyBusinesses;
@property (nonatomic, strong) NSString *address;
@end

@implementation BiTCategoryGridViewController
@synthesize isSubcategory;
@synthesize categories = _categories;
@synthesize category = _category;
@synthesize nearbyBusinesses = _nearbyBusinesses;
@synthesize address = _address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refreshCategories];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Accessors
- (void) setCategories:(NSArray *)categories {
    NSLog(@"Categories set");
    if(categories != _categories) {
        _categories = categories;
        [self.gridView reloadData];
        
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
        [self.gridView reloadData];
    }
}


- (void)refreshCategories
{
    if (!self.isSubcategory) {
        
        [BiTCategory getCategoriesOnSuccess:^(NSArray *categories) {
            self.categories = categories;
            
            //[self refreshNearbyBusinesses];
            
        } failure:^(NSError *error) {
            NSLog(@"Categories are fucked %@", error);
        }];
    } else {
        //[self refreshNearbyBusinesses];
    }
}

//- (void)refreshNearbyBusinesses
//{
//    [[BiTLocationManager locationManager] locationOnSuccess:^(BiTCity *city, CLLocation *location) {
//        
//        // TODO: make it show the actual country for the nearby 
//        //self.cityLabel.text = [NSString stringWithFormat:@"%@, %@", city.cityName, @"Australia"];
//        
//        [BiTBusiness getNearbyBestBusinessesInCity:city.cityId 
//                                             atLat:location.coordinate.latitude 
//                                               lon:location.coordinate.longitude 
//                                           radiusM:2000 underCategory:[[self category] categoryId] 
//                                         onSuccess:^(NSString *address, NSArray *businesses) {
//                                             self.nearbyBusinesses = businesses;
//                                             self.address = address;
//                                         } failure:^(NSError *error) {
//                                             NSLog(@"Failed to get nearby businesses %@", error);
//                                         }];
//        
//    } failure:^{
//        NSLog(@"Failed to get city/lat lon");
//    }];
//}

#pragma mark AQGridViewDatasource methods
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
    NSLog(@"Category count: %d", [self.categories count]);
    return [self.categories count];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *cellIdentifier = @"Category Grid Cell";
    BiTCategoryCell *catCell = (BiTCategoryCell *)[self.gridView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (catCell == nil) {
        catCell = [[BiTCategoryCell alloc] initWithFrame:CGRectMake(0.0, 0.0, kCategoryCellSize, kCategoryCellSize) reuseIdentifier:cellIdentifier];
    }
    
    BiTCategory *cat = [self.categories objectAtIndex:index];
    catCell.categoryLabel.text = cat.categoryName`;
    
    return catCell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    NSLog(@"%@", NSStringFromCGSize(CGSizeMake(kCategoryCellSize + kCategoryMargin * 2, 
                                               kCategoryCellSize + kCategoryMargin * 2)));
    return CGSizeMake(kCategoryCellSize + kCategoryMargin * 2, 
                      kCategoryCellSize + kCategoryMargin * 2);
    
}

#pragma mark AQGridViewDelegate methods
- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    BiTCategory *category = [self.categories objectAtIndex:index];
    // If there are sub-categories, show them, else, go to the list
    AQGridViewCell *cell = [self.gridView cellForItemAtIndex:index];
    
    if(category.subcategories) {
        [self performSegueWithIdentifier:@"Show Subcategory" sender:cell];
    } else {
        [self performSegueWithIdentifier:@"Show List" sender:cell];
    }
}

@end
