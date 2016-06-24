//
//  SYChartBar.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  

#import <UIKit/UIKit.h>

#import "SYChartHelper.h"

////////////////////////////////////////////////////////////////////////////////////////////

@class SYChartBar;
@class UITableView;

@protocol SYChartBarDataSource <NSObject>

@required
/**
 *  每个X轴标题对应的bar个数
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *
 *  @return 每个X轴标题对应的bar个数
 */
- (NSInteger)barChartView:(SYChartBar *)chartBar numberOfBarsInSection:(NSInteger)section;

/**
 *  每个X轴标题对应的每个Y轴的信息
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    当前曲线视图 SYChartBar 的索引
 *
 *  @return 每个X轴标题对应的每个Y轴的信息
 */
- (id)barChartView:(SYChartBar *)chartBar valueOfBarInSection:(NSInteger)section index:(NSInteger)index;

@optional
/**
 *  总的bar个数
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return 总的bar个数
 */
- (NSInteger)numberOfSectionsInBarChartView:(SYChartBar *)chartBar;

/**
 *  Y轴标题
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *
 *  @return Y轴标题
 */
- (NSString *)barChartView:(SYChartBar *)chartBar titleOfBarInSection:(NSInteger)section;


@end

@protocol SYChartBarDelegate <NSObject>

@optional
/**
 *  被点击选中bar
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param index    当前曲线视图 SYChartBar 的索引
 */
- (void)barChartView:(SYChartBar *)chartBar didSelectBarAtIndex:(NSUInteger)index;

/**
 *  bar的宽度
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return bar的宽度
 */
- (CGFloat)barWidthInBarChartView:(SYChartBar *)chartBar;

/**
 *  每个section之间的bar之间的间距
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return 每个section之间的bar之间的间距
 */
- (CGFloat)paddingForSectionInBarChartView:(SYChartBar *)chartBar;

/**
 *  每个section里的bar之间的间距（section有多个）
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return 每个section里的bar之间的间距（section有多个）
 */
- (CGFloat)paddingForBarInBarChartView:(SYChartBar *)chartBar;

/**
 *  bar的颜色设置
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    当前曲线视图 SYChartBar 的索引
 *
 *  @return bar的颜色设置
 */
- (UIColor *)barChartView:(SYChartBar *)chartBar colorOfBarInSection:(NSInteger)section index:(NSInteger)index;

/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *
 *  @return <#return value description#>
 */
- (NSArray *)barChartView:(SYChartBar *)chartBar selectionColorForBarInSection:(NSUInteger)section;

/**
 *  bar顶端信息标题
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    当前曲线视图 SYChartBar 的索引
 *
 *  @return bar顶端信息标题
 */
- (NSString *)barChartView:(SYChartBar *)chartBar informationOfBarInSection:(NSInteger)section index:(NSInteger)index;

/**
 *  bar顶端信息自定义视图
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    当前曲线视图 SYChartBar 的索引
 *
 *  @return bar顶端信息自定义视图
 */
- (UIView *)barChartView:(SYChartBar *)chartBar hintViewOfBarInSection:(NSInteger)section index:(NSInteger)index;

@end

////////////////////////////////////////////////////////////////////////////////////////////

@interface SYChartBar : UIView

/// 数据源代理
@property (nonatomic, weak) id<SYChartBarDataSource> dataSource;
/// bar图表对象
@property (nonatomic, weak) id<SYChartBarDelegate> delegate;

/// 最大值，如果未设置计算数据源中的最大值
@property (nonatomic, strong) id maxValue;
/// y轴数据标记个数
@property (nonatomic, assign) NSInteger numberOfYAxis;
/// y轴数据单位
@property (nonatomic, copy) NSString *unitOfYAxis;
/// y轴的颜色
@property (nonatomic, strong) UIColor *colorOfYAxis;
/// y轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfYText;
/// y轴文本文字大小
@property (nonatomic, assign) CGFloat yFontSize;

/// x轴的颜色
@property (nonatomic, strong) UIColor *colorOfXAxis;
/// x轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfXText;
/// x轴文本文字大小
@property (nonatomic, assign) CGFloat xFontSize;


// 开发中... begin


/// bar动画时间（默认0.6）
@property (nonatomic, assign) NSTimeInterval animationTime;

/**
 *
 *  网格显示类型（默认不显示）
 *  样式：网络栅格、水平虚线、水平实线、垂直虚线、垂直实线
 *  显示X轴水平条数与 numberOfYAxis 个数有关
 *
 */
@property (nonatomic, assign) SYChartGridsType gridsType;
/// 网络线条大小
@property (nonatomic, assign) CGFloat gridsLineWidth;
/// 网格线条颜色
@property (nonatomic, strong) UIColor *gridsLineColor;

/// Y坐标值显示类型（坐标轴左侧、坐标轴右侧；默认坐标轴左侧）
@property (nonatomic, assign) SYChartYAxisType yAxisType;
/// Y坐标轴是否显示刻度（默认不显示）
@property (nonatomic, assign) BOOL showYScale;

// 开发中... end


/**
 *  刷新数据（默认动画模式）
 */
- (void)reloadData;

/**
 *  刷新数据
 *
 *  @param animate 是否动画模式
 */
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
