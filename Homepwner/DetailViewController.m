//
//  DetailViewController.m
//  Homepwner
//
//  Created by Carlo Andaya on 10/24/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "ChangeDateViewController.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "AssetTypePicker.h"

@interface DetailViewController ()
- (void)save:(id)sender;
- (void)cancel:(id)sender;

@end

@implementation DetailViewController
@synthesize dismissBlock;
@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *clr;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    
    [[self view] setBackgroundColor:clr];
    
    [nameField setDelegate:self];
    [serialNumberField setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Convert time interval to NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:date]];
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
    
    NSString *typeLabel = [[item assetType] valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = @"None";
    }
    
    [assetTypeButton setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel]
                     forState:UIControlStateNormal];
    
    // set the title of the navigation bar
    [[self navigationItem] setTitle:[item itemName]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // "Save" changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)changeDate:(id)sender
{
    // Create the ChangeDateViewController
    ChangeDateViewController *cdvc = [[ChangeDateViewController alloc] init];
    
    // Pass BNRItem
    [cdvc setItem:item];
    
    [[self navigationController] pushViewController:cdvc animated:YES];
}

- (IBAction)takePicture:(id)sender {
    if ([imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setAllowsEditing:YES];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        
        
        // Display the popover controller; sender
        // is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        // Place image picker on screen
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)removePicture:(id)sender {
    NSString *oldKey = [item imageKey];
    
    // Did the item already have an image?
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    [imageView setImage:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    
    // Did the item already have an image?
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [item setThumbnailDataFromImage:image];
    
    // Generate a unique id for every time a picture is taken
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    // Create a string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    // Store image in the BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image forKey:key];
    
    // Need to release the CF objects because their pointers will be destroyed
    // when this method ends and ARC will not clean up
    CFRelease(newUniqueID);
    CFRelease(newUniqueIDString);
    
    // Put that image onto the screen in our image view
    [imageView setImage:image];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // Take image picker off the screen -
        // you must call this dismiss method
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
    

}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == assetTypePopover) {
        NSLog(@"User dismissed the asset type popover");
        // Set the asset type picker button's title accordingly
        NSString *typeLabel = [[item assetType] valueForKey:@"label"];
        if (!typeLabel) {
            typeLabel = @"None";
        }
            
        [assetTypeButton setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel]
                        forState:UIControlStateNormal];

    }
    
    if (popoverController == imagePickerPopover) {
        NSLog(@"User dismissed the image picker popover");
        imagePickerPopover = nil;
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == nameField) {
        [[self navigationItem] setTitle:[textField text]];
    }
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self) {
        if (isNew) { // if we are creating a new item
            
            // create a done button and put it on the right side of the navigation bar
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            // create a cancel button and put it on the left side of the navigation bar
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    
    return nil;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancels, remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:item];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (IBAction)showAssetTypePicker:(id)sender
{
    [[self view] endEditing:YES];
    
    AssetTypePicker *assetTypePicker = [[AssetTypePicker alloc] init];
    [assetTypePicker setItem:item];
    
    if (assetTypePopover.isPopoverVisible) {
        // dismiss the popover and set it to nil then return
        [assetTypePopover dismissPopoverAnimated:YES];
        assetTypePopover = nil;
        return;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // present the assetTypePicker table in the popover
        UINavigationController *assetNavController = [[UINavigationController alloc] initWithRootViewController:assetTypePicker];
        assetTypePopover = [[UIPopoverController alloc] initWithContentViewController:assetNavController];
        // set the size of the popover
        assetTypePopover.popoverContentSize = CGSizeMake(320.0, 400.0);
        // set the delegate of the popover
        assetTypePopover.delegate = self;
        
        // present the popover on the asset type selector button
        [assetTypePopover presentPopoverFromRect:assetTypeButton.frame
                                          inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                        animated:YES];
        
    } else {
        [[self navigationController] pushViewController:assetTypePicker animated:YES];
    }
}
@end
