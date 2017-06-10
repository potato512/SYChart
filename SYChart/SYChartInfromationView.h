//
//  SYChartInfromationView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYChartInfromationView : UIView

/**
 *  实始化方法（设置frame时，高度至少25.0）
 *
 *  @param text 信息
 *
 *  @return 实体 SYChartInfromationView
 */
- (instancetype)initWithText:(NSString *)text;

/// 背景颜色（默认白色）
@property (nonatomic, strong) UIColor *informationViewBackgroundColor;
/// 字体颜色（默认黑色）
@property (nonatomic, strong) UIColor *informationViewTextColor;
/// 字体大小（默认12号）
@property (nonatomic, strong) UIFont *informationViewTextFont;

@end
