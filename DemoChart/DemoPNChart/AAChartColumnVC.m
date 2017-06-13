//
//  AAChartColumnVC.m
//  DemoChart
//
//  Created by herman on 2017/6/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "AAChartColumnVC.h"
#import "AAChartView.h"

@interface AAChartColumnVC ()

@property (nonatomic, strong) AAChartModel *chartModel;
@property (nonatomic, strong) AAChartView *chartView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation AAChartColumnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat height = 0.0;
    

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

    
    //
    self.chartView = [[AAChartView alloc] initWithFrame:CGRectMake(0.0, height, self.view.frame.size.width, (self.view.frame.size.height - height))];
    [self.view addSubview:self.chartView];
    self.chartView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    self.chartView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    // 数据
    self.chartModel = AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeColumn) // 类型
    .titleSet(@"编程语言热度") // 图表标题
    .subtitleSet(@"虚拟数据") // 图表副标题（x轴标题）
    .pointHollowSet(true)
    .categoriesSet(@[@"Java", @"Swift", @"Python", @"Ruby", @"PHP", @"Go", @"C", @"C#", @"C++", @"Perl", @"R", @"MATLAB", @"SQL"]) // 图表副标题（y轴标题）
    .yAxisTitleSet(@"摄氏度") // y轴单位
    .seriesSet(@[AAObject(AASeriesElement)
                 .nameSet(@"2017")
                 .dataSet(@[@45, @88, @49, @43, @65, @56, @47, @28, @49, @44, @89, @55, @11]),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"2018")
                 .dataSet(@[@31, @22, @33, @54, @35, @36, @27, @38, @39, @54, @41, @29]),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"2019")
                 .dataSet(@[@11, @12, @13, @14, @15, @16, @17, @18, @19, @33, @56, @39]),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"2020")
                 .dataSet(@[@21, @22, @24, @27, @25, @26, @37, @28, @49, @56, @31, @11]),
                 ]);
    // 其他属性设置
//    self.chartModel.backgroundColor = @"0x564654";
//    self.chartModel.yMax = @150;
//    self.chartModel.yMin = @0;
//    self.chartModel.yTickPositions = @[@10, @20, @30, @50, @80, @130];
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingMethord) name:AAChartNotificationStatusLoading object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedSuccessMethord) name:AAChartNotificationStatusLoadedSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedFailedMethord) name:AAChartNotificationStatusLoadedFailed object:nil];
    
    // 绘图
    [self.chartView aa_drawChartWithChartModel:_chartModel];
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

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = self.chartView.center;
        _activityView.hidesWhenStopped = YES;
        _activityView.color = [UIColor redColor];
    }
    return _activityView;
}

- (void)loadingMethord
{
    if (self.activityView.superview == nil)
    {
        [self.view addSubview:self.activityView];
    }
    [self.activityView startAnimating];
}

- (void)loadedSuccessMethord
{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
}

- (void)loadedFailedMethord
{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
}

@end
