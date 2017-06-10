//
//  SYChartHelper.h
//  DemoChart
//
//  Created by zhangshaoyu on 16/6/24.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 网格显示类型（网络栅格虚线、网络栅格实线、水平虚线、水平实线、垂直虚线、垂直实线、默认不显示）
typedef NS_ENUM(NSInteger, SYChartGridsType)
{
    /// 网格显示类型-默认不显示）
    SYChartGridsTypeNone = 0,
    
    /// 网格显示类型-网络栅格虚线
    SYChartGridsTypeGridDotted = 1,
    
    /// 网格显示类型-网络栅格实线
    SYChartGridsTypeGridSolid = 2,
    
    /// 网格显示类型-水平虚线
    SYChartGridsTypeHorizontalDotted = 3,
    
    /// 网格显示类型-水平实线
    SYChartGridsTypeHorizontalSolid = 4,
    
    /// 网格显示类型-垂直虚线
    SYChartGridsTypeVerticalDotted = 5,
    
    /// 网格显示类型-垂直实线
    SYChartGridsTypeVerticalSolid = 6
};

@interface SYChartHelper : NSObject

@end
