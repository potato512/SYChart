//
//  ViewController.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/22.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"

#import "LineVC.h"
#import "BarVC.h"
#import "PieVC.h"
#import "CycleVC.h"
#import "ScatterVC.h"
#import "SYLineVC.h"
#import "SYBarVC.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *vcArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Chart";
    
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
    
    self.vcArray = @[[LineVC class], [BarVC class], [PieVC class], [CycleVC class], [ScatterVC class], [SYLineVC class], [SYBarVC class]];
    CGFloat originY = 10.0;
    for (int i = 0; i < self.vcArray.count; i++)
    {
        NSString *title = NSStringFromClass(self.vcArray[i]);
        
        UIButton *button = [[UIButton alloc] init];
        [self.view addSubview:button];
        button.frame = CGRectMake(10.0, originY, (CGRectGetWidth(self.view.bounds) - 10.0 * 2), 40.0);
        button.backgroundColor = [UIColor yellowColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        originY += (40.0 + 10.0);
    }
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger index = button.tag;
    
    Class vcClass = self.vcArray[index];
    UIViewController *vc = [[vcClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

/*
 https://github.com/kevinzhow/PNChart
 http://www.tuicool.com/articles/QNrIVvA
 
 
 
 饼状图
 
 Objective-C
 
 PNPieChart *pieChart = [[PNPieChartalloc]initWithFrame:CGRectMake(40.0,155.0,240.0,240.0)items:items];
 //饼状图文字颜色
 pieChart.descriptionTextColor = [UIColorwhiteColor];
 pieChart.descriptionTextFont  = [UIFontfontWithName:@"Avenir-Medium"size:14.0];
 //绘制
 [pieChart strokeChart];
 
 //加载在视图上
 [self.windowaddSubview:pieChart];
 PNPieChart*pieChart=[[PNPieChartalloc]initWithFrame:CGRectMake(40.0,155.0,240.0,240.0)items:items];
 //饼状图文字颜色
 pieChart.descriptionTextColor=[UIColorwhiteColor];
 pieChart.descriptionTextFont  =[UIFontfontWithName:@"Avenir-Medium"size:14.0];
 //绘制
 [pieChartstrokeChart];
 
 //加载在视图上
 [self.windowaddSubview:pieChart];
 
 圆形进度条
 
 Objective-C
 
 // total参数是进度条的总数据量，current是当前的数据量，closewise是绘制方向，YES是从左到右，NO为从右到左
 PNCircleChart *circleChart = [[PNCircleChartalloc]initWithFrame:CGRectMake(40.0,155.0,240.0,240.0)total:@100current:@30clockwise:NO];
 
 //绘制图形
 [circleChart strokeChart];
 
 //加载在视图上
 [self.windowaddSubview:circleChart];
 // total参数是进度条的总数据量，current是当前的数据量，closewise是绘制方向，YES是从左到右，NO为从右到左
 PNCircleChart*circleChart=[[PNCircleChartalloc]initWithFrame:CGRectMake(40.0,155.0,240.0,240.0)total:@100current:@30clockwise:NO];
 
 //绘制图形
 [circleChartstrokeChart];
 
 //加载在视图上
 [self.windowaddSubview:circleChart];
 
 
*/