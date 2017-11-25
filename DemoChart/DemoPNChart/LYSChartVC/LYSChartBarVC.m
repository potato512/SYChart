//
//  LYSChartBarVC.m
//  DemoChart
//
//  Created by herman on 2017/11/25.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "LYSChartBarVC.h"
#import "LYSHistogramChart.h"

@interface LYSChartBarVC ()

@end

@implementation LYSChartBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"LYSChartBar";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    LYSHistogramChart *chartView = [[LYSHistogramChart alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.width)];
    chartView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:chartView];
    chartView.row = 5;
    chartView.column = 5;
    chartView.columnData = @[@"跨省",@"AAA",@"AA",@"A",@"普通"];
    chartView.valueData = @[@"0.648",@"0.240",@"0.144",@"0.540",@"0.849"];
    chartView.isShowBenchmarkLine = YES;
    chartView.benchmarkLineStyle.benchmarkValue = @"0.6";
    chartView.canvasEdgeInsets = UIEdgeInsetsMake(20, 40, 20, 40);
    chartView.precisionScale = 1000;
    chartView.yAxisPrecisionScale = 2;
    [chartView setHistogramClickAction:^(NSInteger index) {
        NSLog(@"%ld",index);
    }];
    [chartView reloadData];
}

@end
