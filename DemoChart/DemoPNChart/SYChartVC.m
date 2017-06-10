//
//  SYChartVC.m
//  DemoChart
//
//  Created by herman on 2017/6/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYChartVC.h"
#import "SYLineVC.h"
#import "SYBarVC.h"

@interface SYChartVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;

@end

@implementation SYChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.array = @[@"折线图", @"柱形图"];
    
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
        nextVC = [SYLineVC new];
    }
    else if (1 == indexPath.row)
    {
        nextVC = [SYBarVC new];
    }
    nextVC.title = self.array[indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
