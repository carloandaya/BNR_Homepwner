//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Carlo Andaya on 9/8/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

@synthesize containedItem, container, itemName, serialNumber, valueInDollars, dateCreated;

- (void)setContainedItem:(BNRItem *)i {
    containedItem = i;
    
    // When given an item to contain, the contained
    // item will be given a pointer to its container
    [i setContainer:self];
}

+ (id)randomItem
{
    // create an array of three adjectives
    NSArray *randomAdjectiveList = [[NSArray alloc] initWithObjects:@"Fluffy",
                                    @"Rusty",
                                    @"Shiny",
                                    nil];
    
    // create an array of three nouns
    NSArray *randomNounList = [[NSArray alloc] initWithObjects:@"Bear", @"Spork", @"Mac", nil];
    
    // get a random adjective and a random noun
    NSInteger randomAdjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger randomNounIndex = rand() % [randomNounList count];
    
    NSString *randomString = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:randomAdjectiveIndex], [randomNounList objectAtIndex:randomNounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomString
                                          valueInDollars:randomValue
                                            serialNumber:randomSerialNumber];
    
    return newItem;
}

// this is the designated initializer, which all the other initializer methods will call
- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super init];
    
    if (self)
    {
        // give the instance variables initial values
        [self setItemName:name];
        [self setValueInDollars:value];
        [self setSerialNumber:sNumber];
        dateCreated = [[NSDate alloc] init];
    }
    
    // return the address of the newly initialized object
    return self;
}

// override the default initializer
- (id)init
{
    return [self initWithItemName:@"Item"
                   valueInDollars:0
                     serialNumber:@""];
}

// initializer that sets only the name
- (id)initWithItemName:(NSString *)name {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (NSString *)description {
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    return descriptionString;
}

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:sNumber];
}

- (void)dealloc {
    NSLog(@"Destroyed: %@", self);
}

@end
