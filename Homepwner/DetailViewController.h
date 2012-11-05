//
//  DetailViewController.h
//  Homepwner
//
//  Created by Carlo Andaya on 10/24/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    
    UIPopoverController *imagePickerPopover;
}

- (IBAction)changeDate:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)removePicture:(id)sender;

// Checks whether the instance of DetailViewController is being used to
// create a new BNRItem or to show an existing one.
- (id)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock) (void);

@end
