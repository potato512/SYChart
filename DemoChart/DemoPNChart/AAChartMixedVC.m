//
//  AAChartMixedVC.m
//  DemoChart
//
//  Created by herman on 2017/6/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "AAChartMixedVC.h"
#import "AAChartView.h"

@interface AAChartMixedVC ()

@property (nonatomic, strong) AAChartModel *chartModel;
@property (nonatomic, strong) AAChartView *chartView;

@end

@implementation AAChartMixedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat height = 0.0;
    
    /*
    //
    NSArray *segmentedArray = @[@[@"常规", @"堆叠", @"百分比堆叠"], @[@"波点", @"方块", @"钻石", @"正三角", @"倒三角"]];
    NSArray *typeLabelNameArr = @[@"堆叠类型选择", @"折线连接点形状选择"];
    for (int i = 0; i < segmentedArray.count; i++)
    {
        UILabel *typeLabel = [[UILabel alloc] init];
        [self.view addSubview:typeLabel];
        typeLabel.frame = CGRectMake(10.0, ((20.0 + 20.0) * i + 10.0), (self.view.frame.size.width - 20.0), 20.0);
        typeLabel.text = typeLabelNameArr[i];
        typeLabel.font = [UIFont systemFontOfSize:11.0f];
        
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:segmentedArray[i]];
        [self.view addSubview:segmentControl];
        segmentControl.frame = CGRectMake(10.0, ((20.0 + 20.0) * i + (10.0 + 20.0)), (self.view.frame.size.width - 20.0), 20.0);
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.tag = i;
        [segmentControl addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
        
        height = segmentControl.frame.origin.y + segmentControl.frame.size.height + 10.0;
    }
    
    //
    NSArray *nameArr = @[@"x轴翻转", @"y轴翻转", @"x 轴直立", @"辐射化图形", @"隐藏连接点", @"显示数字"];
    NSInteger countName = nameArr.count;
    CGFloat widthName = (self.view.frame.size.width - 10.0 * (countName + 1)) / countName;
    for (int i = 0; i < countName; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        [self.view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.frame = CGRectMake(((widthName + 10.0) * i + 10.0),  height, widthName, 20.0);
        label.text = nameArr[i];
        
        UISwitch *switchView = [[UISwitch alloc] init];
        [self.view addSubview:switchView];
        switchView.frame = CGRectMake(((widthName + 10.0) * i + 10.0), (height + 20.0), widthName, 20.0);
        switchView.on = NO;
        switchView.tag = i;
        [switchView addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        
        if (i == countName - 1)
        {
            height = switchView.frame.origin.y + switchView.frame.size.height + 10.0;
        }
    }
    */
    
    //
    self.chartView = [[AAChartView alloc] initWithFrame:CGRectMake(0.0, height, self.view.frame.size.width, (self.view.frame.size.height - height))];
    [self.view addSubview:self.chartView];
    self.chartView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    self.chartView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    // 数据
    self.chartModel = AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeFunnel) // 类型
    .titleSet(@"城市温度") // 图表标题
    .subtitleSet(@"虚拟数据") // 图表副标题（x轴标题）
    .pointHollowSet(true)
    .categoriesSet(@[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"]) // 图表副标题（y轴标题）
    .dataLabelEnabledSet(true)
    .yAxisTitleSet(@"摄氏度") // y轴单位
    .seriesSet(@[AAObject(AASeriesElement)
                 .typeSet(AAChartTypeColumnrange)
                 .nameSet(@"温度")
                 .dataSet(@[@[@-9.7, @9.4], @[@-8.7, @6.5], @[@-3.5, @9.4], @[@-1.4, @19.9], @[@0.0, @22.6], @[@2.9, @29.5], @[@9.2, @30.7], @[@4.4, @18.0], @[@-3.1, @11.4], @[@-5.2, @10.4], @[@-13.5, @9.8]]),
                 
                 AAObject(AASeriesElement)
                 .typeSet(AAChartTypeSpline)
                 .nameSet(@"北京")
                 .dataSet(@[@7.0, @6.9, @9.5, @14.5, @18.2, @21.5, @25.2, @26.5, @23.3, @18.3, @13.9, @9.6]),
                 
                 AAObject(AASeriesElement)
                 .typeSet(AAChartTypeSpline)
                 .nameSet(@"上海")
                 .dataSet(@[@-0.2, @0.8, @5.7, @11.3, @17.0, @22.0, @24.8, @24.1, @20.1, @14.1, @8.6, @2.5]),
                 
                 AAObject(AASeriesElement)
                 .typeSet(AAChartTypeSpline)
                 .nameSet(@"广州")
                 .dataSet(@[@-0.9, @0.6, @3.5, @8.4, @13.5, @17.0, @18.6, @17.9, @14.3, @9.0, @3.9, @1.0]),
                 
                 AAObject(AASeriesElement)
                 .typeSet(AAChartTypeSpline)
                 .nameSet(@"深圳")
                 .dataSet(@[@3.9, @4.2, @5.7, @8.5, @11.9, @15.2, @17.0, @16.6, @14.2, @10.3, @6.6, @4.8]),
                 ]);
    // 绘图
    [self.chartView aa_drawChartWithChartModel:_chartModel];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedClick:(UISegmentedControl *)segmentedControl
{
    switch (segmentedControl.tag)
    {
        case 0:
        {
            // 堆叠类型
            NSArray *stackingArr = @[AAChartStackingTypeFalse, AAChartStackingTypeNormal, AAChartStackingTypePercent];
            self.chartModel.stacking = stackingArr[segmentedControl.selectedSegmentIndex];
        }
            break;
        case 1:
        {
            // 折线连接点形状
            NSArray *symbolArr = @[AAChartSymbolTypeCircle, AAChartSymbolTypeSquare, AAChartSymbolTypeDiamond, AAChartSymbolTypeTriangle, AAChartSymbolTypeTriangle_down];
            self.chartModel.symbol = symbolArr[segmentedControl.selectedSegmentIndex];
        }
            break;
        default: break;
    }
    
    // 刷新数据
    [self.chartView aa_refreshChartWithChartModel:self.chartModel];
}

- (void)switchClick:(UISwitch *)switchView
{
    switch (switchView.tag)
    {
            // x轴翻转
        case 0: self.chartModel.xAxisReversed = (switchView.on ? true : false); break;
            // y轴翻转
        case 1: self.chartModel.yAxisReversed = (switchView.on ? true : false); break;
            // x轴直立
        case 2: self.chartModel.inverted = (switchView.on ? true : false); break;
            // 从中心向四周辐射
        case 3: self.chartModel.polar = (switchView.on ? true : false); break;
            // 隐藏连接点
        case 4: self.chartModel.markerRadius = (switchView.on ? @0 : @5); break;
            // 显示数据点
        case 5: self.chartModel.dataLabelEnabled = (switchView.on ? true : false); break;
            
        default: break;
    }
    
    // 刷新数据
    [self.chartView aa_refreshChartWithChartModel:self.chartModel];
}

@end
