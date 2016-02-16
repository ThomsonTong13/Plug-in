//
//  ViewController.m
//  RootModule
//
//  Created by Thomson on 16/2/15.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import "ViewController.h"
#import <Core/Core.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender
{
    UIViewController *viewController = [[BusAccessor defaultBusAccessor] resourceWithURI:@"ui://Demo_DemoViewController"];

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
