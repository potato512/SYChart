//
//  UIChartView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/6/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "AAChartView.h"

/**************************************************/

@interface ChartModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSString *type;

@end

/**************************************************/


@interface UIChartView : AAChartView

- (instancetype)init __attribute__((unavailable("init 方法不可用，请用initWithFrame: 或initWithFrame: view:")));

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view;


/// 数据model
@property (nonatomic, strong) AAChartModel *chartModel;

/// 数据源
@property (nonatomic, strong) NSArray <ChartModel *> *charts;

/// 图表标题
@property (nonatomic, strong) NSString *chartTitle;
/// 图表副标题
@property (nonatomic, strong) NSString *chartSubTitle;

/// x轴标题集
@property (nonatomic, strong) NSArray <NSString *> *chartXTitles;
/// y轴单位标题
@property (nonatomic, strong) NSString *chartYTitle;

/// 是否显示加载状态（默认不显示）
@property (nonatomic, assign) BOOL showActivityIndicatorView;

// 创建视图
- (void)reloadChart;

// 刷新视图
- (void)refreshChart;

@end
