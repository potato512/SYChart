//
//  AAChartVC.m
//  DemoChart
//
//  Created by herman on 2017/6/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//  https://github.com/AAChartModel/AAChartKit

#import "AAChartVC.h"
#import "AAChartColumnVC.h"
#import "AAChartBarVC.h"
#import "AAChartAreaVC.h"
#import "AAChartAreasplineVC.h"
#import "AAChartLineVC.h"
#import "AAChartSplineVC.h"
#import "AAChartScatterVC.h"
#import "AAChartPieVC.h"
#import "AAChartBubbleVC.h"
#import "AAChartPyramidVC.h"
#import "AAChartFunnelVC.h"
#import "AAChartMixedVC.h"


@interface AAChartVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;

@end

@implementation AAChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.array = @[@"Column Chart(柱形图)", @"Bar Chart(条形图)", @"Area Chart(折线填充图)", @"Areaspline Chart(曲线填充图)", @"Line Chart(折线图)", @"Spline Chart(曲线图)", @"Scatter Chart(散点图)", @"Pie Chart(扇形图)", @"Bubble Chart(气泡图)", @"Pyramid Chart(金字塔图)", @"Funnel Chart(漏斗图)", @"Mixed Chart(混合图)"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *nextVC = nil;
    if (0 == indexPath.row)
    {
        nextVC = [AAChartColumnVC new];
    }
    else if (1 == indexPath.row)
    {
        nextVC = [AAChartBarVC new];
    }
    else if (2 == indexPath.row)
    {
        nextVC = [AAChartAreaVC new];
    }
    else if (3 == indexPath.row)
    {
        nextVC = [AAChartAreasplineVC new];
    }
    else if (4 == indexPath.row)
    {
        nextVC = [AAChartLineVC new];
    }
    else if (5 == indexPath.row)
    {
        nextVC = [AAChartSplineVC new];
    }
    else if (6 == indexPath.row)
    {
        nextVC = [AAChartScatterVC new];
    }
    else if (7 == indexPath.row)
    {
        nextVC = [AAChartPieVC new];
    }
    else if (8 == indexPath.row)
    {
        nextVC = [AAChartBubbleVC new];
    }
    else if (9 == indexPath.row)
    {
        nextVC = [AAChartPyramidVC new];
    }
    else if (10 == indexPath.row)
    {
        nextVC = [AAChartFunnelVC new];
    }
    else if (11 == indexPath.row)
    {
        nextVC = [AAChartMixedVC new];
    }
    nextVC.title = self.array[indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
