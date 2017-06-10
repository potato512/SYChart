//
//  SYChart.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYChart

#import "SYChartLine.h"
#import "SYChartBar.h"
#import "SYChartInfromationView.h"
#import "SYChartLayer.h"
#import "UIView+SYChart.h"

#ifndef SYChart_h
#define SYChart_h

#define SYChart_SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SYChart_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

// 系统
#define SYChartIOS7             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// 颜色
#define SYChartColorRGBA(r,g,b,a)   [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:a]
#define SYChartColorRGB(r,g,b)      SYChartColorRGBA(r,g,b,1.0f)

#define SYChart_colorGrey          SYChartColorRGB(246.0,246.0,246.0)
#define SYChart_colorLightBlue     SYChartColorRGB(94.0,147.0,196.0)
#define SYChart_colorGreen         SYChartColorRGB(77.0,186.0,255.0)
#define SYChart_colorTitleColor    SYChartColorRGB(0.0,189.0,113.0)
#define SYChart_colorButtonGrey    SYChartColorRGB(141.0,141.0,141.0)
#define SYChart_colorLightGreen    SYChartColorRGB(77.0,216.0,122.0)
#define SYChart_colorFreshGreen    SYChartColorRGB(77.0,196.0,122.0)
#define SYChart_colorDeepGreen     SYChartColorRGB(77.0,176.0,122.0)
#define SYChart_colorRed           SYChartColorRGB(245.0,94.0,78.0)
#define SYChart_colorMauve         SYChartColorRGB(88.0,75.0,103.0)
#define SYChart_colorBrown         SYChartColorRGB(119.0,107.0,95.0)
#define SYChart_colorBlue          SYChartColorRGB(82.0,116.0,188.0)
#define SYChart_colorDarkBlue      SYChartColorRGB(121.0,134.0,142.0)
#define SYChart_colorYellow        SYChartColorRGB(242.0,197.0,117.0)
#define SYChart_colorWhite         SYChartColorRGB(255.0,255.0,255.0)
#define SYChart_colorDeepGrey      SYChartColorRGB(99.0,99.0,99.0)
#define SYChart_colorPinkGrey      SYChartColorRGB(200.0,193.0,193.0)
#define SYChart_colorHealYellow    SYChartColorRGB(245.0,242.0,238.0)
#define SYChart_colorLightGrey     SYChartColorRGB(225.0,225.0,225.0)
#define SYChart_colorCleanGrey     SYChartColorRGB(251.0,251.0,251.0)
#define SYChart_colorLightYellow   SYChartColorRGB(241.0,240.0,240.0)
#define SYChart_colorDarkYellow    SYChartColorRGB(152.0,150.0,159.0)
#define SYChart_colorPinkDark      SYChartColorRGB(170.0,165.0,165.0)
#define SYChart_colorCloudWhite    SYChartColorRGB(244.0,244.0,244.0)
#define SYChart_colorBlack         SYChartColorRGB(45.0,45.0,45.0)
#define SYChart_colorStarYellow    SYChartColorRGB(252.0,223.0,101.0)
#define SYChart_colorTwitterColor  SYChartColorRGB(0.0,171.0,243.0)
#define SYChart_colorWeiboColor    SYChartColorRGB(250.0,0.0,33.0)
#define SYChart_coloriOSGreenColor SYChartColorRGB(98.0,247.0,77.0)


// chartLine
#define SYChart_LINE_CHART_TOP_PADDING    30
#define SYChart_LINE_CHART_LEFT_PADDING   40
#define SYChart_LINE_CHART_RIGHT_PADDING  8
#define SYChart_LINE_CHART_TEXT_HEIGHT    40

#define SYChart_LINE_CHART_YTITLELABEL_HEIGHT 20.0

#define SYChart_LINE_WIDTH_DEFAULT 2.0

#define SYChart_DOT_PADDING_DEFAULT 60.0
#define SYChart_DOT_BEGIN_POSTION   20.0

// chartBar
#define SYChart_BAR_CHART_TOP_PADDING 30
#define SYChart_BAR_CHART_LEFT_PADDING 40
#define SYChart_BAR_CHART_RIGHT_PADDING 8
#define SYChart_BAR_CHART_TEXT_HEIGHT 40

#define SYChart_BAR_WIDTH_DEFAULT 20.0

#define SYChart_PADDING_SECTION_DEFAULT 10.0
#define SYChart_PADDING_BAR_DEFAULT 1.0


#endif /* SYChart_h */

/*
 待完善
 line曲线
 1、line线条样式：虚线，或实线——done
 2、dot颜色——done
 3、line显示动画：是，或否——done
 4、line显示动画时间：默认时间，自定义时间——done
 5、网格线样式：网络栅格线实线，或网络栅格虚线，或仅水平虚线，或仅水平实线，或仅垂直虚线，或仅垂直实线——done
 6、网格线颜色——done
 7、网格线大小——done
 8、y轴坐标显示样式：显示刻度——done
 9、数据点点击代理方法——done
 10、数据点信息视图点击代理方法——done
 11、曲线显示动画方式（点、线、信息）：逐个连线动画显示，或已连线从底部向上推出显示
 12、曲线填充颜色
 13、坐标轴标题单位（字体大小，字体颜色、标题）——done
 14、坐标轴标题自适应大小——done
 
 bar柱状
 1、bar边框样式：无，或虚线，或实线
 2、bar显示动画：是，或否-done
 3、bar显示动画时间：默认时间，或自定义时间-done
 4、网格线样式：网络栅格线实线，或网络栅格虚线，或仅水平虚线，或仅水平实线，或仅垂直虚线，或仅垂直实线——done
 5、网格线颜色——done
 6、网格线大小——done
 7、x轴标题对齐异常修改
 8、y轴坐标显示样式：显示刻度——done
 9、数据点点击代理方法——done
 10、数据点信息视图点击代理方法——done
 11、坐标轴标题单位（字体大小，字体颜色、标题）——done
 12、坐标轴标题自适应大小——done
*/



