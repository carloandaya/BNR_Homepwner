//
//  DetailViewController.h
//  Homepwner
//
//  Created by Carlo Andaya on 10/24/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
}

- (IBAction)changeDate:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@property (nonatomic, strong) BNRItem *item; 

@end
