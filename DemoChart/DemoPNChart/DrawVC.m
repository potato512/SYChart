//
//  DrawVC.m
//  DemoChart
//
//  Created by herman on 2017/11/12.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "DrawVC.h"

@interface DrawVC ()

@property (nonatomic, strong) NSArray *points;

@end

@implementation DrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
//    [self drawlineZhe];
    
    [self drawlineQu];
    
//    [self drawColor];
}

- (NSArray *)points
{
    if (_points == nil)
    {
        _points = @[NSStringFromCGPoint(CGPointMake(10.0, 100.0)), NSStringFromCGPoint(CGPointMake(80.0, 50.0)), NSStringFromCGPoint(CGPointMake(120.0, 100.0)), NSStringFromCGPoint(CGPointMake(200.0, 135)), NSStringFromCGPoint(CGPointMake(250.0, 30.0)), NSStringFromCGPoint(CGPointMake(280.0, 90))];
    }
    return _points;
}

- (void)drawlineZhe
{
    /*
     // 1.贝塞尔曲线
     // 创建一个BezierPath对象
     UIBezierPath *bezierPath = [UIBezierPath bezierPath];
     // 设置线宽
     bezierPath.lineWidth = 1;
     // 终点处理：设置结束点曲线
     bezierPath.lineCapStyle = kCGLineCapRound;
     // 拐角处理：设置两个连接点曲线
     bezierPath.lineJoinStyle = kCGLineJoinRound;
     // 设置线的颜色
     [[UIColor redColor] setStroke];
     // 设置填充颜色
     [[UIColor greenColor] setFill];
     
     // 设置线段的起始位置
     [bezierPath moveToPoint:CGPointMake(10.0, 10.0)];
     // 添加点
     [bezierPath addLineToPoint:CGPointMake(100, 300)];
     [bezierPath addLineToPoint:CGPointMake(300, 300)];
     // 闭合曲线：让起始点和结束点连接起来
     [bezierPath closePath];
     // 描绘
     [bezierPath stroke];
     // 填充
     [bezierPath fill];
     */
    
    // 画点
    for (int i = 0; i < self.points.count; i++)
    {
        NSString *pointText = self.points[i];
        CGPoint point = CGPointFromString(pointText);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, 3.0, 3.0)];
        [self.view addSubview:view];
        view.layer.cornerRadius = 1.5;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor greenColor];
    }
    
    // 画填充
    
    
    // 画线
    // 创建出CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.view.bounds; // 设置shapeLayer的尺寸和位置
    shapeLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
    shapeLayer.fillColor = [UIColor purpleColor].CGColor; // 填充颜色为ClearColor
    // 设置线条的宽度和颜色
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
//    // 创建出圆形贝塞尔曲线
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
//    // 让贝塞尔曲线与CAShapeLayer产生联系
//    shapeLayer.path = circlePath.CGPath;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // 三个点的折线
//    // 设置线段的起始位置
//    [bezierPath moveToPoint:CGPointMake(10.0, 10.0)];
//    // 添加点
//    [bezierPath addLineToPoint:CGPointMake(100, 300)];
//    [bezierPath addLineToPoint:CGPointMake(300, 100)];

    // 多点折线
    for (int i = 0; i < self.points.count; i++)
    {
        NSString *pointText = self.points[i];
        CGPoint point = CGPointFromString(pointText);
        
        if (0 == i)
        {
            [bezierPath moveToPoint:point];
        }
        [bezierPath addLineToPoint:point];
    }

    // 添加并显示
    shapeLayer.path = bezierPath.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}

- (void)drawlineQu
{
    // 画点
    for (int i = 0; i < self.points.count; i++)
    {
        NSString *pointText = self.points[i];
        CGPoint point = CGPointFromString(pointText);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, 3.0, 3.0)];
        [self.view addSubview:view];
        view.layer.cornerRadius = 1.5;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor greenColor];
    }
    
    
    // 画线
    // 创建出CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.view.bounds; // 设置shapeLayer的尺寸和位置
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;// 填充颜色为ClearColor
    // 设置线条的宽度和颜色
    shapeLayer.lineWidth = 1.0;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1.0;
    bezierPath.lineCapStyle = kCGLineCapRound; // 线条拐角
    bezierPath.lineJoinStyle = kCGLineCapRound; // 终点处理
    
    // 两个点的曲线
//    CGPoint point1 = CGPointMake(20, 100);
//    CGPoint point2 = CGPointMake(60, 30);
//    CGPoint point3 = CGPointMake(100, 160);
//    CGPoint point4 = CGPointMake(140, 60);
//    [bezierPath moveToPoint:point1];
//    //
////    [bezierPath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(100, 70)];
//    //
//    [bezierPath addCurveToPoint:point2 controlPoint1:CGPointMake(point2.x / 2, point1.y) controlPoint2:CGPointMake(point2.x / 2, point2.y)];
//    [bezierPath addCurveToPoint:point3 controlPoint1:CGPointMake((point2.x / 2 + point2.x), point2.y) controlPoint2:CGPointMake((point2.x / 2 + point2.x), point3.y)];
//    [bezierPath addCurveToPoint:point4 controlPoint1:CGPointMake((point2.x / 2 + point3.x), point3.y) controlPoint2:CGPointMake((point2.x / 2 + point3.x), point4.y)];
    
    // 多个点的曲线
    /*
    for (int i = 0; i < self.points.count; i++)
    {
        if (0 == i)
        {
            NSString *startPointText = self.points[i];
            CGPoint startPoint = CGPointFromString(startPointText);
            [bezierPath moveToPoint:startPoint];
        }
        else
        {
            NSString *startPointText = self.points[1];
            CGPoint startPoint = CGPointFromString(startPointText);
            if (i + 1 < self.points.count)
            {
                NSString *endPointText = self.points[i];
                CGPoint endPoint = CGPointFromString(endPointText);
                //
                NSString *pointText1 = self.points[i - 1];
                CGPoint point1 = CGPointFromString(pointText1);
                CGFloat pointX = startPoint.x / 2 + point1.x;
                point1 = CGPointMake(pointX, point1.y);
                //
                CGPoint point2 = CGPointMake(pointX, endPoint.y);
                //
                if ([startPointText isEqualToString:endPointText])
                {
                    point1 = CGPointMake(startPoint.x / 2, point1.y);
                    point2 = CGPointMake(startPoint.x / 2, endPoint.y);
                }
                [bezierPath addCurveToPoint:endPoint controlPoint1:point1 controlPoint2:point2];
            }
        }
    }
    */
    
    NSString *startPointText = self.points[0];
    CGPoint startPoint = CGPointFromString(startPointText);
    [bezierPath moveToPoint:startPoint];
    for (int i = 0; i < self.points.count; i++)
    {
        if (i + 1 < self.points.count)
        {
            NSString *pointText1 = self.points[i];
            CGPoint point1 = CGPointFromString(pointText1);
            CGFloat pointX = startPoint.x / 2 + point1.x;
            
            NSString *pointText2 = self.points[i + 1];
            CGPoint point2 = CGPointFromString(pointText2);
            
            if ([startPointText isEqualToString:pointText1])
            {
                pointX = startPoint.x / 2;
            }
            point1 = CGPointMake(pointX, point1.y);
            point2 = CGPointMake(pointX, point2.y);
            
            CGPoint endPoint = CGPointFromString(pointText2);
            
            [bezierPath addCurveToPoint:endPoint controlPoint1:point1 controlPoint2:point2];
        }
    }

    shapeLayer.path = bezierPath.CGPath;
    [self.view.layer addSublayer:shapeLayer];
    
    
    // 填充颜色，创建出CAShapeLayer
    CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
    [self.view.layer addSublayer:maskShapeLayer];
    maskShapeLayer.frame = self.view.bounds;
    maskShapeLayer.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3].CGColor;
    // 增加填充区域封装点
    NSString *lastPointText = self.points.lastObject;
    CGPoint lastPoint = CGPointFromString(lastPointText);
    [bezierPath addLineToPoint:CGPointMake(lastPoint.x, lastPoint.y + 100)];
    [bezierPath addLineToPoint:CGPointMake(startPoint.x, lastPoint.y + 100)];
    maskShapeLayer.path = bezierPath.CGPath;
}

- (void)drawColor
{
    // 为颜色设置渐变效果
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, (self.view.frame.size.width - 20.0), 180.0)];
    [self.view addSubview:view1];
    // 渐变色
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    [view1.layer addSublayer:gradient1];
    gradient1.frame = view1.bounds;
    //
    gradient1.startPoint = CGPointMake(0, 0);
    gradient1.endPoint = CGPointMake(0, 1);
    gradient1.colors = [NSArray arrayWithObjects:(id)[UIColor redColor].CGColor,(id)[UIColor greenColor].CGColor,nil];
    // 设置颜色分割点（范围：0-1）
    gradient1.locations = @[@(0.0), @(1.0)];
}

@end
