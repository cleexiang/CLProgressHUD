//
//  ViewController.m
//  CLProgressHUDDemo
//
//  Created by lixiang on 13-12-12.
//  Copyright (c) 2013年 cleexiang. All rights reserved.
//

#import "ViewController.h"
#import "CLProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

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
    CLProgressHUD *hud = [CLProgressHUD shareInstance];
    hud.type = CLProgressHUDTypeDarkForground;
    hud.shape = CLProgressHUDShapeLinear;
    [hud showInView:self.view withText:@"loadadjoiaduiywiyuiqyquiyq"];
    [hud performSelector:@selector(dismiss) withObject:nil afterDelay:5];
}

@end
