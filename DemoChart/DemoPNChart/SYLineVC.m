//
//  SYLineVC.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYLineVC.h"
#import "SYChart.h"

@interface SYLineVC () <SYChartLineDataSource, SYChartLineDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation SYLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"syline SYChart";
    
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
    
    _titles = @[@"1week", @"2week", @"3week", @"4week", @"5week"];
    // 单条曲线
//    _datas = @[@50, @68, @93, @66, @75];
    // 多条曲线
    _datas = @[@[@50, @68, @93, @66, @75],@[@90, @11, @32, @91, @20],@[@19, @88, @63, @16, @41]];
    
    SYChartLine *chartLine = [[SYChartLine alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:chartLine];
    chartLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    // 数据点设置
    chartLine.dotRadius = 5.0;
    chartLine.dotColor = [UIColor orangeColor];
    chartLine.isSolidDot = NO;
    // 代理设置
    chartLine.dataSource = self;
    chartLine.delegate = self;
    // Y坐标轴设置
    chartLine.minValue = @0;
    chartLine.maxValue = @100;
    chartLine.oppositeY = NO;
    chartLine.numberOfYAxis = 10;
    chartLine.colorOfYAxis = [UIColor orangeColor];
    chartLine.colorOfYText = [UIColor purpleColor];
    chartLine.yFontSize = 10.0;
    chartLine.unitOfYAxis = @"分";
    // X坐标轴设置
    chartLine.colorOfXAxis = [UIColor redColor];
    chartLine.colorOfXText = [UIColor greenColor];
    chartLine.xFontSize = 10.0;
    // 网格设置
    chartLine.gridsLineColor = [UIColor brownColor];
    chartLine.gridsType = SYChartGridsTypeGridDotted;
    chartLine.gridsLineWidth = 0.5;
    // 动画时间设置
    chartLine.animationTime = 1.0;
    // 曲线样式设置
    chartLine.isSolidLines = YES;
    chartLine.isSmoothLines = YES;
    // 刷新数据
    [chartLine reloadDataWithAnimate:YES];
}

// MCLineChartViewDataSource

- (NSUInteger)lineChartView:(SYChartLine *)charLine lineCountAtLineNumber:(NSInteger)lineNumber
{
    // Y垂直坐标曲线点个数
    // 1条曲线
//    return [_dataSource count];
    
    // 多条曲线
    return [_datas[lineNumber] count];
}

- (id)lineChartView:(SYChartLine *)charLine valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // Y垂直坐标信息
    // 1条曲线
//    return _dataSource[index];
    
    // 多条曲线
    return _datas[lineNumber][index];
}

- (NSUInteger)numberOfLinesInLineChartView:(SYChartLine *)charLine
{
    // 曲线条数
    // 1条曲线
//    return 1;
    
    // 多条曲线
    return _datas.count;
}

- (NSString *)lineChartView:(SYChartLine *)charLine titleAtLineNumber:(NSInteger)index
{
    // x坐标标题
    return _titles[index];
}

// MCLineChartViewDelegate

- (CGFloat)lineChartView:(SYChartLine *)charLine lineWidthWithLineNumber:(NSInteger)lineNumber
{
    // 曲线大小
    if (lineNumber == 0)
    {
        return 1.0;
    }
    else if (lineNumber == 1)
    {
        return 1.5;
    }
    else if (lineNumber == 2)
    {
        return 2.0;
    }
    
    return 0.5;
}

- (CGFloat)dotPaddingInLineChartView:(SYChartLine *)charLine
{
    // 曲线数据点间距（可设置成信息不滚动样式。默认60.0）
    NSInteger count = self.titles.count;
    CGFloat width = charLine.widthInfoView;
    CGFloat padding = width / count;
//    CGFloat padding = 80.0;
    
    return padding;
}

- (UIColor *)lineChartView:(SYChartLine *)charLine lineColorWithLineNumber:(NSInteger)lineNumber
{
    // 曲线颜色
    if (lineNumber == 0)
    {
        return [UIColor purpleColor];
    }
    else if (lineNumber == 1)
    {
        return [UIColor lightGrayColor];
    }
    else if (lineNumber == 2)
    {
        return [UIColor redColor];
    }

    return [UIColor yellowColor];
}

- (NSString *)lineChartView:(SYChartLine *)charLine informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // 曲线点数据信息标题
    // 1条曲线
//    if (index == 0 || index == _dataSource.count - 1)
//    {
//        return [NSString stringWithFormat:@"%@名", _dataSource[index]];
//    }
//
//    return nil;
    
    // 多条曲线
    return [NSString stringWithFormat:@"%@分", _datas[lineNumber][index]];
}

- (UIView *)lineChartView:(SYChartLine *)charLine hintViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // 自定义曲线点顶端信息视图
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 20.0)];
//    label.adjustsFontSizeToFitWidth = YES;
//    if (lineNumber == 0)
//    {
//        label.backgroundColor = [UIColor purpleColor];
//    }
//    else if (lineNumber == 1)
//    {
//        label.backgroundColor = [UIColor lightGrayColor];
//    }
//    else if (lineNumber == 2)
//    {
//        label.backgroundColor = [UIColor redColor];
//    }
//    NSString *text = [NSString stringWithFormat:@"%@分", _datas[lineNumber][index]];
//    label.text = text;
//    
//    return label;
    
    // 或
    NSString *text = [NSString stringWithFormat:@"%@分", _datas[lineNumber][index]];
    SYChartInfromationView *informationView = [[SYChartInfromationView alloc] initWithText:text];
    informationView.frame = CGRectMake(0.0, 0.0, 40.0, 25.0);
    if (lineNumber == 0)
    {
        informationView.informationViewBackgroundColor = [UIColor purpleColor];
        informationView.informationViewTextColor = [UIColor greenColor];
        informationView.informationViewTextFont = [UIFont systemFontOfSize:8.0];
    }
    else if (lineNumber == 1)
    {
        informationView.informationViewBackgroundColor = [UIColor lightGrayColor];
        informationView.informationViewTextColor = [UIColor brownColor];
        informationView.informationViewTextFont = [UIFont systemFontOfSize:12.0];
    }
    else if (lineNumber == 2)
    {
        informationView.informationViewBackgroundColor = [UIColor redColor];
        informationView.informationViewTextColor = [UIColor orangeColor];
        informationView.informationViewTextFont = [UIFont systemFontOfSize:10.0];
    }

    return informationView;
}

- (UIView *)lineChartView:(SYChartLine *)charLine pointViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // 自定义曲线点视图
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
    if (lineNumber == 0)
    {
        label.backgroundColor = [UIColor purpleColor];
    }
    else if (lineNumber == 1)
    {
        label.backgroundColor = [UIColor lightGrayColor];
    }
    else if (lineNumber == 2)
    {
        label.backgroundColor = [UIColor redColor];
    }
    label.layer.cornerRadius = (CGRectGetHeight(label.bounds) / 2);
    label.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    label.userInteractionEnabled = YES;
    label.tag = index;
    [label addGestureRecognizer:tapRecognizer];
    
    return label;
}

- (void)tapClick:(UITapGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    NSInteger index = view.tag;
    NSLog(@"index click %@", @(index));
}

@end
