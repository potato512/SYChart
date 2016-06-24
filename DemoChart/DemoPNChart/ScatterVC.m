//
//  ScatterVC.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/24.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ScatterVC.h"
#import "PNChart/PNChart.h"

@interface ScatterVC () <PNChartDelegate>

@end

@implementation ScatterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"scatter PNChart";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
    PNScatterChart *scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(10.0, 10.0, (SCREEN_WIDTH - 10.0 * 2), 200)];
    [self.view addSubview:scatterChart];
    
    [scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
    [scatterChart setAxisYWithMinimumValue:30 andMaxValue:50 toTicks:5];
    
    [scatterChart setAxisXLabel:@[@"x1", @"x2", @"x3", @"x4", @"x5", @"x6"]];
    [scatterChart setAxisYLabel:@[@"y1", @"y2", @"y3", @"y4", @"y5"]];
    
    NSArray *data01Array = [self randomSetOfObjects:scatterChart];
    PNScatterChartData *data01 = [PNScatterChartData new];
    data01.strokeColor = PNGreen;
    data01.fillColor = PNFreshGreen;
    data01.size = 2;
    data01.itemCount = [[data01Array objectAtIndex:0] count];
    data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
    __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
    __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
    data01.getData = ^(NSUInteger index) {
        CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
        CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
        return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
    };
    
    [scatterChart setup];
    scatterChart.chartData = @[data01];
    /***
     this is for drawing line to compare
     CGPoint start = CGPointMake(20, 35);
     CGPoint end = CGPointMake(80, 45);
     [scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
     ***/
    scatterChart.delegate = self;
}

#define ARC4RANDOM_MAX 0x100000000
- (NSArray *)randomSetOfObjects:(PNScatterChart *)scatterChart
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < 25 ; i++)
    {
        [XAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (scatterChart.AxisX_maxValue - scatterChart.AxisX_minValue) + scatterChart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (scatterChart.AxisY_maxValue - scatterChart.AxisY_minValue) + scatterChart.AxisY_minValue)]];
    }
    [array addObject:XAr];
    [array addObject:YAr];
    return (NSArray*) array;
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
