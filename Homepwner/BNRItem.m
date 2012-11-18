//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Carlo Andaya on 9/8/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import "BNRItem.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation BNRItem

@synthesize containedItem, container, itemName, serialNumber, valueInDollars, dateCreated, imageKey, thumbnail, thumbnailData;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        [self setDateCreated:[aDecoder decodeObjectForKey:@"dateCreated"]];
    }
    
    return self;
}

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

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
}

- (UIImage *)thumbnail
{
    // If there is no thumbnailData, then I have no thumbnail to return
    if (!thumbnailData) {
        return nil;
    }
    
    // If I have not yet created my thumbnail image from my data, do so now
    if (!thumbnail) {
        // Create the image from the data
        [self setThumbnail:[UIImage imageWithData:[self thumbnailData]]];
    }
    
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Figure out a scaling ratio to make sure we maintain the same
    // aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
}

@end
