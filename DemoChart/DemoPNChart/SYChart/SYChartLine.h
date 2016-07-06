//
//  SYChartLine.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  

#import <UIKit/UIKit.h>

#import "SYChartHelper.h"

////////////////////////////////////////////////////////////////////////////////////////////

@class SYChartLine;
@protocol SYChartLineDataSource <NSObject>

@required
/**
 *  Y垂直坐标曲线点个数
 *
 *  @param charLine 当前曲线视图 SYChartLine
 *  @param number   当前曲线视图 SYChartLine 的线条索引
 *
 *  @return Y垂直坐标曲线点个数
 */
- (NSUInteger)lineChartView:(SYChartLine *)charLine lineCountAtLineNumber:(NSInteger)number;

/**
 *  Y垂直坐标信息
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *  @param lineNumber 当前曲线视图 SYChartLine 的线条索引
 *  @param index      当前曲线视图 SYChartLine 的索引
 *
 *  @return Y垂直坐标信息
 */
- (id)lineChartView:(SYChartLine *)charLine valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index;

@optional

/**
 *  曲线条数
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *
 *  @return 曲线条数
 */
- (NSUInteger)numberOfLinesInLineChartView:(SYChartLine *)charLine;

/**
 *  X水平坐标标题
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *  @param number     当前曲线视图 SYChartLine 的线条索引
 *
 *  @return X水平坐标标题
 */
- (NSString *)lineChartView:(SYChartLine *)charLine titleAtLineNumber:(NSInteger)number;

@end

@protocol SYChartLineDelegate <NSObject>

@optional
/**
 *  曲线颜色
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *  @param lineNumber 当前曲线视图 SYChartLine 的线条索引
 *
 *  @return 曲线颜色
 */
- (UIColor *)lineChartView:(SYChartLine *)charLine lineColorWithLineNumber:(NSInteger)lineNumber;

/**
 *  曲线大小
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *  @param lineNumber 当前曲线视图 SYChartLine 的线条索引
 *
 *  @return 曲线大小
 */
- (CGFloat)lineChartView:(SYChartLine *)charLine lineWidthWithLineNumber:(NSInteger)lineNumber;

/**
 *  曲线间隔大小
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *
 *  @return 曲线间隔大小
 */
- (CGFloat)dotPaddingInLineChartView:(SYChartLine *)charLine;

/**
 *  曲线点顶端信息
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *  @param lineNumber 当前曲线视图 SYChartLine 的线条索引
 *  @param index      当前曲线视图 SYChartLine 的索引
 *
 *  @return 曲线点顶端信息
 */
- (NSString *)lineChartView:(SYChartLine *)charLine informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;

/**
 *  自定义曲线点顶端信息视图
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *  @param lineNumber 当前曲线视图 SYChartLine 的线条索引
 *  @param index      当前曲线视图 SYChartLine 的索引
 *
 *  @return 自定义曲线点顶端信息视图
 */
- (UIView *)lineChartView:(SYChartLine *)charLine hintViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;

/**
 *  自定义曲线点视图
 *
 *  @param charLine   当前曲线视图 SYChartLine
 *  @param lineNumber 当前曲线视图 SYChartLine 的线条索引
 *  @param index      当前曲线视图 SYChartLine 的索引
 *
 *  @return 自定义曲线点视图
 */
- (UIView *)lineChartView:(SYChartLine *)charLine pointViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index;

@end

////////////////////////////////////////////////////////////////////////////////////////////

CGFloat static const kSYChartLineUndefinedValue = -1.0f;

@interface SYChartLine : UIView

/// 数据源代理
@property (nonatomic, weak) id<SYChartLineDataSource> dataSource;
/// line图表代理
@property (nonatomic, weak) id<SYChartLineDelegate> delegate;

/// 最小值，默认为0
@property (nonatomic, strong) id minValue;
/// 最大值，如果未设置计算数据源中的最大值
@property (nonatomic, strong) id maxValue;
/// y轴数据标记个数（默认5个）
@property (nonatomic, assign) NSInteger numberOfYAxis;
/// y轴数据单位
@property (nonatomic, copy) NSString *unitOfYAxis;
/// y轴的颜色
@property (nonatomic, strong) UIColor *colorOfYAxis;
/// y轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfYText;
/// y轴文字大小
@property (nonatomic, assign) CGFloat yFontSize;

/// y轴数据反向排列
@property (nonatomic, assign) BOOL oppositeY;
/// 隐藏y轴
@property (nonatomic, assign) BOOL hideYAxis;

/// x轴的颜色
@property (nonatomic, strong) UIColor *colorOfXAxis;
/// x轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfXText;
/// x轴文本文字大小
@property (nonatomic, assign) CGFloat xFontSize;

/// 数据点是否为实心点
@property (nonatomic, assign) BOOL solidDot;
/// 数据点的半径大小
@property (nonatomic, assign) CGFloat dotRadius;
/// 数据点颜色
@property (nonatomic, strong) UIColor *dotColor;
///// 数据点是否隐藏（默认显示，即YES）
//@property (nonatomic, assign) BOOL showDot;

/// 画线动画时间（默认0.3）
@property (nonatomic, assign) NSTimeInterval animationTime;

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



// 开发中... begin

/// 曲线样式（是否平滑。默认直角）
@property (nonatomic, assign) BOOL isSmoothLines;
/// 曲线类型（虚线，或实线。默认YES，即是实线）
@property (nonatomic, assign) BOOL isSolidLines;


// 开发中... end

/**
 *  刷新数据（默认带动画）
 */
- (void)reloadData;

/**
 *  刷新数据（自定义是否动画）
 *
 *  @param animate 是否动画模式
 */
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
