//
//  CycleVC.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/24.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "CycleVC.h"
#import "PNChart/PNChart.h"

@interface CycleVC ()

@end

@implementation CycleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"cycle PNChart";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200.0) / 2, (SCREEN_HEIGHT - 200.0) / 2, 200.0, 200.0) total:@(100) current:@(60) clockwise:YES shadow:YES shadowColor:PNBlue displayCountingLabel:YES overrideLineWidth:@(10)];
    [self.view addSubview:circleChart];
    circleChart.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    circleChart.chartType = PNChartFormatTypePercent;
    circleChart.displayAnimated = YES;
    
    [circleChart setStrokeColor:PNGreen];
    [circleChart strokeChart];
    
    // 显示
    [circleChart strokeChart];
}

@end
