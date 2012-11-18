//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Carlo Andaya on 10/20/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}

- (IBAction)addNewItem:(id)sender;

@end
