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
    _datas = @[@[@50, @68, @93, @66, @75],@[@70, @61, @92, @61, @50],@[@59, @88, @63, @66, @71]];
    
    SYChartLine *chartLine = [[SYChartLine alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:chartLine];
    chartLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    chartLine.dotRadius = 5;
    chartLine.dotColor = [UIColor greenColor];
    chartLine.solidDot = NO;
//    chartLine.showDot = NO;
    chartLine.oppositeY = NO;
    chartLine.dataSource = self;
    chartLine.delegate = self;
    chartLine.minValue = @0;
    chartLine.maxValue = @100;
    chartLine.numberOfYAxis = 10;
    chartLine.colorOfXAxis = [UIColor redColor];
    chartLine.colorOfXText = [UIColor greenColor];
    chartLine.colorOfYAxis = [UIColor orangeColor];
    chartLine.colorOfYText = [UIColor purpleColor];
    chartLine.yFontSize = 10.0;
    chartLine.unitOfYAxis = @"分";
    chartLine.xFontSize = 10.0;
    
    // 功能未完成
//    chartLine.isSmoothLines = YES;
    
    chartLine.gridsLineColor = [UIColor brownColor];
    chartLine.gridsType = SYChartGridsTypeGridDotted;
    chartLine.gridsLineWidth = 0.5;
    
    chartLine.animationTime = 0.1;
    
    [chartLine reloadDataWithAnimate:YES];
}

// MCLineChartViewDataSource

- (NSUInteger)lineChartView:(SYChartLine *)charLine lineCountAtLineNumber:(NSInteger)number
{
    // Y垂直坐标曲线点个数
    // 1条曲线
//    return [_dataSource count];
    
    // 多条曲线
    return [_datas[number] count];
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

- (NSString *)lineChartView:(SYChartLine *)charLine titleAtLineNumber:(NSInteger)number
{
    // x坐标标题
    return _titles[number];
}

// MCLineChartViewDelegate

//- (UIColor *)lineChartView:(SYChartLine *)charLine lineColorWithLineNumber:(NSInteger)lineNumber
//{
//
//}
//- (CGFloat)lineChartView:(SYChartLine *)charLine lineWidthWithLineNumber:(NSInteger)lineNumber
//{
//
//}
//
//- (CGFloat)dotPaddingInLineChartView:(SYChartLine *)charLine
//{
//
//}
//
//- (NSString *)lineChartView:(SYChartLine *)charLine informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
//{
//
//}
//
//- (UIView *)lineChartView:(SYChartLine *)charLine hintViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
//{
//
//}
//
//- (UIView *)lineChartView:(SYChartLine *)charLine pointViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
//{
//
//}

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
    else
    {
        return [UIColor yellowColor];
    }
}

- (NSString *)lineChartView:(SYChartLine *)charLine informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
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

//- (UIView *)lineChartView:(SYChartLine *)charLine hintViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
//{
//    // 自定义曲线点顶端信息视图
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 20.0)];
//    label.adjustsFontSizeToFitWidth = YES;
//    NSString *text = [NSString stringWithFormat:@"%@分", _dataSource[index]];
//    label.text = text;
//
//    return label;
//}

//- (UIView *)lineChartView:(SYChartLine *)charLine pointViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
//{
//    // 自定义曲线点视图
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
//    label.backgroundColor = [UIColor greenColor];
//    label.layer.cornerRadius = 5.0;
//    label.layer.masksToBounds = YES;
//    
//    return label;
//}


@end
