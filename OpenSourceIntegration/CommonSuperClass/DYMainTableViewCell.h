//
//  DYMainTableViewCell.h
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/4/8.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYMainTableViewCell : UITableViewCell

@property (nonatomic) CGFloat leftInsets;
@property (nonatomic) BOOL firstCell;
@property (nonatomic) BOOL lastCell;

@property (strong, nonatomic) UIView *sepline;
@property (strong, nonatomic) UIView *topSepline;

@end
