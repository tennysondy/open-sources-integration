//
//  RiskHintView.h
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/3/23.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskHintView : UIView

@property (assign, nonatomic) CGFloat riskRate;            //风险率
@property (assign, nonatomic) CGFloat progressHeight;      //进度条高度
@property (assign, nonatomic) CGFloat triangleHeight;      //三角箭头高度
@property (assign, nonatomic) CGFloat roundRectWidth;      //圆角矩形高度
@property (assign, nonatomic) CGFloat roundRectHeight;     //圆角矩形高度
@property (assign, nonatomic) CGFloat triangleTopOffset;   //三角形上顶点距进度条上沿偏移量

@end
