//
//  PopoverArrowView.m
//  OpenSourceIntegration
//
//  Created by 丁 一 on 15/4/1.
//  Copyright (c) 2015年 Ding Yi. All rights reserved.
//

#import "PopoverArrowView.h"

@interface PopoverArrowView ()

@property (assign, nonatomic) CGPoint triangleTopPoint;
@property (assign, nonatomic) CGPoint triangleLeftPoint;
@property (assign, nonatomic) CGPoint triangleRightPoint;
@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation PopoverArrowView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
        //        self.layer.borderWidth = 0.5;
        //        self.layer.borderColor = [UIColor blueColor].CGColor;
        [self setDefaultValue];
    }
    return self;
}

- (void)setDefaultValue
{
    _arrowDirection = DYArrowDirectionUp;
    _triangleHeight = 6.0f;
    _edgeOffset = 5.0;
    _bgColor = [UIColor blackColor];
    _borderColor = [UIColor blackColor];
    _textColor = [UIColor whiteColor];
    _text = @"欢迎使用DYPopoverArrowView";
}

- (void)setArrowDirection:(DYArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsDisplay];
}

- (void)setPopoverPoint:(CGPoint)popoverPoint
{
    _popoverPoint = popoverPoint;
    CGRect rect = self.frame;
    rect.origin = CGPointMake(0, 0);
    [self setNeedsDisplay];
}

- (void)setEdgeOffset:(CGFloat)edgeOffset
{
    _edgeOffset = edgeOffset;
    [self setNeedsDisplay];
}

- (void)setTriangleHeight:(CGFloat)triangleHeight
{
    _triangleHeight = triangleHeight;
    [self setNeedsDisplay];
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    //弹出点很坐标需位于圆角矩形横纵向区间内
    if (_popoverPoint.x < 0 || _popoverPoint.x > rect.size.width) {
        return;
    }
    if (_popoverPoint.y < 0 || _popoverPoint.y > rect.size.height) {
        return;
    }
    //弹出点与view的相对坐标
    CGFloat relativeLocX = _popoverPoint.x;
    CGFloat relativeLocY = _popoverPoint.y;
    //三角形底边宽度是高的2倍
    CGFloat triangleBottom = _triangleHeight * 2.0f;
    //圆角矩形起始点和大小
    CGSize roundRectSize;
    CGPoint roundRectOrigin;
    switch (_arrowDirection) {
        case DYArrowDirectionUp:
        {
            //先计算三角形底边和各顶点
            _triangleTopPoint = CGPointMake(relativeLocX, relativeLocY);
            _triangleLeftPoint = CGPointMake(_triangleTopPoint.x - triangleBottom/2, _triangleTopPoint.y + _triangleHeight);
            _triangleRightPoint = CGPointMake(_triangleTopPoint.x + triangleBottom/2, _triangleTopPoint.y + _triangleHeight);
            roundRectSize = CGSizeMake(CGRectGetWidth(rect)-_edgeOffset*2, CGRectGetHeight(rect)- relativeLocY - _triangleHeight - 5.0);
            roundRectOrigin = CGPointMake(_edgeOffset, _triangleLeftPoint.y);
        }
            break;
        case DYArrowDirectionDown:
        {
            //先计算三角形底边和各顶点
            _triangleTopPoint = CGPointMake(relativeLocX, relativeLocY);
            _triangleLeftPoint = CGPointMake(_triangleTopPoint.x - triangleBottom/2, _triangleTopPoint.y - _triangleHeight);
            _triangleRightPoint = CGPointMake(_triangleTopPoint.x + triangleBottom/2, _triangleTopPoint.y - _triangleHeight);
            roundRectSize = CGSizeMake(CGRectGetWidth(rect)-_edgeOffset*2, relativeLocY - _triangleHeight - 5.0);
            roundRectOrigin = CGPointMake(_edgeOffset, _triangleLeftPoint.y - roundRectSize.height);
        }
            break;
        default:
            break;
    }
    //覆盖三角形
    UIBezierPath *overlayPath = [UIBezierPath bezierPath];
    [overlayPath moveToPoint:_triangleTopPoint];
    [overlayPath addLineToPoint:_triangleLeftPoint];
    [overlayPath addLineToPoint:_triangleRightPoint];
    [overlayPath addLineToPoint:_triangleTopPoint];
    UIColor *overlayColor = _bgColor;
    [overlayColor set];
    [overlayPath fill];
    //圆角矩形
    CGRect roundRect = CGRectMake(roundRectOrigin.x, roundRectOrigin.y, roundRectSize.width, roundRectSize.height);
    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:4.0f];
    roundRectPath.lineWidth = 1.0f;
    UIColor *roundRectFillColor = _bgColor;
    [roundRectFillColor set];
    [roundRectPath fill];
    UIColor *roundRectStrokeColor = _borderColor;
    [roundRectStrokeColor set];
    [roundRectPath stroke];
    //画三角形底边
    UIBezierPath *triangleBottomPath = [UIBezierPath bezierPath];
    [triangleBottomPath moveToPoint:_triangleLeftPoint];
    [triangleBottomPath addLineToPoint:_triangleRightPoint];
    triangleBottomPath.lineWidth = 1.0f;
    UIColor *triangleBottomColor = _bgColor;
    [triangleBottomColor set];
    [triangleBottomPath stroke];
    //画三角形除底边外的两边
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:_triangleTopPoint];
    [trianglePath addLineToPoint:_triangleLeftPoint];
    trianglePath.lineWidth = 1.0f;
    UIColor *triangleColor = _borderColor;
    [triangleColor set];
    [trianglePath stroke];
    [trianglePath moveToPoint:_triangleTopPoint];
    [trianglePath addLineToPoint:_triangleRightPoint];
    [triangleColor set];
    [trianglePath stroke];
    
    if (self.textLabel == nil) {
        self.textLabel = [[UILabel alloc] initWithFrame:roundRect];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:_textColor range:NSMakeRange(0, str.length)];
    self.textLabel.attributedText = str;
}


@end
