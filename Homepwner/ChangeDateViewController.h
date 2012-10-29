//
//  ChangeDateViewController.h
//  Homepwner
//
//  Created by Carlo Andaya on 10/26/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface ChangeDateViewController : UIViewController
{
    IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, strong) BNRItem *item;

@end
