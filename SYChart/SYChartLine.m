//
//  SYChartLine.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  

#import "SYChartLine.h"
#import "SYChart.h"

CGFloat static const kSYChartLineUndefinedCachedHeight = -1.0f;
static NSInteger const tagTextLabel = 1000;

@interface SYChartLine ()
{
    UIScrollView *_scrollView;
    CGFloat _chartHeight;
}

@property (nonatomic, strong) NSArray *chartDataSource;

@property (nonatomic, assign) NSUInteger lineCount;
@property (nonatomic, assign) CGFloat lineWith;
@property (nonatomic, assign) CGFloat dotPadding;

@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) CGFloat cachedMinHeight;

@property (nonatomic, strong) NSMutableArray *labelArray;

// 刻度递增值
@property (nonatomic, assign, readonly) CGFloat heightYStep;

@end

@implementation SYChartLine

#pragma mark - init

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.bounds.size.width;
    _chartHeight = (self.bounds.size.height - SYChart_LINE_CHART_TOP_PADDING - SYChart_LINE_CHART_TEXT_HEIGHT);
    
    _minValue = @(0);
    _unitOfYAxis = @"";
    _numberOfYAxis = 5;
    _colorOfYAxis = [UIColor blackColor];
    _colorOfYText = [UIColor blackColor];
    _yFontSize = 14.0;
    
    _yUnitFontSize = 12.0;
    _yUnitColor = [UIColor blackColor];
    
    _xUnitFontSize = 12.0;
    _xUnitColor = [UIColor blackColor];

    _colorOfXText = [UIColor blackColor];
    _colorOfXAxis = [UIColor blackColor];
    _xFontSize = 14.0;
    _xFontSizeAuto = NO;
    
    _oppositeY = NO;
    _hideYAxis = NO;
    
    _isSolidDot = YES;
    _dotRadius = (SYChart_LINE_WIDTH_DEFAULT / 2 * 3);
    _dotTitleBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    _dotTitleColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    _dotTitleFont = [UIFont systemFontOfSize:12.0];
    
    _animationTime = 0.3;
    
    _gridsType = SYChartGridsTypeNone;
    _gridsLineWidth = 0.5;
    _gridsLineColor = [UIColor lightGrayColor];
    
    _isSmoothLines = NO;
    _isSolidLines = YES;
    _lineColor = SYChart_colorLightBlue;
    
    _showFillColor = NO;
    _fillColor = [_lineColor colorWithAlphaComponent:0.25];
    
    _cachedMaxHeight = kSYChartLineUndefinedCachedHeight;
    _cachedMinHeight = kSYChartLineUndefinedCachedHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SYChart_LINE_CHART_LEFT_PADDING, 0.0, (width - SYChart_LINE_CHART_LEFT_PADDING - SYChart_LINE_CHART_RIGHT_PADDING), CGRectGetHeight(self.bounds))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.chartDataSource == nil)
    {
        [self reloadData];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateWithContext:context];
    [self drawChartGridsWithContext:context];
}

#pragma mark - Draw Coordinate

// 绘制坐标轴
- (void)drawCoordinateWithContext:(CGContextRef)context
{
    CGFloat width = self.bounds.size.width;
    
    // Y坐标轴
    if (!_hideYAxis)
    {
        CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
        CGContextMoveToPoint(context, (SYChart_LINE_CHART_LEFT_PADDING - 1), (SYChart_LINE_CHART_TOP_PADDING - 1 - 10.0));
        CGContextAddLineToPoint(context, (SYChart_LINE_CHART_LEFT_PADDING - 1), (SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1));
        CGContextStrokePath(context);
        
        // Y坐标轴箭头
        CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
        CGContextMoveToPoint(context, (SYChart_LINE_CHART_LEFT_PADDING - 1 - 3), (SYChart_LINE_CHART_TOP_PADDING - 1 - 10.0 + 3));
        CGContextAddLineToPoint(context, (SYChart_LINE_CHART_LEFT_PADDING - 1), (SYChart_LINE_CHART_TOP_PADDING - 1 - 10.0));
        CGContextAddLineToPoint(context, (SYChart_LINE_CHART_LEFT_PADDING - 1 + 3), (SYChart_LINE_CHART_TOP_PADDING - 1 - 10.0 + 3));
        CGContextStrokePath(context);
        
        // Y坐标轴刻度
        CGPoint point = CGPointZero;
        CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
        for (int i = 0; i < _numberOfYAxis; i++)
        {
            point.x = (SYChart_LINE_CHART_LEFT_PADDING - 1);
            point.y = (i * self.heightYStep + SYChart_LINE_CHART_TOP_PADDING);
            CGContextMoveToPoint(context, point.x, point.y);
            CGContextAddLineToPoint(context, (SYChart_LINE_CHART_LEFT_PADDING - 1 + 3), point.y);
            CGContextStrokePath(context);
        }
    }
    
    // X坐标轴
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, (SYChart_LINE_CHART_LEFT_PADDING - 1), (SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1));
    CGContextAddLineToPoint(context, (width - SYChart_LINE_CHART_RIGHT_PADDING + 1), (SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1));
    CGContextStrokePath(context);
    
    // X坐标轴箭头
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, (width - SYChart_LINE_CHART_RIGHT_PADDING + 1 - 3), (SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1 - 3));
    CGContextAddLineToPoint(context, (width - SYChart_LINE_CHART_RIGHT_PADDING + 1), (SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1));
    CGContextAddLineToPoint(context, (width - SYChart_LINE_CHART_RIGHT_PADDING + 1 - 3), (SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1 + 3));
    CGContextStrokePath(context);
    
    // X坐标轴刻度 在数据刷新方法" - (void)reloadDataWithAnimate:(BOOL)animate "中处理
}

// 绘制网络（注意：只绘制水平线，垂直线在数据刷新方法" - (void)reloadDataWithAnimate:(BOOL)animate "中处理）
- (void)drawChartGridsWithContext:(CGContextRef)context
{
    CGPoint point;
    
    if (SYChartGridsTypeGridDotted == _gridsType || SYChartGridsTypeGridSolid == _gridsType || SYChartGridsTypeHorizontalDotted == _gridsType || SYChartGridsTypeHorizontalSolid == _gridsType)
    {
        CGContextSetStrokeColorWithColor(context, _gridsLineColor.CGColor);
        
        for (NSUInteger i = 0; i < _numberOfYAxis; i++)
        {
            point.x = (SYChart_LINE_CHART_LEFT_PADDING - 1);
            point.y = (i * self.heightYStep + SYChart_LINE_CHART_TOP_PADDING);
            
            CGContextMoveToPoint(context, point.x, point.y);
            CGContextSetLineWidth(context, _gridsLineWidth);
            if (SYChartGridsTypeGridDotted == _gridsType || SYChartGridsTypeHorizontalDotted == _gridsType)
            {
                // 虚线类型
                CGContextSetLineCap(context, kCGLineCapRound);
                CGFloat dash[] = {6, 5};
                CGContextSetLineDash(context, 0.0, dash, 2);
            }
            CGContextAddLineToPoint(context, (CGRectGetWidth(self.bounds) - SYChart_LINE_CHART_RIGHT_PADDING + 1), point.y);
            CGContextStrokePath(context);
        }
    }
}

#pragma mark - Height/getter

- (CGFloat)normalizedHeightForRawHeight:(NSNumber *)rawHeight
{
    CGFloat value = [rawHeight floatValue];
    CGFloat maxHeight = [self.maxValue floatValue];
    CGFloat height = (value / maxHeight * _chartHeight);
    return height;
}

- (id)maxValue
{
    if (_maxValue == nil)
    {
        if ([self cachedMaxHeight] != kSYChartLineUndefinedCachedHeight)
        {
            _maxValue = @([self cachedMaxHeight]);
        }
    }
    return _maxValue;
}

- (CGFloat)cachedMinHeight
{
    if(_cachedMinHeight == kSYChartLineUndefinedCachedHeight)
    {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        _cachedMinHeight = 0;
        for (NSArray *array in chartValues)
        {
            for (NSNumber *number in array)
            {
                CGFloat height = [number floatValue];
                if (height < _cachedMinHeight)
                {
                    _cachedMinHeight = height;
                }
            }
        }
    }
    return _cachedMinHeight;
}

- (CGFloat)cachedMaxHeight
{
    if (_cachedMaxHeight == kSYChartLineUndefinedCachedHeight)
    {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        _cachedMaxHeight = 0;
        for (NSArray *array in chartValues)
        {
            for (NSNumber *number in array)
            {
                CGFloat height = [number floatValue];
                if (height > _cachedMaxHeight)
                {
                    _cachedMaxHeight = height;
                }
            }
        }
    }
    return _cachedMaxHeight;
}

- (CGFloat)heightYStep
{
    CGFloat height = (_chartHeight / _numberOfYAxis);
    return height;
}

#pragma mark - Reload Data

- (void)reloadData
{
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate
{
    [self reloadChartDataSource];
    [self reloadChartYAxis];
    [self reloadChartUnit];
    [self reloadLineWithAnimate:animate];
}

- (void)reloadChartDataSource
{
    _cachedMaxHeight = kSYChartLineUndefinedCachedHeight;
    _cachedMinHeight = kSYChartLineUndefinedCachedHeight;
    
    _lineCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfLinesInLineChartView:)])
    {
        _lineCount = [self.dataSource numberOfLinesInLineChartView:self];
    }
    
    NSAssert([self.dataSource respondsToSelector:@selector(lineChartView:lineCountAtLineNumber:)], @"BarChartView // delegate must implement lineChartView:lineCountAtLineNumber:");
    
    _dotPadding = SYChart_DOT_PADDING_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(dotPaddingInLineChartView:)])
    {
        _dotPadding = [self.delegate dotPaddingInLineChartView:self];
    }
    
    NSAssert(([self.dataSource respondsToSelector:@selector(lineChartView:valueAtLineNumber:index:)]), @"MCBarChartView // delegate must implement - (CGFloat)barChartView:(MCBarChartView *)barChartView valueOfBarsInSection:(NSUInteger)section index:(NSUInteger)index");
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:_lineCount];
    CGFloat maxContentWith = 0.0;
    CGFloat contentWidth = 0.0;
    for (NSUInteger i = 0; i < _lineCount; i ++)
    {
        NSUInteger lineCount = [self.dataSource lineChartView:self lineCountAtLineNumber:i];
        
        contentWidth = lineCount * _dotPadding;
        maxContentWith = MAX(maxContentWith, contentWidth);
        
        NSMutableArray *barArray = [NSMutableArray arrayWithCapacity:lineCount];
        for (NSInteger j = 0; j < lineCount; j ++)
        {
            id value = [self.dataSource lineChartView:self valueAtLineNumber:i index:j];
            [barArray addObject:value];
        }
        [dataArray addObject:barArray];
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, 0.0);
    _chartDataSource = [[NSMutableArray alloc] initWithArray:dataArray];
}

- (void)reloadChartUnit
{
    // 刻度单位
    if (self.yUnitText && 0 != [self.yUnitText length])
    {
        CGFloat width = [self.yUnitText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.yUnitFontSize]}].width;
        width = (width >= (SYChart_LINE_CHART_LEFT_PADDING - 2) ? (width + SYChart_LINE_CHART_YTITLELABEL_HEIGHT / 2) : (SYChart_LINE_CHART_LEFT_PADDING - 2));
        CGRect drawRect = CGRectMake(0.0, 0.0, width, SYChart_LINE_CHART_YTITLELABEL_HEIGHT);
        UILabel *label = [[UILabel alloc] initWithFrame:drawRect];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = self.yUnitColor;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:self.yUnitFontSize];
        label.text = self.yUnitText;
        
        [self addSubview:label];
    }
    
    if (self.xUnitText && 0 != [self.xUnitText length])
    {
        CGFloat width = [self.xUnitText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.xUnitFontSize]}].width;
        width = (width >= (SYChart_LINE_CHART_LEFT_PADDING - 2) ? (width + SYChart_LINE_CHART_YTITLELABEL_HEIGHT / 2) : (SYChart_LINE_CHART_LEFT_PADDING - 2));
        CGRect drawRect = CGRectMake((CGRectGetWidth(self.bounds) - width), (CGRectGetHeight(self.bounds) - (SYChart_LINE_CHART_LEFT_PADDING - 2)), width, SYChart_LINE_CHART_YTITLELABEL_HEIGHT);
        UILabel *label = [[UILabel alloc] initWithFrame:drawRect];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = self.xUnitColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:self.xUnitFontSize];
        label.text = self.xUnitText;
        
        [self addSubview:label];
    }
}

- (void)reloadChartYAxis
{
    // Y刻度
    if (!_hideYAxis)
    {
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UILabel class]])
            {
                [view removeFromSuperview];
            }
        }
        
        CGFloat chartYOffset = (_oppositeY ? SYChart_LINE_CHART_TOP_PADDING : (_chartHeight + SYChart_LINE_CHART_TOP_PADDING));
        CGFloat unitHeight = (_chartHeight / _numberOfYAxis);
        CGFloat unitValue = ([self.maxValue floatValue] - [_minValue floatValue]) / _numberOfYAxis;
        for (NSInteger i = 0; i <= _numberOfYAxis; i ++)
        {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (chartYOffset - SYChart_LINE_CHART_YTITLELABEL_HEIGHT / 2), (SYChart_LINE_CHART_LEFT_PADDING - 2), SYChart_LINE_CHART_YTITLELABEL_HEIGHT)];
            textLabel.textColor = _colorOfYText;
            textLabel.textAlignment = NSTextAlignmentRight;
            textLabel.font = [UIFont systemFontOfSize:_yFontSize];
            textLabel.numberOfLines = 0;
            textLabel.text = [NSString stringWithFormat:@"%.0f%@", (unitValue * i + [_minValue floatValue]), _unitOfYAxis];
            [self addSubview:textLabel];
            
            chartYOffset += (_oppositeY ? unitHeight : -unitHeight);
        }
    }
}

- (void)reloadLineWithAnimate:(BOOL)animate
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self.labelArray removeAllObjects];
    
    for (NSInteger lineNumber = 0; lineNumber < _lineCount; lineNumber ++)
    {
        NSArray *array = _chartDataSource[lineNumber];
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
        CAShapeLayer *pointLayer = [[CAShapeLayer alloc] init];
        
        if ([self.delegate respondsToSelector:@selector(lineChartView:lineColorWithLineNumber:)])
        {
            CGColorRef color = [self.delegate lineChartView:self lineColorWithLineNumber:lineNumber].CGColor;
            lineLayer.strokeColor = color;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            pointLayer.strokeColor = (_dotColor ? _dotColor.CGColor : color);
            pointLayer.fillColor = (_dotColor ? _dotColor.CGColor : color);
        }
        else
        {
            CGColorRef color = _lineColor.CGColor;
            lineLayer.strokeColor = color;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            pointLayer.strokeColor = (_dotColor ? _dotColor.CGColor : color);
            pointLayer.fillColor = (_dotColor ? _dotColor.CGColor : color);
        }
        
        if ([self.delegate respondsToSelector:@selector(lineChartView:lineWidthWithLineNumber:)])
        {
            lineLayer.lineWidth = [self.delegate lineChartView:self lineWidthWithLineNumber:lineNumber];
            pointLayer.lineWidth = [self.delegate lineChartView:self lineWidthWithLineNumber:lineNumber];
        }
        else
        {
            lineLayer.lineWidth = SYChart_LINE_WIDTH_DEFAULT;
            pointLayer.lineWidth = SYChart_LINE_WIDTH_DEFAULT;
        }
        
        CGFloat xOffset = (_dotPadding / 2);
        CGFloat chartYOffset = (_oppositeY ? SYChart_LINE_CHART_TOP_PADDING : (_chartHeight + SYChart_LINE_CHART_TOP_PADDING));
        UIBezierPath *lineBezierPath = [UIBezierPath bezierPath];
        UIBezierPath *pointBezierPath = [UIBezierPath bezierPath];
        for (NSInteger index = 0; index < array.count; index ++)
        {
            CGFloat normalizedHeight = [self normalizedHeightForRawHeight:array[index]];
            CGFloat yOffset = chartYOffset + (_oppositeY ? normalizedHeight : -normalizedHeight);
            if ([self.delegate respondsToSelector:@selector(lineChartView:pointViewOfDotInLineNumber:index:)])
            {
                UIView *view = [self.delegate lineChartView:self pointViewOfDotInLineNumber:lineNumber index:index];
                if (view)
                {
                    // 重置_dotRadius大小
                    CGFloat height = CGRectGetHeight(view.bounds) / 2;
                    _dotRadius = height - (1.5 < height ? 1.0 : 0.0);
                    
                    view.center = CGPointMake(xOffset, yOffset);
                    [_scrollView addSubview:view];
                    // 点击事件
                    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pointTapClick:)];
                    view.userInteractionEnabled = YES;
                    view.indexPath = [NSIndexPath indexPathForRow:index inSection:lineNumber];
                    [view addGestureRecognizer:tapRecognizer];
                }
                else
                {
                    [pointBezierPath moveToPoint:CGPointMake((xOffset + _dotRadius), yOffset)];
                    [pointBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
                    
                    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _dotRadius, _dotRadius)];
                    pointView.backgroundColor = [UIColor clearColor];
                    pointView.center = CGPointMake(xOffset, yOffset);
                    [_scrollView addSubview:pointView];
                    // 点击事件
                    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pointTapClick:)];
                    pointView.userInteractionEnabled = YES;
                    pointView.indexPath = [NSIndexPath indexPathForRow:index inSection:lineNumber];
                    [pointView addGestureRecognizer:tapRecognizer];
                }
            }
            else
            {
                [pointBezierPath moveToPoint:CGPointMake(xOffset + _dotRadius, yOffset)];
                [pointBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
            }
            
            if (index == 0)
            {
                [lineBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:-M_PI endAngle:M_PI clockwise:YES];
                [lineBezierPath moveToPoint:CGPointMake(xOffset, yOffset)];
            }
            else
            {
                CGPoint currentPoint = lineBezierPath.currentPoint;
                CGFloat distance = sqrt((xOffset - currentPoint.x) * (xOffset - currentPoint.x) + (yOffset - currentPoint.y) * (yOffset - currentPoint.y));
                CGFloat xDistance = (xOffset - currentPoint.x) * _dotRadius / distance;
                CGFloat yDistance = (yOffset - currentPoint.y) * _dotRadius / distance;
                CGPoint fromPoint = CGPointMake(currentPoint.x + xDistance, currentPoint.y + yDistance);
                CGPoint toPoint = CGPointMake(xOffset - xDistance, yOffset - yDistance);
                
                if (_isSmoothLines && 4 <= array.count)
                {
                    // 平滑的线
                    lineBezierPath.lineCapStyle = kCGLineCapRound;  // 线条拐角
                    lineBezierPath.lineJoinStyle = kCGLineCapRound; // 终点处理
                    
                    CGPoint pointBegin = fromPoint;
                    CGPoint pointEnd = toPoint;
                    CGPoint pointMiddle = [[self class] middlePoint:pointBegin point:pointEnd];
                    [lineBezierPath moveToPoint:pointBegin];
                    [lineBezierPath addQuadCurveToPoint:pointMiddle
                                           controlPoint:[[self class] controlPoint:pointMiddle point:pointBegin]];
                    [lineBezierPath addQuadCurveToPoint:pointEnd
                                           controlPoint:[[self class] controlPoint:pointMiddle point:pointEnd]];
                }
                else
                {
                    [lineBezierPath moveToPoint:fromPoint];
                    [lineBezierPath addLineToPoint:toPoint];
                }
                
                [lineBezierPath moveToPoint:CGPointMake(xOffset - _dotRadius, yOffset)];
                [lineBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:-M_PI endAngle:M_PI clockwise:YES];
                [lineBezierPath moveToPoint:CGPointMake(xOffset, yOffset)];
            }
            
            NSTimeInterval delay = (animate ? ((array.count + 1) * _animationTime) : 0.0);
            if ([self.delegate respondsToSelector:@selector(lineChartView:hintViewOfDotInLineNumber:index:)])
            {
                UIView *hintView = [self.delegate lineChartView:self hintViewOfDotInLineNumber:lineNumber index:index];
                if (hintView)
                {
                    hintView.center = CGPointMake(xOffset, yOffset - CGRectGetHeight(hintView.bounds) / 2 - _dotRadius);
                    hintView.alpha = 0.0;
                    [_scrollView addSubview:hintView];
                    // 点击事件
                    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotTapClick:)];
                    hintView.userInteractionEnabled = YES;
                    hintView.indexPath = [NSIndexPath indexPathForRow:index inSection:lineNumber];
                    [hintView addGestureRecognizer:tapRecognizer];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        hintView.alpha = 1.0;
                    } completion:nil];
                }
            }
            else if ([self.delegate respondsToSelector:@selector(lineChartView:informationOfDotInLineNumber:index:)])
            {
                NSString *information = [self.delegate lineChartView:self informationOfDotInLineNumber:lineNumber index:index];
                if (information)
                {
                    SYChartInfromationView *informationView = [[SYChartInfromationView alloc] initWithText:information];
                    informationView.center = CGPointMake(xOffset, yOffset - CGRectGetHeight(informationView.bounds) / 2 - _dotRadius);
                    informationView.alpha = 0.0;
                    informationView.informationViewBackgroundColor = _dotTitleBackgroundColor;
                    informationView.informationViewTextColor = _dotTitleColor;
                    informationView.informationViewTextFont = _dotTitleFont;
                    [_scrollView addSubview:informationView];
                    // 点击事件
                    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotTapClick:)];
                    informationView.userInteractionEnabled = YES;
                    informationView.indexPath = [NSIndexPath indexPathForRow:index inSection:lineNumber];
                    [informationView addGestureRecognizer:tapRecognizer];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        informationView.alpha = 1.0;
                    } completion:nil];
                }
            }
            
            if (lineNumber == 0 && [self.delegate respondsToSelector:@selector(lineChartView:titleAtLineNumber:)])
            {
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((xOffset - _dotPadding / 2 + 4), (_chartHeight + SYChart_LINE_CHART_TOP_PADDING), (_dotPadding - 8), SYChart_LINE_CHART_TEXT_HEIGHT)];
                textLabel.textColor = _colorOfXText;
                textLabel.numberOfLines = 0;
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.font = [UIFont systemFontOfSize:_xFontSize];
                textLabel.numberOfLines = 0;
                textLabel.text = [self.dataSource lineChartView:self titleAtLineNumber:index];
                textLabel.backgroundColor = [UIColor clearColor];
                textLabel.tag = (index + tagTextLabel);
                if (_xFontSizeAuto)
                {
                    textLabel.numberOfLines = 1;
                    textLabel.adjustsFontSizeToFitWidth = YES;
                }
                
                [_scrollView addSubview:textLabel];
                [self.labelArray addObject:textLabel];
            }
            
            if (0 == lineNumber)
            {
                // X坐标轴刻度
                UILabel *textLabel = (UILabel *)[_scrollView viewWithTag:(index + tagTextLabel)];
                
                UIBezierPath *xScaleBezierPath = [UIBezierPath bezierPath];
                [xScaleBezierPath moveToPoint:CGPointMake((textLabel.frame.origin.x + CGRectGetWidth(textLabel.frame) / 2), (_chartHeight + SYChart_LINE_CHART_TOP_PADDING + 1))];
                [xScaleBezierPath addLineToPoint:CGPointMake((textLabel.frame.origin.x + CGRectGetWidth(textLabel.frame) / 2), (_chartHeight + SYChart_LINE_CHART_TOP_PADDING) + 1 - 3)];
                
                CAShapeLayer *xScaleLayer = [[CAShapeLayer alloc] init];
                xScaleLayer.path = xScaleBezierPath.CGPath;
                xScaleLayer.strokeColor = _colorOfXAxis.CGColor;
                xScaleLayer.fillColor = _colorOfXAxis.CGColor;
                
                [_scrollView.layer addSublayer:xScaleLayer];
                
                if (SYChartGridsTypeGridDotted == _gridsType || SYChartGridsTypeGridSolid == _gridsType || SYChartGridsTypeVerticalDotted == _gridsType || SYChartGridsTypeVerticalSolid == _gridsType)
                {
                    UIBezierPath *gridsVerticalBezierPath = [UIBezierPath bezierPath];
                    [gridsVerticalBezierPath moveToPoint:CGPointMake((textLabel.frame.origin.x + CGRectGetWidth(textLabel.frame) / 2), (_chartHeight + SYChart_LINE_CHART_TOP_PADDING + 1 - 3))];
                    [gridsVerticalBezierPath addLineToPoint:CGPointMake((textLabel.frame.origin.x + CGRectGetWidth(textLabel.frame) / 2), (SYChart_LINE_CHART_TOP_PADDING))];
                    
                    CAShapeLayer *gridsVerticalLayer = [[CAShapeLayer alloc] init];
                    gridsVerticalLayer.strokeColor = _gridsLineColor.CGColor;
                    gridsVerticalLayer.fillColor = _gridsLineColor.CGColor;
                    gridsVerticalLayer.lineWidth = _gridsLineWidth;
                    if (SYChartGridsTypeGridDotted == _gridsType || SYChartGridsTypeVerticalDotted == _gridsType)
                    {
                        // 虚线类型
                        CGFloat dash[] = {6, 5};
                        [gridsVerticalBezierPath setLineDash:dash count:2 phase:0];
                        
                        gridsVerticalLayer.lineJoin = kCALineJoinRound;
                        gridsVerticalLayer.lineCap = kCALineCapRound;
                        gridsVerticalLayer.lineDashPattern = @[@(6), @(5)];
                    }
                    gridsVerticalLayer.path = gridsVerticalBezierPath.CGPath;
                    
                    [_scrollView.layer addSublayer:gridsVerticalLayer];
                }
            }
            
            xOffset += _dotPadding;
        }
        
        if (!_isSolidLines)
        {
            // 虚线类型
            lineLayer.lineJoin = kCALineJoinRound;
            lineLayer.lineCap = kCALineCapRound;
            lineLayer.lineDashPattern = @[@(6), @(5)];
        }
        lineLayer.path = lineBezierPath.CGPath;
        pointLayer.path = pointBezierPath.CGPath;
        CGColorRef pointFillColor = (_isSolidDot ? (_dotColor ? _dotColor.CGColor : lineLayer.strokeColor) : [UIColor clearColor].CGColor);
        pointLayer.fillColor = pointFillColor;
        
        [_scrollView.layer insertSublayer:lineLayer atIndex:(unsigned)lineNumber];
        [_scrollView.layer insertSublayer:pointLayer above:lineLayer];
        
        if (animate)
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @(0.0);
            animation.toValue = @(1.0);
            animation.repeatCount = 1.0;
            animation.duration = array.count * _animationTime;
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = (id)self;
            [lineLayer addAnimation:animation forKey:@"animation"];
        }
        
        if (_showFillColor)
        {
            CGFloat minBound = self.cachedMinHeight;
            CGFloat maxBound = self.cachedMaxHeight;
            CGFloat spread = maxBound - minBound;
            CGFloat scale = 0;
            
            if (spread != 0)
            {
                scale = _chartHeight / spread;
            }
            
            UIBezierPath *noFill = [self getLinePath:0 withSmoothing:_isSmoothLines close:YES];
            UIBezierPath *fill = [self getLinePath:scale withSmoothing:_isSmoothLines close:YES];
            
            UILabel *labelFirst = self.labelArray.firstObject;
            UILabel *labelLast = self.labelArray.lastObject;
            CGFloat width = labelLast.frame.origin.x + labelLast.frame.size.width / 2 - (labelFirst.frame.origin.x - labelFirst.frame.size.width / 2);
            
            CAShapeLayer *fillLayer = [CAShapeLayer layer];
            fillLayer.frame = CGRectMake(_scrollView.bounds.origin.x, SYChart_LINE_CHART_TOP_PADDING + 100.0, width, _chartHeight);
//            fillLayer.bounds = _scrollView.bounds;
            fillLayer.path = fill.CGPath;
            fillLayer.strokeColor = nil;
            fillLayer.fillColor = _fillColor.CGColor;
            fillLayer.lineWidth = 0;
            fillLayer.lineJoin = kCALineJoinRound;
            
            [_scrollView.layer addSublayer:fillLayer];
            
            
            if (animate)
            {
//                CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//                pathAnimation.duration = array.count * _animationTime;
//                pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                pathAnimation.fromValue = (__bridge id)(noPath.CGPath);
//                pathAnimation.toValue = (__bridge id)(path.CGPath);
//                [pathLayer addAnimation:pathAnimation forKey:@"path"];
                
                CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
                fillAnimation.duration = array.count * _animationTime;
                fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                fillAnimation.fillMode = kCAFillModeForwards;
                fillAnimation.fromValue = (id)noFill.CGPath;
                fillAnimation.toValue = (id)fill.CGPath;
                [fillLayer addAnimation:fillAnimation forKey:@"path"];
            }
        }
    }
}


+ (CGPoint)middlePoint:(CGPoint)pointBegin point:(CGPoint)pointEnd
{
    CGPoint point = CGPointMake((pointBegin.x + pointEnd.x) / 2, (pointBegin.y + pointEnd.y) / 2);
    return point;
}

+ (CGPoint)controlPoint:(CGPoint)pointBegin point:(CGPoint)pointEnd
{
    CGPoint point = [self middlePoint:pointBegin point:pointEnd];
    CGFloat diffY = abs((int)(pointEnd.y - point.y));
    if (pointBegin.y < pointEnd.y)
    {
        point.y += diffY;
    }
    else if (pointBegin.y > pointEnd.y)
    {
        point.y -= diffY;
    }
    
    return point;
}

- (CGPoint)getPointForIndex:(NSUInteger)idx withScale:(CGFloat)scale
{
    if (idx >= _chartDataSource.count)
    {
        return CGPointZero;
    }
    
    // Compute the point position in the view from the data with a set scale value
    NSNumber *number = _chartDataSource[idx];
    number = [NSNumber numberWithInt:arc4random() % 50];
    
    if (_chartDataSource.count < 2)
    {
        return CGPointMake(30.0, self.heightYStep + 30.0 - [number floatValue] * scale);
    }
    else
    {
        return CGPointMake(30.0 + idx * (50.0 / (_chartDataSource.count - 1)), self.heightYStep + 30.0 - [number floatValue] * scale);
    }
}

- (UIBezierPath *)getLinePath:(float)scale withSmoothing:(BOOL)smoothed close:(BOOL)closed
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (smoothed)
    {
        for (int i = 0; i < _chartDataSource.count - 1; i++)
        {
            CGPoint controlPoint[2];
            CGPoint p = [self getPointForIndex:i withScale:scale];
            
            // Start the path drawing
            if (i == 0)
            {
                [path moveToPoint:p];
            }
            
            CGPoint nextPoint, previousPoint, m;
            
            // First control point
            nextPoint = [self getPointForIndex:i + 1 withScale:scale];
            previousPoint = [self getPointForIndex:i - 1 withScale:scale];
            m = CGPointZero;
            
            if (i > 0)
            {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            }
            else
            {
                m.x = (nextPoint.x - p.x) / 2;
                m.y = (nextPoint.y - p.y) / 2;
            }
            
            controlPoint[0].x = p.x + m.x * 0.2;
            controlPoint[0].y = p.y + m.y * 0.2;
            
            // Second control point
            nextPoint = [self getPointForIndex:i + 2 withScale:scale];
            previousPoint = [self getPointForIndex:i withScale:scale];
            p = [self getPointForIndex:i + 1 withScale:scale];
            m = CGPointZero;
            
            if(i < _chartDataSource.count - 2)
            {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            }
            else
            {
                m.x = (p.x - previousPoint.x) / 2;
                m.y = (p.y - previousPoint.y) / 2;
            }
            
            controlPoint[1].x = p.x - m.x * 0.2;
            controlPoint[1].y = p.y - m.y * 0.2;
            
            [path addCurveToPoint:p controlPoint1:controlPoint[0] controlPoint2:controlPoint[1]];
        }
    }
    else
    {
        for (int i = 0; i < _chartDataSource.count; i++)
        {
            if (i > 0)
            {
                [path addLineToPoint:[self getPointForIndex:i withScale:scale]];
            }
            else
            {
                [path moveToPoint:[self getPointForIndex:i withScale:scale]];
            }
        }
    }
    
    if (closed)
    {
        // Closing the path for the fill drawing
        [path addLineToPoint:[self getPointForIndex:_chartDataSource.count - 1 withScale:scale]];
        [path addLineToPoint:[self getPointForIndex:_chartDataSource.count - 1 withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 withScale:scale]];
    }
    
    return path;
}

#pragma mark - 响应事件

- (void)pointTapClick:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lineChartView:didSelectedPointViewOfDotInLineNumber:index:)])
    {
        UIView *view = recognizer.view;
        NSIndexPath *indexPath = view.indexPath;
        NSInteger number = indexPath.section;
        NSInteger index = indexPath.row;
        [self.delegate lineChartView:self didSelectedPointViewOfDotInLineNumber:number index:index];
    }
}

- (void)dotTapClick:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lineChartView:didSelectedOfDotInLineNumber:index:)])
    {
        UIView *view = recognizer.view;
        NSIndexPath *indexPath = view.indexPath;
        NSInteger number = indexPath.section;
        NSInteger index = indexPath.row;
        [self.delegate lineChartView:self didSelectedOfDotInLineNumber:number index:index];
    }
}

#pragma mark - getter

- (CGFloat)widthInfoView
{
    CGFloat width = CGRectGetWidth(self.bounds) - SYChart_LINE_CHART_LEFT_PADDING - SYChart_LINE_CHART_RIGHT_PADDING;
    return width;
}

- (NSMutableArray *)labelArray
{
    if (!_labelArray)
    {
        _labelArray = [[NSMutableArray alloc] init];
    }
    
    return _labelArray;
}

@end
