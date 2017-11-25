//
//  LYSChartLineVC.m
//  DemoChart
//
//  Created by herman on 2017/11/25.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "LYSChartLineVC.h"
#import "LYSLineChart.h"

@interface LYSChartLineVC ()

@end

@implementation LYSChartLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"LYSChartLine";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    LYSLineChart *chartView1 = [[LYSLineChart alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.width)];
    chartView1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:chartView1];
    chartView1.row = 14;
    chartView1.column = 14;
//    chartView1.columnData = @[@"广州",@"深圳",@"东莞",@"惠州",@"河源",@"梅州",@"汕头",@"潮州",@"陆丰",@"江门",@"阳江",@"珠海",@"中山",@"茂名"];
//    chartView1.valueData = @[@"0.648",@"0.240",@"0.144",@"0.540",@"0.849",@"0.0",@"0.0",@"0.251",@"0.135",@"0.0",@"0.413",@"0.592",@"0.521",@"0.111"];
    chartView1.columnData = @[@"跨省",@"AAA",@"AA",@"A",@"普通",@"BB",@"CC"];
    chartView1.valueData = @[@"64.8",@"24.0",@"14.4",@"54.0",@"84.9",@"158.32",@"204.21"];
    chartView1.isShowBenchmarkLine = YES;
//    chartView1.benchmarkLineStyle.benchmarkValue = @"0.6";
//    chartView1.canvasEdgeInsets = UIEdgeInsetsMake(20, 40, 20, 40);
    chartView1.precisionScale = 1000;
//    chartView1.yAxisPrecisionScale = 2;
    chartView1.isCurve = NO;
    [chartView1 reloadData];
}

@end
