//
//  PopoverArrowView.h
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/4/1.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DYArrowDirection) {
    DYArrowDirectionUp,
    DYArrowDirectionDown,
};

@interface PopoverArrowView : UIView

@property (assign, nonatomic) DYArrowDirection arrowDirection;

@property (assign ,nonatomic) CGPoint popoverPoint;        //弹出点在当前view坐标系内坐标
@property (assign, nonatomic) CGFloat edgeOffset;          //圆角矩形距边界距离
@property (assign, nonatomic) CGFloat triangleHeight;      //三角箭头高度
@property (strong, nonatomic) UIColor *bgColor;            //背景色
@property (strong, nonatomic) UIColor *borderColor;        //边框颜色
@property (strong, nonatomic) UIColor *textColor;          //文字颜色
@property (strong, nonatomic) NSString *text;              //显示的文字

@end
