# SYChart
图表控件
 * 1 折线图
 * 2 柱状图

# 使用介绍
 * 1 折线图
~~~javascript
// 1 导入头文件
#import "SYChart.h"

// 2 设置协议
SYChartLineDataSource, SYChartLineDelegate

// 3 实例化
SYChartLine *chartLine = [[SYChartLine alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
[self.view addSubview:chartLine];
chartLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
// 数据点设置
chartLine.dotRadius = 5.0;
chartLine.dotColor = [UIColor orangeColor];
chartLine.isSolidDot = NO;
// 代理设置
chartLine.dataSource = self;
chartLine.delegate = self;
// Y坐标轴设置
chartLine.minValue = @0;
chartLine.maxValue = @100;
chartLine.oppositeY = NO;
chartLine.numberOfYAxis = 10;
chartLine.colorOfYAxis = [UIColor orangeColor];
chartLine.colorOfYText = [UIColor purpleColor];
chartLine.yFontSize = 10.0;
chartLine.unitOfYAxis = @"分";
// X坐标轴设置
chartLine.colorOfXAxis = [UIColor redColor];
chartLine.colorOfXText = [UIColor greenColor];
chartLine.xFontSize = 10.0;
// 网格设置
chartLine.gridsLineColor = [UIColor brownColor];
chartLine.gridsType = SYChartGridsTypeGridDotted;
chartLine.gridsLineWidth = 0.5;
// 动画时间设置
chartLine.animationTime = 1.0;
// 曲线样式设置
chartLine.isSolidLines = YES;
chartLine.isSmoothLines = YES;
// 刷新数据
[chartLine reloadDataWithAnimate:YES];

// 4 实现代理方法
// MCLineChartViewDataSource

- (NSUInteger)lineChartView:(SYChartLine *)charLine lineCountAtLineNumber:(NSInteger)lineNumber
{
    // Y垂直坐标曲线点个数
}

- (id)lineChartView:(SYChartLine *)charLine valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // Y垂直坐标信息
}

- (NSUInteger)numberOfLinesInLineChartView:(SYChartLine *)charLine
{
    // 曲线条数
}

- (NSString *)lineChartView:(SYChartLine *)charLine titleAtLineNumber:(NSInteger)index
{
    // x坐标标题
}

// MCLineChartViewDelegate

- (CGFloat)lineChartView:(SYChartLine *)charLine lineWidthWithLineNumber:(NSInteger)lineNumber
{
    // 曲线大小
}

- (CGFloat)dotPaddingInLineChartView:(SYChartLine *)charLine
{
    // 曲线数据点间距（可设置成信息不滚动样式。默认60.0）
}

- (UIColor *)lineChartView:(SYChartLine *)charLine lineColorWithLineNumber:(NSInteger)lineNumber
{
    // 曲线颜色
}

- (NSString *)lineChartView:(SYChartLine *)charLine informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // 曲线点数据信息标题
}

- (UIView *)lineChartView:(SYChartLine *)charLine hintViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // 自定义曲线点顶端信息视图
}

- (UIView *)lineChartView:(SYChartLine *)charLine pointViewOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index
{
    // 自定义曲线点视图
}

~~~

 * 2 柱状图

# 使用效果图
 * 1 折线图

![chartline01](./images/chartline01.png) 
![chartline02](./images/chartline02.png) 

 * 2 柱状图





#### 修改说明
* 20170609 
  * 百度统计示例使用


