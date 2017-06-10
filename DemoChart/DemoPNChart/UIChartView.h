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

/*
 使用示例：
 
 1 导入头文件
 #import "UIChartView.h"
 
 2 实例化
 UIChartView *chartView = [[UIChartView alloc] initWithFrame:CGRectMake(0.0, height, self.view.frame.size.width, (self.view.frame.size.height - height)) view:self.view];
 chartView.chartModel.chartTypeSet(AAChartTypeBar); // 类型
 chartView.chartTitle = @"编程语言热度";
 chartView.chartSubTitle = @"虚拟数据";
 chartView.chartXTitles = @[@"Java", @"Swift", @"Python", @"Objective-C", @"PHP", @"Go"];
 chartView.chartYTitle = @"摄氏度";
 NSMutableArray *array = [NSMutableArray array];
 for (int i = 0; i < 4; i++)
 {
     ChartModel *model = [ChartModel new];
     if (0 == i)
     {
         model.name = @"2014";
         model.datas = @[@45, @88, @49, @43, @65, @56];
     }
     else if (1 == i)
     {
         model.name = @"2015";
         model.datas = @[@31, @22, @33, @54, @35, @36];
     }
     else if (2 == i)
     {
         model.name = @"2016";
         model.datas = @[@11, @12, @13, @14, @15, @16];
     }
     else if (3 == i)
     {
         model.name = @"2017";
         model.datas = @[@21, @22, @24, @27, @25, @26];
     }
     
     [array addObject:model];
 }
 chartView.charts = array;
 chartView.showActivityIndicatorView = YES;
 [chartView reloadChart];
 
 */

