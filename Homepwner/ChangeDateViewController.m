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
    
    [datePicker setDate:[item dateCreated]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [item setDateCreated:[datePicker date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
