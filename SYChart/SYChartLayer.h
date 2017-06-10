//
//  SYChartLayer.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SYChartLayer : CALayer

/// 中心点
@property (nonatomic, assign) CGPoint centerPoint;
/// 半径范围
@property (nonatomic, strong) NSArray *radius;

/// 雷达填充颜色
@property (nonatomic, assign) CGColorRef radarFillColor;
/// 雷达半径
@property (nonatomic, assign) CGFloat pointRadius;

/// 线条大小
@property (nonatomic, assign) CGFloat lineWidth;
/// 线条填充颜色
@property (nonatomic, assign) CGColorRef fillColor;
/// 描述颜色
@property (nonatomic, assign) CGColorRef strokeColor;

/// 进度（0.0 ~ 1.0）
@property (nonatomic, assign) CGFloat progress;

/**
 *  刷新
 *
 *  @param animate 是否动画模式
 */
- (void)reloadRadiusWithAnimate:(BOOL)animate;

/**
 *  刷新
 *
 *  @param animate  是否动画模式
 *  @param duration 动态持续时间
 */
- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration;

@end
