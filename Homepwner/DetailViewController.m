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

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
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
    
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
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
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    // Place image picker on screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
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
    
    // Take image picker off the screen -
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
