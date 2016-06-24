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

@end

@implementation SYChartLine

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
    _chartHeight = self.bounds.size.height - SYChart_LINE_CHART_TOP_PADDING - SYChart_LINE_CHART_TEXT_HEIGHT;
    _dotRadius = SYChart_LINE_WIDTH_DEFAULT / 2 * 3;
    
    _minValue = @0;
    
    _unitOfYAxis = @"";
    _numberOfYAxis = 5;
    _colorOfXAxis = _colorOfXText = [UIColor blackColor];
    _colorOfYAxis = _colorOfYText = [UIColor blackColor];
    _yFontSize = 14.0;
    _xFontSize = 14.0;
    
    _oppositeY = NO;
    
    _isSmoothLines = NO;
    
    _animationTime = 0.3;
    
    _gridsType = SYChartGridsTypeNone;
    _gridsLineWidth = 0.5;
    _gridsLineColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    _cachedMaxHeight = kSYChartLineUndefinedCachedHeight;
    _cachedMinHeight = kSYChartLineUndefinedCachedHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SYChart_LINE_CHART_LEFT_PADDING, 0, width - 2 * SYChart_LINE_CHART_TOP_PADDING, CGRectGetHeight(self.bounds))];
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

- (void)drawCoordinateWithContext:(CGContextRef)context
{
    CGFloat width = self.bounds.size.width;
    
    if (!_hideYAxis)
    {
        CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
        CGContextMoveToPoint(context, SYChart_LINE_CHART_LEFT_PADDING - 1, SYChart_LINE_CHART_TOP_PADDING - 1);
        CGContextAddLineToPoint(context, SYChart_LINE_CHART_LEFT_PADDING - 1, SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1);
        CGContextStrokePath(context);
    }
    
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, SYChart_LINE_CHART_LEFT_PADDING - 1, SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextAddLineToPoint(context, width - SYChart_LINE_CHART_RIGHT_PADDING + 1, SYChart_LINE_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
}

#pragma mark - Height

- (CGFloat)normalizedHeightForRawHeight:(NSNumber *)rawHeight
{
    CGFloat value = [rawHeight floatValue];
    CGFloat maxHeight = [self.maxValue floatValue];
    return value/maxHeight * _chartHeight;
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

#pragma mark - Reload Data

- (void)reloadData
{
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate
{
    [self reloadChartDataSource];
    _hideYAxis ? : [self reloadChartYAxis];
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
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    _chartDataSource = [[NSMutableArray alloc] initWithArray:dataArray];
}

- (void)reloadChartYAxis
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    CGFloat chartYOffset = _oppositeY ? SYChart_LINE_CHART_TOP_PADDING : _chartHeight + SYChart_LINE_CHART_TOP_PADDING;
    CGFloat unitHeight = _chartHeight / _numberOfYAxis;
    CGFloat unitValue = ([self.maxValue floatValue] - [_minValue floatValue]) / _numberOfYAxis;
    for (NSInteger i = 0; i <= _numberOfYAxis; i ++)
    {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, chartYOffset - 10, SYChart_LINE_CHART_LEFT_PADDING - 2, 20)];
        textLabel.textColor = _colorOfYText;
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.font = [UIFont systemFontOfSize:_yFontSize];
        textLabel.numberOfLines = 0;
        textLabel.text = [NSString stringWithFormat:@"%.0f%@", unitValue * i + [_minValue floatValue], _unitOfYAxis];
        [self addSubview:textLabel];
        
        chartYOffset += _oppositeY ? unitHeight : -unitHeight;
    }
}

- (void)reloadLineWithAnimate:(BOOL)animate
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
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
            pointLayer.strokeColor = color;
            pointLayer.fillColor = [UIColor whiteColor].CGColor;
        }
        else
        {
            CGColorRef color = [UIColor redColor].CGColor;
            lineLayer.strokeColor = color;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            pointLayer.strokeColor = color;
            pointLayer.fillColor = [UIColor whiteColor].CGColor;
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
        
        CGFloat xOffset = _dotPadding / 2;
        CGFloat chartYOffset = _oppositeY ? SYChart_LINE_CHART_TOP_PADDING : _chartHeight + SYChart_LINE_CHART_TOP_PADDING;
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
                    view.center = CGPointMake(xOffset, yOffset);
                    [_scrollView addSubview:view];
                }
                else
                {
                    [pointBezierPath moveToPoint:CGPointMake(xOffset + _dotRadius, yOffset)];
                    [pointBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
                }
            }
            else
            {
                [pointBezierPath moveToPoint:CGPointMake(xOffset + _dotRadius, yOffset)];
                [pointBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
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
                
                if (_isSmoothLines)
                {
                    [lineBezierPath moveToPoint:fromPoint];
                    
                    CGPoint midPoint = CGPointMake((fromPoint.x + toPoint.x) / 2, (fromPoint.y + toPoint.y) / 2);
                    CGPoint controlPoint = midPoint;
                    CGFloat diffY = abs((int) (toPoint.y - controlPoint.y));
                    if (fromPoint.y < toPoint.y)
                    {
                        controlPoint.y += diffY;
                    }
                    else if (fromPoint.y > toPoint.y)
                    {
                        controlPoint.y -= diffY;
                    }
                    
                    [lineBezierPath addQuadCurveToPoint:midPoint controlPoint:controlPoint];
                    [lineBezierPath addQuadCurveToPoint:toPoint controlPoint:controlPoint];
                }
                else
                {
                    [lineBezierPath moveToPoint:fromPoint];
                    [lineBezierPath addLineToPoint:toPoint];
                    
                    [lineBezierPath moveToPoint:CGPointMake(xOffset - _dotRadius, yOffset)];
                    [lineBezierPath addArcWithCenter:CGPointMake(xOffset, yOffset) radius:_dotRadius startAngle:-M_PI endAngle:M_PI clockwise:YES];
                    [lineBezierPath moveToPoint:CGPointMake(xOffset, yOffset)];
                }
            }
            
//            NSTimeInterval delay = animate ? (array.count + 1) * 0.4 : 0.0;
            NSTimeInterval delay = (animate ? ((array.count + 1) * _animationTime) : 0.0);
            if ([self.delegate respondsToSelector:@selector(lineChartView:hintViewOfDotInLineNumber:index:)])
            {
                UIView *hintView = [self.delegate lineChartView:self hintViewOfDotInLineNumber:lineNumber index:index];
                if (hintView)
                {
                    hintView.center = CGPointMake(xOffset, yOffset - CGRectGetHeight(hintView.bounds) / 2 - _dotRadius);
                    hintView.alpha = 0.0;
                    [_scrollView addSubview:hintView];
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
                    [_scrollView addSubview:informationView];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        informationView.alpha = 1.0;
                    } completion:nil];
                }
            }
            
            if (lineNumber == 0 && [self.delegate respondsToSelector:@selector(lineChartView:titleAtLineNumber:)])
            {
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset - _dotPadding/2 + 4, _chartHeight + SYChart_LINE_CHART_TOP_PADDING, _dotPadding - 8, SYChart_LINE_CHART_TEXT_HEIGHT)];
                textLabel.textColor = _colorOfXText;
                textLabel.numberOfLines = 0;
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.font = [UIFont systemFontOfSize:_xFontSize];
                textLabel.numberOfLines = 0;
                textLabel.text = [self.dataSource lineChartView:self titleAtLineNumber:index];
                [_scrollView addSubview:textLabel];
            }
            
            xOffset += _dotPadding;
        }
        lineLayer.path = lineBezierPath.CGPath;
        pointLayer.path = pointBezierPath.CGPath;
        pointLayer.fillColor = _solidDot ? lineLayer.strokeColor : [UIColor clearColor].CGColor;
        [_scrollView.layer insertSublayer:lineLayer atIndex:(unsigned)lineNumber];
        [_scrollView.layer insertSublayer:pointLayer above:lineLayer];
        
        if (animate)
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @(0.0);
            animation.toValue = @(1.0);
            animation.repeatCount = 1.0;
//            animation.duration = array.count * 0.4;
            animation.duration = array.count * _animationTime;
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = self;
            [lineLayer addAnimation:animation forKey:@"animation"];
        }
    }
}

- (void)drawChartGridsWithContext:(CGContextRef)context
{
    //    CGFloat chartYOffset = ((_oppositeY ? SYChart_LINE_CHART_TOP_PADDING : _chartHeight + SYChart_LINE_CHART_TOP_PADDING) - 20.0 ) / 2;
    //    CGFloat unitHeight = _chartHeight / _numberOfYAxis;
    //    CGFloat unitValue = ([self.maxValue floatValue] - [_minValue floatValue]) / _numberOfYAxis;
    //
    //    for (NSInteger i = 0; i <= _numberOfYAxis; i ++)
    //    {
    //        CGContextSetLineWidth(context, _gridsLineWidth);
    //        CGContextSetStrokeColorWithColor(context, _gridsLineColor.CGColor);
    //        CGContextMoveToPoint(context, SYChart_LINE_CHART_LEFT_PADDING - 1, chartYOffset);
    //        CGContextAddLineToPoint(context, SYChart_LINE_CHART_LEFT_PADDING - 1, chartYOffset);
    //        CGContextStrokePath(context);
    //    }
}

@end
