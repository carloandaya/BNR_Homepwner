//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Carlo Andaya on 10/20/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation ItemsViewController

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    // This will ensure that all instances of ItemsViewController use the
    // UITableViewStyleGrouped style, no matter what initialization message
    // is sent to it.
    return [self init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // Sort the array according to the values of the items
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    NSArray *sortedArray = [items sortedArrayUsingComparator:^(id obj1, id obj2) {
        if ([obj1 valueInDollars] > [obj2 valueInDollars]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 valueInDollars] < [obj2 valueInDollars]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSIndexSet *section0 = [items indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        if ([(BNRItem *)obj valueInDollars] < 50)
            return YES;
        else
            return NO;
    }];
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    
    BNRItem *p;
    if ([indexPath section] == 0) {
        p = [sortedArray objectAtIndex:[indexPath row]];
    }
    else {
        p = [sortedArray objectAtIndex:[indexPath row] + [section0 count]];
    }
    
    [[cell textLabel] setText:[p description]];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    NSIndexSet *section0 = [items indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        if ([(BNRItem *)obj valueInDollars] < 50)
            return YES;
        else
            return NO;
    }];
    
    if (section == 0) {
        // count the number of items that are less than or equal to $50
        return [section0 count];
    }
    else {
        // count the number of items that are greater than $50
        return [items count] - [section0 count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
