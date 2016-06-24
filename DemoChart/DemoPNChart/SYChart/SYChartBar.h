//
//  SYChartBar.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
 */
- (id)barChartView:(SYChartBar *)chartBar valueOfBarInSection:(NSInteger)section index:(NSInteger)index;

@optional
/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInBarChartView:(SYChartBar *)chartBar;

/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *
 *  @return <#return value description#>
 */
- (NSString *)barChartView:(SYChartBar *)chartBar titleOfBarInSection:(NSInteger)section;


@end

@protocol SYChartBarDelegate <NSObject>

@optional
/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param index    <#index description#>
 */
- (void)barChartView:(SYChartBar *)chartBar didSelectBarAtIndex:(NSUInteger)index;

/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return <#return value description#>
 */
- (CGFloat)barWidthInBarChartView:(SYChartBar *)chartBar;

/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return <#return value description#>
 */
- (CGFloat)paddingForSectionInBarChartView:(SYChartBar *)chartBar;

/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *
 *  @return <#return value description#>
 */
- (CGFloat)paddingForBarInBarChartView:(SYChartBar *)chartBar;

/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
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
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)barChartView:(SYChartBar *)chartBar informationOfBarInSection:(NSInteger)section index:(NSInteger)index;

/**
 *  <#Description#>
 *
 *  @param chartBar 当前柱状视图 SYChartBar
 *  @param section  当前柱状视图 SYChartBar 的线条索引
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
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
/// x轴的颜色
@property (nonatomic, strong) UIColor *colorOfXAxis;
/// x轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfXText;

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
