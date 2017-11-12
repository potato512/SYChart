//
//  DrawVC.m
//  DemoChart
//
//  Created by herman on 2017/11/12.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "DrawVC.h"

@interface DrawVC ()

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
    
    
    //创建出CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(10.0, 10.0, (self.view.frame.size.width - 20.0), (self.view.frame.size.width - 20.0));//设置shapeLayer的尺寸和位置
    shapeLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
    shapeLayer.position = self.view.center;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    // 设置线条的宽度和颜色
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
//    // 创建出圆形贝塞尔曲线
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
//    // 让贝塞尔曲线与CAShapeLayer产生联系
//    shapeLayer.path = circlePath.CGPath;
    
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    // 设置线段的起始位置
//    [bezierPath moveToPoint:CGPointMake(10.0, 10.0)];
//    // 添加点
//    [bezierPath addLineToPoint:CGPointMake(100, 300)];
//    [bezierPath addLineToPoint:CGPointMake(300, 100)];
    NSArray *points = @[NSStringFromCGPoint(CGPointMake(0.0, 0.0)), NSStringFromCGPoint(CGPointMake(10.0, 10.0)), NSStringFromCGPoint(CGPointMake(0.0, 0.0)), NSStringFromCGPoint(CGPointMake(20.0, 40.0)), NSStringFromCGPoint(CGPointMake(50.0, 30.0)), NSStringFromCGPoint(CGPointMake(80.0, 10.0))];
    for (int i = 0; i < points.count; i++)
    {
        NSString *pointText = points[i];
        CGPoint point = CGPointFromString(pointText);
        
        if (0 == i)
        {
            [bezierPath moveToPoint:point];
        }
        [bezierPath addLineToPoint:point];
    }
    
    shapeLayer.path = bezierPath.CGPath;
    
    // 添加并显示
    [self.view.layer addSublayer:shapeLayer];
}

@end
