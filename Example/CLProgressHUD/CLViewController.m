//
//  CLViewController.m
//  CLProgressHUD
//
//  Created by clee on 04/15/2017.
//  Copyright (c) 2017 clee. All rights reserved.
//

#import "CLViewController.h"
#import <CLProgressHUD/CLProgressHUD.h>

@interface CLViewController ()

@end

@implementation CLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    CLProgressHUD *hud = [[CLProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.text = @"Loading...";
    hud.shape = CLProgressHUDShapeCircle;
    hud.type = CLProgressHUDTypeDarkForground;
    [hud showWithAnimation:YES duration:3.0];
}

@end
