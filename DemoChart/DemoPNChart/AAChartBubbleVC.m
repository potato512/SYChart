//
//  AAChartBubbleVC.m
//  DemoChart
//
//  Created by herman on 2017/6/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "AAChartBubbleVC.h"
#import "UIChartView.h"

@interface AAChartBubbleVC ()

@property (nonatomic, strong) UIChartView *chartView;

@end

@implementation AAChartBubbleVC

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
    self.chartView = [[UIChartView alloc] initWithFrame:CGRectMake(0.0, height, self.view.frame.size.width, (self.view.frame.size.height - height)) view:self.view];
    self.chartView.chartModel.chartTypeSet(AAChartTypeBubble); // 类型
    self.chartView.chartTitle = @"编程语言热度";
    self.chartView.chartSubTitle = @"虚拟数据";
    self.chartView.chartXTitles = @[@"Java", @"Swift", @"Python", @"Objective-C", @"PHP", @"Go"];
    self.chartView.chartYTitle = @"摄氏度";
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 4; i++)
    {
        ChartModel *model = [ChartModel new];
        if (0 == i)
        {
            model.name = @"2014";
            model.datas = @[@[@97, @36, @79], @[@94, @74, @60], @[@68, @76, @58], @[@64, @87, @56], @[@68, @27, @73], @[@57, @86, @31]];
        }
        else if (1 == i)
        {
            model.name = @"2015";
            model.datas = @[@[@91, @50, @71], @[@64, @34, @68], @[@18, @70, @51], @[@58, @80, @66], @[@56, @58, @71], @[@27, @46, @58]];
        }
        else if (2 == i)
        {
            model.name = @"2016";
            model.datas = @[@[@68, @16, @49], @[@55, @68, @20], @[@38, @71, @55], @[@99, @81, @52], @[@51, @47, @75], @[@37, @50, @34]];
        }
        else if (3 == i)
        {
            model.name = @"2017";
            model.datas = @[@[@60, @86, @30], @[@21, @79, @30], @[@88, @36, @38], @[@18, @83, @53], @[@46, @87, @56], @[@68, @16, @36]];
        }
        
        [array addObject:model];
    }
    self.chartView.charts = array;
    [self.chartView reloadChart];
}

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
            self.chartView.chartModel.stacking = stackingArr[segmentedControl.selectedSegmentIndex];
        }
            break;
        case 1:
        {
            // 折线连接点形状
            NSArray *symbolArr = @[AAChartSymbolTypeCircle, AAChartSymbolTypeSquare, AAChartSymbolTypeDiamond, AAChartSymbolTypeTriangle, AAChartSymbolTypeTriangle_down];
            self.chartView.chartModel.symbol = symbolArr[segmentedControl.selectedSegmentIndex];
        }
            break;
        default: break;
    }
    
    // 刷新数据
    [self.chartView refreshChart];
}

- (void)switchClick:(UISwitch *)switchView
{
    switch (switchView.tag)
    {
            // x轴翻转
        case 0: self.chartView.chartModel.xAxisReversed = (switchView.on ? true : false); break;
            // y轴翻转
        case 1: self.chartView.chartModel.yAxisReversed = (switchView.on ? true : false); break;
            // x轴直立
        case 2: self.chartView.chartModel.inverted = (switchView.on ? true : false); break;
            // 从中心向四周辐射
        case 3: self.chartView.chartModel.polar = (switchView.on ? true : false); break;
            // 隐藏连接点
        case 4: self.chartView.chartModel.markerRadius = (switchView.on ? @0 : @5); break;
            // 显示数据点
        case 5: self.chartView.chartModel.dataLabelEnabled = (switchView.on ? true : false); break;
            
        default: break;
    }
    
    // 刷新数据
    [self.chartView refreshChart];
}

@end
