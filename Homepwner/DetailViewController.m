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

@end
