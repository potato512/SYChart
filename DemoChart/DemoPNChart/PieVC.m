//
//  PieVC.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/24.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "PieVC.h"
#import "PNChart/PNChart.h"

@interface PieVC () <PNChartDelegate>

@end

@implementation PieVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"pie PNChart";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"房租"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"生活费"],
                       ];
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200.0) / 2, (SCREEN_HEIGHT - 200.0) / 2, 200.0, 200.0) items:items];
    
    // 加载在视图上
    [self.view addSubview:pieChart];
    
    // 属性设置
    // 背景颜色
    pieChart.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];

    // 饼状图文字颜色
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    
    // 信息阴影显示设置
    pieChart.descriptionTextShadowColor = [UIColor redColor];
    pieChart.descriptionTextShadowOffset = CGSizeMake(2.0, 2.0);
    
    // 设置饼图信息标题
    // Build the legend
    pieChart.legendStyle = PNLegendItemStyleStacked;
    pieChart.legendFont = [UIFont systemFontOfSize:10.0];
    pieChart.legendPosition = PNLegendPositionLeft;
    UIView *legend = [pieChart getLegendWithMaxWidth:200];
    legend.backgroundColor = [UIColor yellowColor];
    // Move legend to the desired position and add to view
    [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    // 代理
    pieChart.delegate = self;
    
    // 显示
    [pieChart strokeChart];
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
