//
//  LYSChartVC.m
//  DemoChart
//
//  Created by herman on 2017/11/25.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "LYSChartVC.h"
#import "LYSChartBarVC.h"
#import "LYSChartLineVC.h"
#import "LYSChartCurveLineVC.h"

@interface LYSChartVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;

@end

@implementation LYSChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.array = @[@"Bar Chart(条形图)", @"Areaspline Chart(曲线填充图)", @"Area Chart(折线填充图)", ];
    
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
        nextVC = [LYSChartBarVC new];
    }
    else if (1 == indexPath.row)
    {
        nextVC = [LYSChartCurveLineVC new];
    }
    else if (2 == indexPath.row)
    {
        nextVC = [LYSChartLineVC new];
    }
    nextVC.title = self.array[indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
