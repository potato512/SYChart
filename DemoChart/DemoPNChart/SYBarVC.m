//
//  SYBarVC.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYBarVC.h"
#import "SYChart.h"

@interface SYBarVC () <SYChartBarDataSource, SYChartBarDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation SYBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"sybar SYChart";
    
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
    
    _titles = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月"];
    // 单个bar
//    _datas = [NSMutableArray arrayWithArray:@[@120, @115.0, @50, @138, @110, @100]];
    // 多个bar
    _datas = @[@[@120, @115.0], @[@130, @165.0], @[@20, @85.0], @[@80, @95.0], @[@180, @11.0]];
    
    CGFloat originX = 0.0;
    CGFloat widthBarview = ([UIScreen mainScreen].bounds.size.width - originX * 2);
    CGFloat heightBarview = (([UIScreen mainScreen].bounds.size.height - 64.0 - 10.0 * 3) / 2);
    
    SYChartBar *chartBar = [[SYChartBar alloc] initWithFrame:CGRectMake(originX, 10, widthBarview, heightBarview)];
    // 添加到父视图
    [self.view addSubview:chartBar];
    // 属性设置
    // 背景色
    chartBar.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    // tag值
    chartBar.tag = 111;
    // 代理
    chartBar.dataSource = self;
    chartBar.delegate = self;
    chartBar.maxValue = @150;
    // 坐标轴属性设置
    chartBar.numberOfYAxis = 5;
    chartBar.unitOfYAxis = @"分";
    chartBar.colorOfXAxis = [UIColor redColor];
    chartBar.colorOfXText = [UIColor brownColor];
    chartBar.colorOfYAxis = [UIColor purpleColor];
    chartBar.colorOfYText = [UIColor orangeColor];
    
    chartBar.animationTime = 1.2;
    
    chartBar.gridsLineColor = [UIColor brownColor];
    chartBar.gridsType = SYChartGridsTypeGridDotted;
    chartBar.gridsLineWidth = 0.5;

    
    // 刷新数据
//    [chartBar reloadData];
    [chartBar reloadDataWithAnimate:YES];
}

// SYChartBarDataSource

- (NSInteger)barChartView:(SYChartBar *)chartBar numberOfBarsInSection:(NSInteger)section
{
    // 每个X轴标题对应的bar个数
    // 1个bar
//    return 1;
    
    // 多个bar
    return [_datas[section] count];
}

- (id)barChartView:(SYChartBar *)chartBar valueOfBarInSection:(NSInteger)section index:(NSInteger)index
{
    // 每个X轴标题对应的每个Y轴的信息
    // 1个bar
//    return _datas[section];
    
    // 多个bar
    return _datas[section][index];
}

- (NSInteger)numberOfSectionsInBarChartView:(SYChartBar *)chartBar
{
    // 总的bar个数
    return [_datas count];
}

- (NSString *)barChartView:(SYChartBar *)chartBar titleOfBarInSection:(NSInteger)section
{
    // Y轴标题
    return _titles[section];
}


// SYChartBarDelegate

- (UIColor *)barChartView:(SYChartBar *)chartBar colorOfBarInSection:(NSInteger)section index:(NSInteger)index
{
    // bar的颜色设置
    if (chartBar.tag == 111)
    {
        return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
    }
    else
    {
        if (index == 0)
        {
            return [UIColor colorWithRed:105/255.0 green:105/255.0 blue:147/255.0 alpha:1.0];
        }
        return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
    }
}

- (CGFloat)barWidthInBarChartView:(SYChartBar *)chartBar
{
    // bar的宽度
    return 20.0;
}

- (CGFloat)paddingForSectionInBarChartView:(SYChartBar *)chartBar
{
    // 每个section之间的bar之间的间距
    return 20.0;
}

- (CGFloat)paddingForBarInBarChartView:(SYChartBar *)chartBar
{
    // 每个section里的bar之间的间距（section有多个）
    return 5.0;
}

//- (NSArray *)barChartView:(SYChartBar *)chartBar selectionColorForBarInSection:(NSUInteger)section
//{
//    
//}

- (NSString *)barChartView:(SYChartBar *)chartBar informationOfBarInSection:(NSInteger)section index:(NSInteger)index
{
    // bar顶端信息标题
    // 1个bar
//    if (chartBar.tag == 111)
//    {
//        if ([_datas[section] floatValue] >= 130)
//        {
//            return @"优秀";
//        }
//        else if ([_datas[section] floatValue] >= 110)
//        {
//            return @"良好";
//        }
//        else if ([_datas[section] floatValue] >= 90)
//        {
//            return @"及格";
//        }
//        else
//        {
//            return @"不及格";
//        }
//    }
    
    // 多个bar
    if (chartBar.tag == 111)
    {
        if ([_datas[section][index] floatValue] >= 130)
        {
            return @"优秀";
        }
        else if ([_datas[section][index] floatValue] >= 110)
        {
            return @"良好";
        }
        else if ([_datas[section][index] floatValue] >= 90)
        {
            return @"及格";
        }
        else
        {
            return @"不及格";
        }
    }
    
    return nil;
}

//- (UIView *)barChartView:(SYChartBar *)chartBar hintViewOfBarInSection:(NSInteger)section index:(NSInteger)index
//{
//    // bar顶端信息自定义视图
////    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 20.0)];
////    view.backgroundColor = [UIColor purpleColor];
////
////    return view;
//
//    return nil;
//}

- (void)barChartView:(SYChartBar *)chartBar didSelectBarAtIndex:(NSUInteger)index
{
    // 被点击选中bar
    NSLog(@"你点击了 %@", @(index));
}


@end
