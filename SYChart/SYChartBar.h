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
- (NSInteger)barChartView:(SYChartBar *)chartBar numberOfBarsForSection:(NSInteger)section;

/**
 *  每个X轴标题对应的每个Y轴的信息
 *
 *  @param chartBar  当前柱状视图 SYChartBar
 *  @param indexPath 索引
 *
 *  @return 每个X轴标题对应的每个Y轴的信息
 */
- (id)barChartView:(SYChartBar *)chartBar valueOfBarAtIndexPath:(NSIndexPath *)indexPath;

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
 *  @param index  当前柱状视图 SYChartBar 的线条索引
 *
 *  @return Y轴标题
 */
- (NSString *)barChartView:(SYChartBar *)chartBar titleOfBarForSection:(NSInteger)index;


@end

@protocol SYChartBarDelegate <NSObject>

@optional

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
 *  @param chartBar  当前柱状视图 SYChartBar
 *  @param indexPath 索引
 *
 *  @return bar的颜色设置
 */
- (UIColor *)barChartView:(SYChartBar *)chartBar colorOfBarAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  bar顶端信息标题
 *
 *  @param chartBar  当前柱状视图 SYChartBar
 *  @param indexPath 索引
 *
 *  @return bar顶端信息标题
 */
- (NSString *)barChartView:(SYChartBar *)chartBar informationOfBarAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  bar顶端信息自定义视图
 *
 *  @param chartBar  当前柱状视图 SYChartBar
 *  @param indexPath 索引
 *
 *  @return bar顶端信息自定义视图
 */
- (UIView *)barChartView:(SYChartBar *)chartBar hintViewOfBarAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  bar点击事件
 *
 *  @param chartBar  当前柱状视图 SYChartBar
 *  @param indexPath 索引
 */
- (void)barChartView:(SYChartBar *)chartBar didSelectBarAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  bar顶端视图的点击事件
 *
 *  @param chartBar  当前柱状视图 SYChartBar
 *  @param indexPath 索引
 */
- (void)barChartView:(SYChartBar *)chartBar didSelectBarDotViewAtIndexPath:(NSIndexPath *)indexPath;

@end

////////////////////////////////////////////////////////////////////////////////////////////

@interface SYChartBar : UIView

#pragma mark - 代理对象

/// 数据源代理
@property (nonatomic, weak) id<SYChartBarDataSource> dataSource;
/// bar图表对象
@property (nonatomic, weak) id<SYChartBarDelegate> delegate;

#pragma mark - 坐标轴

#pragma mark Y坐标轴

/// 最大值，如果未设置计算数据源中的最大值
@property (nonatomic, strong) id maxValue;
/// y轴数据标记个数（默认5个）
@property (nonatomic, assign) NSInteger numberOfYAxis;
/// y轴数据单位（默认为空）
@property (nonatomic, copy) NSString *unitOfYAxis;
/// y轴的颜色（默认黑色）
@property (nonatomic, strong) UIColor *colorOfYAxis;
/// y轴文本数据颜色（默认黑色）
@property (nonatomic, strong) UIColor *colorOfYText;
/// y轴文本文字大小（默认14号）
@property (nonatomic, assign) CGFloat yFontSize;

#pragma mark Y坐标轴标题
/// Y坐标轴标题内容（默认无）
@property (nonatomic, strong) NSString *yUnitText;
/// Y坐标轴标题颜色（默认黑色）
@property (nonatomic, strong) UIColor *yUnitColor;
/// Y坐标轴标题文字大小（默认14号）
@property (nonatomic, assign) CGFloat yUnitFontSize;

#pragma mark X坐标轴

/// x轴的颜色（默认黑色）
@property (nonatomic, strong) UIColor *colorOfXAxis;
/// x轴文本数据颜色（默认黑色）
@property (nonatomic, strong) UIColor *colorOfXText;
/// x轴文本文字大小（默认14号）
@property (nonatomic, assign) CGFloat xFontSize;
/// x轴文本文字大小自适应（默认非自适应）
@property (nonatomic, assign) BOOL xFontSizeAuto;

#pragma mark X坐标轴标题
/// X坐标轴标题内容（默认无）
@property (nonatomic, strong) NSString *xUnitText;
/// X坐标轴标题颜色（默认黑色）
@property (nonatomic, strong) UIColor *xUnitColor;
/// X坐标轴标题文字大小（默认14号）
@property (nonatomic, assign) CGFloat xUnitFontSize;

#pragma mark - 数据点

/// 数据点信息标题背景颜色（默认白色）
@property (nonatomic, strong) UIColor *dotTitleBackgroundColor;
/// 数据点信息标题字体颜色（默认黑色）
@property (nonatomic, strong) UIColor *dotTitleColor;
/// 数据点信息标题字体大小（默认12号）
@property (nonatomic, strong) UIFont *dotTitleFont;

#pragma mark - 动画时间

/// bar动画时间（默认0.6）
@property (nonatomic, assign) NSTimeInterval animationTime;

#pragma mark - 网格线

/**
 *
 *  网格显示类型（默认不显示）
 *  样式：网络栅格、水平虚线、水平实线、垂直虚线、垂直实线
 *  显示X轴水平条数与 numberOfYAxis 个数有关
 *
 */
@property (nonatomic, assign) SYChartGridsType gridsType;
/// 网络线条大小（默认0.5）
@property (nonatomic, assign) CGFloat gridsLineWidth;
/// 网格线条颜色（默认灰色）
@property (nonatomic, strong) UIColor *gridsLineColor;

#pragma mark - 刷新数据

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
