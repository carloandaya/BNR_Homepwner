//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Carlo Andaya on 10/20/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

+ (BNRItemStore *)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// This method returns an array of items in a non-mutable form
- (NSArray *)allItems
{
    return allItems;
}

- (BNRItem *)createItem
{
    // Create a random item
    BNRItem *p = [BNRItem randomItem];
    
    // Add that item to the mutable array
    [allItems addObject:p];
    return p;
}

- (void)removeItem:(BNRItem *)p
{
    [allItems removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) { // if the object is not being moved
        return;
    }
    
    // Get pointer to object being moved so we can re-insert it
    BNRItem *p = [allItems objectAtIndex:from];
    
    // Remove p from array
    [allItems removeObjectAtIndex:from];
    
    // Insert p in array at new location
    [allItems insertObject:p atIndex:to];
}

@end
