//
//  DetailViewController.h
//  Homepwner
//
//  Created by Carlo Andaya on 10/24/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
}

- (IBAction)changeDate:(id)sender;

@property (nonatomic, strong) BNRItem *item; 

@end
