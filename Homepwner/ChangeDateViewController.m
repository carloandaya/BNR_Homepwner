//
//  ChangeDateViewController.m
//  Homepwner
//
//  Created by Carlo Andaya on 10/26/12.
//  Copyright (c) 2012 Carlo Andaya. All rights reserved.
//

#import "ChangeDateViewController.h"
#import "BNRItem.h"

@interface ChangeDateViewController ()

@end

@implementation ChangeDateViewController

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [datePicker setDatePickerMode:UIDatePickerModeDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Convert NSTimeInterval to NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
    
    [datePicker setDate:date];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Convert NSDate to NSTimeInterval
    NSDate *date = [datePicker date];
    
    [item setDateCreated:[date timeIntervalSinceReferenceDate]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
