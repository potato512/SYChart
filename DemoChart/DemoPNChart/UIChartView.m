//
//  UIChartView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/6/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "UIChartView.h"

/**************************************************/

@implementation ChartModel

@end

/**************************************************/

@interface UIChartView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation UIChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.chartModel = AAObject(AAChartModel);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view
{
    self = [super init];
    if (self)
    {
        self.frame = frame;
        if (view)
        {
            [view addSubview:self];
        }
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.chartModel = AAObject(AAChartModel);
        
        [self addNotificationCenter];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@ 被释放了...", self);
}

#pragma mark - getter

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = self.center;
        _activityView.hidesWhenStopped = YES;
        _activityView.color = [UIColor redColor];
    }
    return _activityView;
}

#pragma mark - setter

- (void)setCharts:(NSArray<ChartModel *> *)charts
{
    _charts = charts;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_charts.count];
    for (ChartModel *model in _charts)
    {
        AASeriesElement *element = AAObject(AASeriesElement);
        element.nameSet(model.name);
        element.dataSet(model.datas);
        if (model.type)
        {
            element.type = model.type;
        }
        
        [array addObject:element];
    }
    self.chartModel.seriesSet(array);
}

- (void)setChartTitle:(NSString *)chartTitle
{
    _chartTitle = chartTitle;
//    self.chartModel.titleSet(_chartTitle);
    self.chartModel.title = _chartTitle;
}

- (void)setChartSubTitle:(NSString *)chartSubTitle
{
    _chartSubTitle = chartSubTitle;
//    self.chartModel.subtitleSet(_chartSubTitle);
    self.chartModel.subtitle = _chartTitle;
}

- (void)setChartXTitles:(NSArray *)chartXTitles
{
    _chartXTitles = chartXTitles;
//    self.chartModel.categoriesSet(_chartXTitles);
    self.chartModel.categories = _chartXTitles;
}

- (void)setChartYTitle:(NSString *)chartYTitle
{
    _chartYTitle = chartYTitle;
//    self.chartModel.yAxisTitleSet(_chartYTitle);
    self.chartModel.yAxisTitle = _chartYTitle;
}

- (void)setShowActivityIndicatorView:(BOOL)showActivityIndicatorView
{
    _showActivityIndicatorView = showActivityIndicatorView;
    if (_showActivityIndicatorView)
    {
        [self addNotificationCenter];
    }
}

#pragma mark - notificationCenter

- (void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingMethord) name:AAChartNotificationStatusLoading object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedSuccessMethord) name:AAChartNotificationStatusLoadedSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadedFailedMethord) name:AAChartNotificationStatusLoadedFailed object:nil];
}

- (void)loadingMethord
{
    if (self.activityView.superview == nil)
    {
        [self.superview addSubview:self.activityView];
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

#pragma mark - methord

// 创建视图
- (void)reloadChart
{
    [self aa_drawChartWithChartModel:self.chartModel];
}

// 刷新视图
- (void)refreshChart
{
    // 刷新数据
    [self aa_refreshChartWithChartModel:self.chartModel];
}

@end
