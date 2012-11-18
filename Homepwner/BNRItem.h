//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Carlo Andaya on 9/8/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject <NSCoding>
// BNRItem needs to conform to NSCoding so that it can be archived

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;

- (void)setThumbnailDataFromImage:(UIImage *)image;

+ (id)randomItem;

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;
- (id)initWithItemName:(NSString *)name;

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;

- (void)setContainedItem:(BNRItem *)i;
- (BNRItem *)containedItem;

- (BNRItem *)container;
- (void)setContainer:(BNRItem *)i;

@end
