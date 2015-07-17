//
//  DYTakePhotosViewController.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/6/15.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import "DYTakePhotosViewController.h"
#import "ReactiveCocoa.h"

@interface DYTakePhotosViewController ()

@end

@implementation DYTakePhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.takePhotosBtn addTarget:self action:@selector(tap0) forControlEvents:UIControlEventTouchUpInside];
    [self.takePhotosBtn addTarget:self action:@selector(tap0) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tap0
{
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<1111");
}

- (void)tap1
{
    NSLog(@"2222");
}

@end
