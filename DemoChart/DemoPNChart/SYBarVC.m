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
    _datas = @[@[@120, @115.0], @[@130, @145.0], @[@20, @85.0], @[@80, @95.0], @[@180, @11.0]];
    
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
    // 坐标轴属性设置
    // Y坐标轴
    chartBar.maxValue = @200;
    chartBar.numberOfYAxis = 10;
    chartBar.unitOfYAxis = @"分";
    chartBar.yFontSize = 12.0;
    chartBar.colorOfYAxis = [UIColor purpleColor];
    chartBar.colorOfYText = [UIColor orangeColor];
    // Y坐标单位
    chartBar.yUnitText = @"单位：分";
    // X坐标单位
    chartBar.xUnitText = @"时间";
    // X坐标轴
    chartBar.colorOfXAxis = [UIColor redColor];
    chartBar.colorOfXText = [UIColor brownColor];
    chartBar.xFontSize = 12.0;
    // 动画时间
    chartBar.animationTime = 0.6;
    // 网格
    chartBar.gridsLineColor = [UIColor brownColor];
    chartBar.gridsType = SYChartGridsTypeGridSolid;
    chartBar.gridsLineWidth = 0.5;
    // 刷新数据
    [chartBar reloadDataWithAnimate:YES];
}

// SYChartBarDataSource

- (NSInteger)barChartView:(SYChartBar *)chartBar numberOfBarsForSection:(NSInteger)section
{
    // 每个X轴标题对应的bar个数
    // 1个bar
//    return 1;
    
    // 多个bar
    return [_datas[section] count];
}

- (id)barChartView:(SYChartBar *)chartBar valueOfBarAtIndexPath:(NSIndexPath *)indexPath
{
    // 每个X轴标题对应的每个Y轴的信息
    // 1个bar
//    return _datas[indexPath.section];
    
    // 多个bar
    return _datas[indexPath.section][indexPath.row];
}

- (NSInteger)numberOfSectionsInBarChartView:(SYChartBar *)chartBar
{
    // 总的bar个数
    return [_datas count];
}

- (NSString *)barChartView:(SYChartBar *)chartBar titleOfBarForSection:(NSInteger)index
{
    // Y轴标题
    return _titles[index];
}

// SYChartBarDelegate

- (UIColor *)barChartView:(SYChartBar *)chartBar colorOfBarAtIndexPath:(NSIndexPath *)indexPath
{
    // bar的颜色设置
    if (chartBar.tag == 111)
    {
        return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
    }
    else
    {
        if (indexPath.row == 0)
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

- (NSString *)barChartView:(SYChartBar *)chartBar informationOfBarAtIndexPath:(NSIndexPath *)indexPath
{
    // bar顶端信息标题
    // 1个bar
//    if (chartBar.tag == 111)
//    {
//        if ([_datas[indexPath.section] floatValue] >= 130)
//        {
//            return @"优秀";
//        }
//        else if ([_datas[indexPath.section] floatValue] >= 110)
//        {
//            return @"良好";
//        }
//        else if ([_datas[indexPath.section] floatValue] >= 90)
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
        if ([_datas[indexPath.section][indexPath.row] floatValue] >= 130)
        {
            return @"优秀";
        }
        else if ([_datas[indexPath.section][indexPath.row] floatValue] >= 110)
        {
            return @"良好";
        }
        else if ([_datas[indexPath.section][indexPath.row] floatValue] >= 90)
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

- (UIView *)barChartView:(SYChartBar *)chartBar hintViewOfBarAtIndexPath:(NSIndexPath *)indexPath
{
    // 单个bar
//    NSString *text = [NSString stringWithFormat:@"%@分", _datas[indexPath.row]];
//    SYChartInfromationView *informationView = [[SYChartInfromationView alloc] initWithText:text];
//    informationView.frame = CGRectMake(0.0, 0.0, 40.0, 25.0);
//    if (indexPath.row == 0)
//    {
//        informationView.informationViewBackgroundColor = [UIColor purpleColor];
//        informationView.informationViewTextColor = [UIColor greenColor];
//        informationView.informationViewTextFont = [UIFont systemFontOfSize:8.0];
//    }
//    else if (indexPath.row == 1)
//    {
//        informationView.informationViewBackgroundColor = [UIColor lightGrayColor];
//        informationView.informationViewTextColor = [UIColor brownColor];
//        informationView.informationViewTextFont = [UIFont systemFontOfSize:12.0];
//    }
//    else if (indexPath.row == 2)
//    {
//        informationView.informationViewBackgroundColor = [UIColor redColor];
//        informationView.informationViewTextColor = [UIColor orangeColor];
//        informationView.informationViewTextFont = [UIFont systemFontOfSize:10.0];
//    }
//    
//    return informationView;
    
    // 多个bar
    // bar顶端信息自定义视图
    NSString *text = [NSString stringWithFormat:@"%@分", _datas[indexPath.section][indexPath.row]];
    SYChartInfromationView *informationView = [[SYChartInfromationView alloc] initWithText:text];
    informationView.frame = CGRectMake(0.0, 0.0, 40.0, 25.0);
    if (indexPath.section == 0)
    {
        informationView.informationViewBackgroundColor = [UIColor purpleColor];
        informationView.informationViewTextColor = [UIColor greenColor];
        informationView.informationViewTextFont = [UIFont systemFontOfSize:8.0];
    }
    else if (indexPath.section == 1)
    {
        informationView.informationViewBackgroundColor = [UIColor lightGrayColor];
        informationView.informationViewTextColor = [UIColor brownColor];
        informationView.informationViewTextFont = [UIFont systemFontOfSize:12.0];
    }
    else if (indexPath.section == 2)
    {
        informationView.informationViewBackgroundColor = [UIColor redColor];
        informationView.informationViewTextColor = [UIColor orangeColor];
        informationView.informationViewTextFont = [UIFont systemFontOfSize:10.0];
    }
    
    return informationView;
}

- (void)barChartView:(SYChartBar *)chartBar didSelectBarDotViewAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了第 %@ 个section的第 %@ 个bar的顶端信息视图", @(indexPath.section), @(indexPath.row));
}

- (void)barChartView:(SYChartBar *)chartBar didSelectBarAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了第 %@ 个section的第 %@ 个bar", @(indexPath.section), @(indexPath.row));
}

@end
