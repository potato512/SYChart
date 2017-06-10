//
//  BarVC.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/22.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "BarVC.h"
#import "PNChart/PNChart.h"

@interface BarVC () <PNChartDelegate>

@end

@implementation BarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"bar PNChart";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{

    
//    UIButton *button = [[UIButton alloc] init];
//    [self.view addSubview:button];
//    button.frame = CGRectMake(10.0, 10.0, (CGRectGetWidth(self.view.bounds) - 10.0 * 2), 40.0);
//    button.backgroundColor = [UIColor yellowColor];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [button setTitle:nil forState:UIControlStateNormal];
//    button.tag = 1;
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(10.0, 10.0, (SCREEN_WIDTH - 10.0 * 2), 200.0)];
    
    // 加载在视图上
    [self.view addSubview:barChart];
    
    // 属性设置
    // 背景颜色
    barChart.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    // x轴显示样式设置
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    barChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    // 无效？
//    barChart.isGradientShow = YES;
//    barChart.showLabel = YES;
    barChart.showLevelLine = YES;
    
    // 坐标轴显示位置设置
    barChart.chartMarginLeft = 25.0;
    barChart.chartMarginTop = 25.0;
    barChart.chartMarginRight = 20.0;
    barChart.chartMarginBottom = 50.0;
    
    // X轴数据
    [barChart setXLabels:@[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"]];
//    barChart.xLabelSkip = 12;
    // Y轴数据
    [barChart setYValues:@[@1, @10, @2, @6, @3]];
    barChart.yLabels = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
//    barChart.yChartLabelWidth = 20.0;
    // 无效？
//    barChart.yLabelPrefix = @"时间";
//    barChart.yLabelSuffix = @"比例";
    
    // bar属性设置
    // bar的大小
//    barChart.xLabelWidth = 20.0;
    // bar填充颜色
    // 方法1-单一颜色
//    barChart.strokeColor = [UIColor redColor];
    // 方法2-各种颜色
    barChart.strokeColors = @[[UIColor redColor], [UIColor blackColor], [UIColor greenColor], [UIColor purpleColor], [UIColor yellowColor]];
    // bar背景色
    barChart.barBackgroundColor = [UIColor yellowColor];
    // 无效？
    barChart.barColorGradientStart = [UIColor redColor];
    // bar圆角
//    barChart.barRadius = 5.0;
    // bar大粗细
//    barChart.barWidth = 5.0;
    
    
    
    // 边框设置
    // 显示边框，默认不显示
    barChart.labelMarginTop = 5.0;
    barChart.showChartBorder = YES;
    // 显示水平线，默认不显示
//    barChart.showLevelLine = YES;
    // 显示边框颜色
    barChart.chartBorderColor = [UIColor redColor];
    
    // bar字体属性设置
    barChart.isShowNumbers = NO;
    barChart.labelFont = [UIFont systemFontOfSize:5.0]; // 无效？
    barChart.labelTextColor = [UIColor purpleColor];
    barChart.labelMarginTop = 10.0;
    
    // 无效？
//    CAShapeLayer *layerLine = [CAShapeLayer layer];
//    layerLine.frame         = barChart.bounds;                // 与showView的frame一致
//    layerLine.strokeColor   = [UIColor greenColor].CGColor;   // 边缘线的颜色
//    layerLine.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
//    layerLine.lineCap       = kCALineCapSquare;               // 边缘线的类型
////    layerLine.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
//    layerLine.lineWidth     = 4.0f;                           // 线条宽度
//    layerLine.strokeStart   = 0.0f;
//    layerLine.strokeEnd     = 0.1f;
//    barChart.chartLevelLine = layerLine;
    
    
    barChart.legendStyle = PNLegendItemStyleSerial;
    barChart.legendPosition = PNLegendPositionBottom;
    
    // 代理
    barChart.delegate = self;
    
    // 显示
    [barChart strokeChart];
}

// PNChartDelegate

/**
 * Callback method that gets invoked when the user taps on the chart line.
 */
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex
{
    NSLog(@"1 你点击了 point=%@ lineIndex=%@", NSStringFromCGPoint(point), @(lineIndex));
}

/**
 * Callback method that gets invoked when the user taps on a chart line key point.
 */
- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex
{
    NSLog(@"2 你点击了 point=%@ lineIndex=%@ pointIndex=%@", NSStringFromCGPoint(point), @(lineIndex), @(pointIndex));
}

/**
 * Callback method that gets invoked when the user taps on a chart bar.
 */
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    NSLog(@"3 你点击了barIndex= %@", @(barIndex));
}


- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex
{
    NSLog(@"4 你点击了 pieIndex=%@", @(pieIndex));
}

- (void)didUnselectPieItem
{
    NSLog(@"5 你点击了");
}


@end
