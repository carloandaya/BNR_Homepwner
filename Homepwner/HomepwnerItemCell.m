//
//  HomepwnerItem.m
//  Homepwner
//
//  Created by Carlo Andaya on 11/17/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

@synthesize thumbnailView,nameLabel,serialNumberLabel,valueLabel, controller, tableView;

- (IBAction)showImage:(id)sender {
    
    // Get the name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    
    // Make the selector "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) 
        {
            [[self controller] performSelector:newSelector
                                    withObject:sender
                                    withObject:indexPath];
        }
    }
}
@end
