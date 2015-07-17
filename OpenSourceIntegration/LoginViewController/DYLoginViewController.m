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


@property (weak, nonatomic) IBOutlet UIView *flipView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UITableView *loginTableView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;

@end

@implementation DYLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.words = @"没啥问题";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginTableView.layer.borderWidth = 0.5f;
    self.loginTableView.layer.cornerRadius = 5.0f;
    self.loginTableView.clipsToBounds = YES;
    
    self.loginBtn.layer.cornerRadius = 2.0f;
    self.loginBtn.clipsToBounds = YES;
    __block NSInteger i = 0;
    self.label2.hidden = YES;
    @weakify(self);
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        UIViewController *vc = [UIViewController new];
        [self presentViewController:vc animated:YES completion:^{
            @strongify(self);
            NSLog(@"window:%@", self.view.window);
        }];
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
        cell.leftInsets = 75.0f;
    } else {
        self.password = cell.inputTextField;
        self.password.placeholder = @"请输入密码";
        cell.sepline.hidden = YES;
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
