//
//  DYLoginViewController.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/4/8.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "DYLoginViewController.h"
#import "DYLoginTableViewCell.h"


static NSString *kCellIdentifier = @"InputTextField";

@interface DYLoginViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *loginTableView;

@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;

@end

@implementation DYLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginTableView.layer.borderWidth = 0.5f;
    self.loginTableView.layer.cornerRadius = 5.0f;
    self.loginTableView.clipsToBounds = YES;
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DYLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        self.username = cell.inputTextField;
        self.username.placeholder = @"请输入用户名";
    } else {
        self.password = cell.inputTextField;
        self.password.placeholder = @"请输入密码";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)setUsername:(UITextField *)username
{
    _username = username;
    [self.username.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
}

- (void)setPassword:(UITextField *)password
{
    _password = password;
    _password.secureTextEntry = YES;
    [self.password.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}





@end
