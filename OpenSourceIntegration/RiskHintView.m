//
//  RiskHintView.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/3/23.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import "RiskHintView.h"

//边界留1个点的余量
static CGFloat kDefaultEdgeOffset = 1.0f;

@interface RiskHintView ()

@property (strong, nonatomic) NSArray *rateKeyPoint;
@property (strong, nonatomic) NSArray *colorMap;

@property (assign, nonatomic) CGPoint triangleTopPoint;
@property (assign, nonatomic) CGPoint triangleLeftPoint;
@property (assign, nonatomic) CGPoint triangleRightPoint;

@end

@implementation RiskHintView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor blueColor].CGColor;
        if (_progressHeight < DBL_EPSILON) {
            _progressHeight = 8.0f;
        }
        if (_triangleHeight < DBL_EPSILON) {
            _triangleHeight = 4.0f;
        }
        if (_roundRectWidth < DBL_EPSILON) {
            _roundRectWidth = 60.0f;
        }
        if (_roundRectHeight < DBL_EPSILON) {
            _roundRectHeight = 17.0f;
        }
        if (_triangleTopOffset < DBL_EPSILON) {
            _triangleTopOffset = 1.0f;
        }
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (_triangleTopOffset + _triangleHeight + _roundRectHeight + kDefaultEdgeOffset > rect.size.height) {
        NSLog(@"各组件高度设置不合理！");
        return;
    }
    _riskRate = 0.08;
    [self setDrawingData];
    //计算是整体图像居中的顶点偏移量
    CGFloat topY = (rect.size.height - (_triangleTopOffset + _triangleHeight + _roundRectHeight + kDefaultEdgeOffset))/2.0;
    //进度条距2边界的距离各位20
    CGRect progressBgRect = CGRectMake(20.0, topY, rect.size.width - 20.0*2, _progressHeight);
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithRect:progressBgRect];
    UIColor *color = [UIColor lightGrayColor];
    [color set];
    [progressPath fill];
    
    for (NSInteger i = 0; i < _rateKeyPoint.count; i++) {
        NSInteger index = _rateKeyPoint.count - i - 1;//倒序绘制进度条
        CGRect tmpRect = progressBgRect;
        tmpRect.size.width = progressBgRect.size.width * [_rateKeyPoint[index] doubleValue];
        UIBezierPath *aRectPath = [UIBezierPath bezierPathWithRect:tmpRect];
        UIColor *color = _colorMap[index];
        [color set];
        [aRectPath fill];
    }
    //先计算三角形底边和各顶点
    CGFloat triangleBottom = _triangleHeight * 2.0f;
    _triangleTopPoint = CGPointMake((rect.size.width-40.0f)*_riskRate + 20.0f, progressBgRect.origin.y+_triangleTopOffset);
    _triangleLeftPoint = CGPointMake(_triangleTopPoint.x - triangleBottom/2, _triangleTopPoint.y + _triangleHeight);
    _triangleRightPoint = CGPointMake(_triangleTopPoint.x + triangleBottom/2, _triangleTopPoint.y + _triangleHeight);
    //覆盖三角形
    UIBezierPath *overlayPath = [UIBezierPath bezierPath];
    [overlayPath moveToPoint:_triangleTopPoint];
    [overlayPath addLineToPoint:_triangleLeftPoint];
    [overlayPath addLineToPoint:_triangleRightPoint];
    [overlayPath addLineToPoint:_triangleTopPoint];
    //overlayPath.lineWidth = 1.0f;
    UIColor *overlayColor = [UIColor whiteColor];
    [overlayColor set];
    [overlayPath fill];
    //[overlayPath stroke];
    //风险率圆角矩形
    //先优化边界情况
    CGFloat leftEdgeX = 5.0;
    CGFloat rightEdgeX = rect.size.width - 5.0;
    CGRect riskRateRect;
    CGFloat riskRateRectX;
    if (_triangleTopPoint.x - _roundRectWidth/2 < leftEdgeX) {
        riskRateRectX = leftEdgeX;
    } else if (_triangleTopPoint.x + _roundRectWidth/2 > rightEdgeX) {
        riskRateRectX = rightEdgeX - _roundRectWidth;
    } else {
        riskRateRectX = _triangleTopPoint.x - _roundRectWidth/2;
    }
    riskRateRect = CGRectMake(riskRateRectX, _triangleLeftPoint.y, _roundRectWidth, _roundRectHeight);
    UIBezierPath *riskRatePath = [UIBezierPath bezierPathWithRoundedRect:riskRateRect cornerRadius:4.0f];
    riskRatePath.lineWidth = 1.0f;
    UIColor *riskRateFillColor = [UIColor whiteColor];
    [riskRateFillColor set];
    [riskRatePath fill];
    UIColor *riskRateStrokeColor = _colorMap.lastObject;
    [riskRateStrokeColor set];
    [riskRatePath stroke];
    //画三角形白色底边
    UIBezierPath *triangleBottomPath = [UIBezierPath bezierPath];
    [triangleBottomPath moveToPoint:_triangleLeftPoint];
    [triangleBottomPath addLineToPoint:_triangleRightPoint];
    triangleBottomPath.lineWidth = 1.0f;
    UIColor *triangleBottomColor = [UIColor whiteColor];
    [triangleBottomColor set];
    [triangleBottomPath stroke];
    //画三角形除底边外的两边
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:_triangleTopPoint];
    [trianglePath addLineToPoint:_triangleLeftPoint];
    trianglePath.lineWidth = 1.0f;
    UIColor *triangleColor = _colorMap.lastObject;
    [triangleColor set];
    [trianglePath stroke];
    [trianglePath moveToPoint:_triangleTopPoint];
    [trianglePath addLineToPoint:_triangleRightPoint];
    [triangleColor set];
    [trianglePath stroke];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:riskRateRect];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"风险率%0.0lf%%", _riskRate*100]];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [str addAttribute:NSForegroundColorAttributeName value:_colorMap.lastObject range:NSMakeRange(3, str.length-3)];
    textLabel.attributedText = str;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
}

- (void)setDrawingData
{
    if (_riskRate < DBL_EPSILON) {
        _riskRate = 0.0f;
    }
    if (_riskRate > 1.0) {
        _riskRate = 1.0f;
    }
    if (_riskRate < DBL_EPSILON) {
        _rateKeyPoint = [NSArray arrayWithObjects:@(0.0), nil];
        _colorMap = [NSArray arrayWithObjects:[UIColor lightGrayColor], nil];
        
    } else if (_riskRate >= DBL_EPSILON && _riskRate < 0.75) {
        _rateKeyPoint = [NSArray arrayWithObjects:@(_riskRate), nil];
        _colorMap = [NSArray arrayWithObjects:[UIColor greenColor], nil];
        
    } else if (_riskRate >= 0.75 && _riskRate < 0.80) {
        _rateKeyPoint = [NSArray arrayWithObjects:@(0.75), @(_riskRate), nil];
        _colorMap = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor orangeColor], nil];
        
    } else if (_riskRate >= 0.80 && _riskRate < 0.88) {
        _rateKeyPoint = [NSArray arrayWithObjects:@(0.75), @(0.80), @(_riskRate), nil];
        _colorMap = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor orangeColor], [UIColor redColor], nil];
        
    } else {
        _rateKeyPoint = [NSArray arrayWithObjects:@(0.75), @(0.80), @(0.88), @(_riskRate), nil];
        _colorMap = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor orangeColor], [UIColor redColor], [UIColor blackColor], nil];
        
    }
}



@end
