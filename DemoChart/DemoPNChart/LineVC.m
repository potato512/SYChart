//
//  LineVC.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "LineVC.h"
#import "PNChart/PNChart.h"

@interface LineVC () <PNChartDelegate>

@end

@implementation LineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"line PNChart";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0.0, 20.0, SCREEN_WIDTH, 200.0)];
    
    // 加载在视图上
    [self.view addSubview:lineChart];
    
    // 背景色
    lineChart.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    // X轴数据
    [lineChart setXLabels:@[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"]];
    
    // Y轴数据
    lineChart.yLabelFormat = @"%1.1f";
    lineChart.yFixedValueMax = 300.0;
    lineChart.yFixedValueMin = 0.0;
    lineChart.yLabelNum = 6;
    
    // 可以添加多条折线
    // 曲线1
    NSArray * data01Array = @[@"60.1", @"160.1", @"126.4", @"262.2", @"186.2", @"60.1", @"160.1", @"126.4", @"262.2", @"186.2", @"60.1", @"160.1"];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.lineWidth = 2.0;
    data01.color = PNGreen;
    data01.alpha = 1.0;
    data01.inflexionPointColor = PNRed;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.inflexionPointWidth = 5.0;
    data01.itemCount = lineChart.xLabels.count; // 方法1
//    data01.itemCount = data01Array.count; // 方法2
    data01.showPointLabel = YES;
    data01.pointLabelColor = PNRed;
    data01.pointLabelFont = [UIFont systemFontOfSize:10.0];
    data01.pointLabelFormat = @"%1.2f";
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // 曲线 2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @180.1, @26.4, @202.2, @126.2, @180.1, @26.4, @202.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // 添加曲线
    lineChart.chartData = @[data01, data02];
//    lineChart.chartData = @[data01];
    
    // 显示属性设置
    // xy坐标轴，默认不显示
    lineChart.showCoordinateAxis = YES;
    lineChart.axisColor = [UIColor greenColor];
    lineChart.axisWidth = 1.0;
    // 坐标轴信息标题
    lineChart.xUnit = @"月份";
    lineChart.yUnit = @"销量";
    // 无效？
    lineChart.showGenYLabels = YES;
    
//    // 结合方法"- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width"使用
//    lineChart.showLabel = YES;
//    // - (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width;
//    [lineChart setXLabels:data01Array withWidth:20.0];
    // 平滑过渡曲线，默认直角曲线
    lineChart.showSmoothLines = YES;
    // 显示y轴水平线
    lineChart.showYGridLines = YES;
    lineChart.yGridLinesColor = [UIColor purpleColor];
    
    // 设置曲线标题说明
    // Add Line Titles for the Legend
    data01.dataTitle = @"语文考试";
    data02.dataTitle = @"数学考试";
    // Build the legend
    lineChart.legendStyle = PNLegendItemStyleSerial;
    lineChart.legendFont = [UIFont systemFontOfSize:10.0];
    lineChart.legendPosition = PNLegendPositionBottom;
    UIView *legend = [lineChart getLegendWithMaxWidth:320];
    legend.backgroundColor = [UIColor yellowColor];
    // Move legend to the desired position and add to view
    [legend setFrame:CGRectMake(10.0, 5.0, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    
    // 代理
    lineChart.delegate = self;
    
    // 显示
    [lineChart strokeChart];
    
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
