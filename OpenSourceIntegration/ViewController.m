//
//  ViewController.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/3/3.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import "ViewController.h"
#import "WYPopoverController.h"
#import "WYStoryboardPopoverSegue.h"

@interface ViewController () <WYPopoverControllerDelegate>
{
    WYPopoverController* popoverController;
}


@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


}

- (IBAction)showPopover:(id)sender
{
    UIViewController *popVc = [UIViewController new];
    popVc.preferredContentSize = CGSizeMake(110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 110, 30)];
    label.text = @"风险率80%";
    [popVc.view addSubview:label];
    popoverController = [[WYPopoverController alloc] initWithContentViewController:popVc];
    popoverController.delegate = self;
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(30, 40, 50, 50)];
    [self.view addSubview:rectView];
    [popoverController presentPopoverFromRect:rectView.bounds inView:rectView permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
