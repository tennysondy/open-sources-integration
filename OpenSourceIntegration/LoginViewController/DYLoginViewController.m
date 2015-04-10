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

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


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
    
    self.loginBtn.layer.cornerRadius = 2.0f;
    self.loginBtn.clipsToBounds = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    RACSignal *validUsernameSignal = [self.username.rac_textSignal map:^id (NSString *text) {
        BOOL flag = text.length > 0;
        return @(flag);
    }];
    
    RACSignal *validPasswordSignal = [self.password.rac_textSignal map:^id (NSString *text) {
        BOOL flag = text.length > 0;
        return @(flag);
    }];
    RAC(self.loginBtn, backgroundColor) = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id (NSNumber *usernameValid, NSNumber *passwordValid) {
        BOOL flag = [usernameValid boolValue] && [passwordValid boolValue];
        return flag ? [UIColor blueColor] : [UIColor grayColor];
    }];
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
    
    
}


- (void)setPassword:(UITextField *)password
{
    _password = password;
    _password.secureTextEntry = YES;
    
}





@end
