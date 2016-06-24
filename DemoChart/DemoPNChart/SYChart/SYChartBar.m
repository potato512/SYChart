//
//  SYChartBar.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYChartBar.h"
#import "SYChart.h"

CGFloat static const kSYChartBarUndefinedCachedHeight = -1.0f;

@interface SYChartBar ()
{
    UIColor *_chartBackgroundColor;
    UIScrollView *_scrollView;
    
    CGFloat _chartHeight;
}

@property (nonatomic, strong) NSArray *chartDataSource;

@property (nonatomic, assign) NSUInteger sections;
@property (nonatomic, assign) CGFloat paddingSection;
@property (nonatomic, assign) CGFloat paddingBar;
@property (nonatomic, assign) CGFloat barWidth;

@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) CGFloat cachedMinHeight;

@end

@implementation SYChartBar

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
    _chartHeight = self.bounds.size.height - SYChart_BAR_CHART_TOP_PADDING - SYChart_BAR_CHART_TEXT_HEIGHT;
    
    _unitOfYAxis = @"";
    _numberOfYAxis = 5;
    _cachedMaxHeight = kSYChartBarUndefinedCachedHeight;
    _cachedMinHeight = kSYChartBarUndefinedCachedHeight;
    
    _yFontSize = 14.0;
    _xFontSize = 14.0;
    
    _animationTime = 0.6;
    
    _gridsType = SYChartGridsTypeNone;
    _gridsLineWidth = 0.5;
    _gridsLineColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SYChart_BAR_CHART_LEFT_PADDING, 0, width - SYChart_BAR_CHART_RIGHT_PADDING - SYChart_BAR_CHART_LEFT_PADDING, CGRectGetHeight(self.bounds))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
}

#pragma mark - Draw Coordinate

- (void)drawCoordinateWithContext:(CGContextRef)context
{
    CGFloat width = self.bounds.size.width;
    
    CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
    CGContextMoveToPoint(context, SYChart_BAR_CHART_LEFT_PADDING - 1, SYChart_BAR_CHART_TOP_PADDING - 1);
    CGContextAddLineToPoint(context, SYChart_BAR_CHART_LEFT_PADDING - 1, SYChart_BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, SYChart_BAR_CHART_LEFT_PADDING - 1, SYChart_BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextAddLineToPoint(context, width - SYChart_BAR_CHART_RIGHT_PADDING + 1, SYChart_BAR_CHART_TOP_PADDING + _chartHeight + 1);
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
        if ([self cachedMaxHeight] != kSYChartBarUndefinedCachedHeight)
        {
            _maxValue = @([self cachedMaxHeight]);
        }
    }
    return _maxValue;
}

- (CGFloat)cachedMinHeight
{
    if(_cachedMinHeight == kSYChartBarUndefinedCachedHeight)
    {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
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
    if (_cachedMaxHeight == kSYChartBarUndefinedCachedHeight)
    {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
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
    [self reloadChartYAxis];
    [self reloadBarWithAnimate:animate];
}

- (void)reloadChartDataSource
{
    _cachedMaxHeight = kSYChartBarUndefinedCachedHeight;
    _cachedMinHeight = kSYChartBarUndefinedCachedHeight;
    
    _sections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInBarChartView:)])
    {
        _sections = [self.dataSource numberOfSectionsInBarChartView:self];
    }
    
    NSAssert([self.dataSource respondsToSelector:@selector(barChartView:numberOfBarsInSection:)], @"BarChartView // delegate must implement barChartView:numberOfBarsInSection:");
    
    _paddingSection = SYChart_PADDING_SECTION_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(paddingForSectionInBarChartView:)])
    {
        _paddingSection = [self.delegate paddingForSectionInBarChartView:self];
    }
    _paddingBar = SYChart_PADDING_BAR_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(paddingForBarInBarChartView:)])
    {
        _paddingBar = [self.delegate paddingForBarInBarChartView:self];
    }
    _barWidth = SYChart_BAR_WIDTH_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(barWidthInBarChartView:)])
    {
        _barWidth = [self.delegate barWidthInBarChartView:self];
    }
    
    NSAssert(([self.dataSource respondsToSelector:@selector(barChartView:valueOfBarInSection:index:)]), @"MCBarChartView // delegate must implement - (CGFloat)barChartView:(MCBarChartView *)barChartView valueOfBarsInSection:(NSUInteger)section index:(NSUInteger)index");
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:_sections];
    CGFloat contentWidth = _paddingSection;
    for (NSUInteger i = 0; i < _sections; i ++)
    {
        NSUInteger barCount = [self.dataSource barChartView:self numberOfBarsInSection:i];
        
        contentWidth += barCount * _barWidth + (barCount - 1) * _paddingBar;
        contentWidth += _paddingSection;
        
        NSMutableArray *barArray = [NSMutableArray arrayWithCapacity:barCount];
        for (NSInteger j = 0; j < barCount; j ++)
        {
            id value = [self.dataSource barChartView:self valueOfBarInSection:i index:j];
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
    
    CGFloat chartYOffset = _chartHeight + SYChart_BAR_CHART_TOP_PADDING;
    CGFloat unitHeight = _chartHeight / _numberOfYAxis;
    CGFloat unitValue = [self.maxValue floatValue] / _numberOfYAxis;
    for (NSInteger i = 0; i <= _numberOfYAxis; i ++)
    {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, chartYOffset - unitHeight * i - 10, SYChart_BAR_CHART_LEFT_PADDING - 2, 20)];
        textLabel.textColor = _colorOfYText;
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.font = [UIFont systemFontOfSize:_yFontSize];
        textLabel.numberOfLines = 0;
        textLabel.text = [NSString stringWithFormat:@"%.0f%@", unitValue * i, _unitOfYAxis];
        
        [self addSubview:textLabel];
    }
}

- (void)reloadBarWithAnimate:(BOOL)animate
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGFloat xSection = _paddingSection;
    CGFloat xOffset = _paddingSection + _barWidth / 2;
    CGFloat chartYOffset = _chartHeight + SYChart_BAR_CHART_TOP_PADDING;
    for (NSInteger section = 0; section < _sections; section ++)
    {
        NSArray *array = _chartDataSource[section];
        for (NSInteger index = 0; index < array.count; index ++)
        {
            CGFloat height = [self normalizedHeightForRawHeight:array[index]];
            
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:CGPointMake(xOffset, chartYOffset)];
            [bezierPath addLineToPoint:CGPointMake(xOffset, chartYOffset - height)];
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
            shapeLayer.lineWidth = _barWidth;
            shapeLayer.path = bezierPath.CGPath;
            
            if ([self.delegate respondsToSelector:@selector(barChartView:colorOfBarInSection:index:)])
            {
                shapeLayer.strokeColor = [self.delegate barChartView:self colorOfBarInSection:section index:index].CGColor;
            }
            else
            {
                shapeLayer.strokeColor = [UIColor redColor].CGColor;
            }
            [_scrollView.layer addSublayer:shapeLayer];
            
            if (animate)
            {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation.fromValue = @(0.0);
                animation.toValue = @(1.0);
                animation.repeatCount = 1.0;
                animation.duration = height / _chartHeight * _animationTime;
                animation.fillMode = kCAFillModeForwards;
                animation.delegate = self;
                [shapeLayer addAnimation:animation forKey:@"animation"];
            }
            
            NSTimeInterval delay = (animate ? _animationTime : 0.0);
            if ([self.delegate respondsToSelector:@selector(barChartView:hintViewOfBarInSection:index:)])
            {
                UIView *hintView = [self.delegate barChartView:self hintViewOfBarInSection:section index:index];
                if (hintView)
                {
                    hintView.center = CGPointMake(xOffset, chartYOffset - height - CGRectGetHeight(hintView.bounds)/2);
                    hintView.alpha = 0.0;
                    [_scrollView addSubview:hintView];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        hintView.alpha = 1.0;
                    } completion:nil];
                }
            }
            else if ([self.delegate respondsToSelector:@selector(barChartView:informationOfBarInSection:index:)])
            {
                NSString *information = [self.delegate barChartView:self informationOfBarInSection:section index:index];
                if (information)
                {
                    SYChartInfromationView *informationView = [[SYChartInfromationView alloc] initWithText:information];
                    informationView.center = CGPointMake(xOffset, chartYOffset - height - CGRectGetHeight(informationView.bounds)/2);
                    informationView.alpha = 0.0;
                    [_scrollView addSubview:informationView];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        informationView.alpha = 1.0;
                    } completion:nil];
                }
            }
            
            xOffset += _barWidth + (index == array.count - 1 ? 0 : _paddingBar);
        }
        
        if ([self.delegate respondsToSelector:@selector(barChartView:titleOfBarInSection:)])
        {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSection - _paddingSection / 2, _chartHeight + SYChart_BAR_CHART_TOP_PADDING, xOffset - xSection + _paddingSection, SYChart_BAR_CHART_TEXT_HEIGHT)];
            textLabel.textColor = _colorOfXText;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:_xFontSize];
            textLabel.numberOfLines = 0;
            textLabel.text = [self.dataSource barChartView:self titleOfBarInSection:section];
            [_scrollView addSubview:textLabel];
        }
        xOffset += _paddingSection;
        xSection = xOffset;
    }
}

@end
