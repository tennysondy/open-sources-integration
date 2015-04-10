//
//  DYMainTableViewCell.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/4/8.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import "DYMainTableViewCell.h"
#import "Masonry.h"


@implementation DYMainTableViewCell

- (void)awakeFromNib
{
    self.topSepline = [UIView new];
    [self.contentView addSubview:self.topSepline];
    __weak typeof(self) weakSelf = self;
    [self.topSepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
    self.topSepline.backgroundColor = [UIColor lightGrayColor];
    self.topSepline.hidden = YES;
    
    self.sepline = [UIView new];
    [self.contentView addSubview:self.sepline];
    [self.sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(0, 10, 0, 0));
        make.height.mas_equalTo(0.5);
    }];
    self.sepline.backgroundColor = [UIColor lightGrayColor];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self awakeFromNib];
    }
    
    return self;
}

- (void)setLeftInsets:(CGFloat)leftInsets
{
    _leftInsets = leftInsets;
    __weak typeof(self) weakSelf = self;
    [self.sepline mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat constant = weakSelf.lastCell ? 0.0f : weakSelf.leftInsets;
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(constant);
    }];
}

- (void)setFirstCell:(BOOL)firstCell
{
    _firstCell = firstCell;
    self.topSepline.hidden = !firstCell;
}

- (void)setLastCell:(BOOL)lastCell
{
    _lastCell = lastCell;
    __weak typeof(self) weakSelf = self;
    [self.sepline mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat constant = lastCell ? 0.0f : weakSelf.leftInsets;
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(constant);
    }];
}

@end
