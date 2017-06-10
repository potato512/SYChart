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

// 刻度递增值
@property (nonatomic, assign, readonly) CGFloat heightYStep;

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
    _chartHeight = (self.bounds.size.height - SYChart_BAR_CHART_TOP_PADDING - SYChart_BAR_CHART_TEXT_HEIGHT);
    
    _unitOfYAxis = @"";
    _numberOfYAxis = 5;
    _cachedMaxHeight = kSYChartBarUndefinedCachedHeight;
    _cachedMinHeight = kSYChartBarUndefinedCachedHeight;
    
    _colorOfYAxis = _colorOfYText = [UIColor blackColor];
    _yFontSize = 14.0;
    
    _yUnitFontSize = 12.0;
    _yUnitColor = [UIColor blackColor];
    
    _xUnitFontSize = 12.0;
    _xUnitColor = [UIColor blackColor];
    
    _colorOfXAxis = _colorOfXText = [UIColor blackColor];
    _xFontSize = 14.0;
    _xFontSizeAuto = NO;
    
    _dotTitleBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    _dotTitleColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    _dotTitleFont = [UIFont systemFontOfSize:12.0];
    
    _animationTime = 0.6;
    
    _gridsType = SYChartGridsTypeNone;
    _gridsLineWidth = 0.5;
    _gridsLineColor = [UIColor lightGrayColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SYChart_BAR_CHART_LEFT_PADDING, 0, (width - SYChart_BAR_CHART_RIGHT_PADDING - SYChart_BAR_CHART_LEFT_PADDING), CGRectGetHeight(self.bounds))];
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
    [self drawChartGridsWithContext:context];
}

#pragma mark - Draw Coordinate

- (void)drawCoordinateWithContext:(CGContextRef)context
{
    CGFloat width = self.bounds.size.width;
    
    // Y坐标轴
    CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
    CGContextMoveToPoint(context, SYChart_BAR_CHART_LEFT_PADDING - 1, SYChart_BAR_CHART_TOP_PADDING - 1 - 10.0);
    CGContextAddLineToPoint(context, SYChart_BAR_CHART_LEFT_PADDING - 1, SYChart_BAR_CHART_TOP_PADDING + _chartHeight + 1);
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
    
    // X坐标轴
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, SYChart_BAR_CHART_LEFT_PADDING - 1, SYChart_BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextAddLineToPoint(context, width - SYChart_BAR_CHART_RIGHT_PADDING + 1, SYChart_BAR_CHART_TOP_PADDING + _chartHeight + 1);
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
    CGFloat height = value / maxHeight * _chartHeight;
    return height;
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
    
    NSAssert([self.dataSource respondsToSelector:@selector(barChartView:numberOfBarsForSection:)], @"BarChartView // delegate must implement barChartView:numberOfBarsForSection:");
    
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
    
    NSAssert(([self.dataSource respondsToSelector:@selector(barChartView:valueOfBarAtIndexPath:)]), @"MCBarChartView // delegate must implement - (CGFloat)barChartView:(MCBarChartView *)barChartView valueOfBarAtIndexPath:(NSIndexPath *)indexPath");
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:_sections];
    CGFloat contentWidth = _paddingSection;
    for (NSUInteger i = 0; i < _sections; i ++)
    {
        NSUInteger barCount = [self.dataSource barChartView:self numberOfBarsForSection:i];
        
        contentWidth += (barCount * _barWidth + (barCount - 1) * _paddingBar);
        contentWidth += _paddingSection;
        
        NSMutableArray *barArray = [NSMutableArray arrayWithCapacity:barCount];
        for (NSInteger j = 0; j < barCount; j ++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            id value = [self.dataSource barChartView:self valueOfBarAtIndexPath:indexPath];
            [barArray addObject:value];
        }
        [dataArray addObject:barArray];
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    _chartDataSource = [[NSMutableArray alloc] initWithArray:dataArray];
}

- (void)reloadChartUnit
{
    // 刻度单位
    if (self.yUnitText && 0 != [self.yUnitText length])
    {
        CGFloat width = [self.yUnitText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.yUnitFontSize]}].width;
        width = (width >= (SYChart_BAR_CHART_LEFT_PADDING - 2) ? (width + SYChart_PADDING_SECTION_DEFAULT) : (SYChart_BAR_CHART_LEFT_PADDING - 2));
        CGRect drawRect = CGRectMake(0.0, 0.0, width, 20.0);
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
        width = (width >= (SYChart_BAR_CHART_LEFT_PADDING - 2) ? (width + SYChart_PADDING_SECTION_DEFAULT) : (SYChart_BAR_CHART_LEFT_PADDING - 2));
        CGRect drawRect = CGRectMake((CGRectGetWidth(self.bounds) - width), (CGRectGetHeight(self.bounds) - (SYChart_BAR_CHART_LEFT_PADDING - 2)), width, 20.0);
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
    // Y 刻度
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    CGFloat chartYOffset = (_chartHeight + SYChart_BAR_CHART_TOP_PADDING);
    CGFloat unitHeight = (_chartHeight / _numberOfYAxis);
    CGFloat unitValue = ([self.maxValue floatValue] / _numberOfYAxis);
    for (NSInteger i = 0; i <= _numberOfYAxis; i ++)
    {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (chartYOffset - unitHeight * i - 10), (SYChart_BAR_CHART_LEFT_PADDING - 2), 20)];
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
    CGFloat xOffset = (_paddingSection + _barWidth / 2);
    CGFloat chartYOffset = (_chartHeight + SYChart_BAR_CHART_TOP_PADDING);
    for (NSInteger section = 0; section < _sections; section ++)
    {
        NSArray *array = _chartDataSource[section];
        for (NSInteger index = 0; index < array.count; index ++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            
            CGFloat height = [self normalizedHeightForRawHeight:array[index]];
            
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:CGPointMake(xOffset, chartYOffset)];
            [bezierPath addLineToPoint:CGPointMake(xOffset, (chartYOffset - height))];
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
            shapeLayer.lineWidth = _barWidth;
            shapeLayer.path = bezierPath.CGPath;
            
            if ([self.delegate respondsToSelector:@selector(barChartView:colorOfBarAtIndexPath:)])
            {
                shapeLayer.strokeColor = [self.delegate barChartView:self colorOfBarAtIndexPath:indexPath].CGColor;
            }
            else
            {
                shapeLayer.strokeColor = [UIColor redColor].CGColor;
            }
            [_scrollView.layer addSublayer:shapeLayer];
            // 点击事件
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake((xOffset - _barWidth / 2), (chartYOffset - height), _barWidth, height)];
            [_scrollView addSubview:tapView];
            tapView.backgroundColor = [UIColor clearColor];
            tapView.userInteractionEnabled = YES;
            tapView.indexPath = indexPath;
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barTapClick:)];
            [tapView addGestureRecognizer:tapRecognizer];
            
            if (animate)
            {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation.fromValue = @(0.0);
                animation.toValue = @(1.0);
                animation.repeatCount = 1.0;
                animation.duration = (height / _chartHeight * _animationTime);
                animation.fillMode = kCAFillModeForwards;
                animation.delegate = self;
                [shapeLayer addAnimation:animation forKey:@"animation"];
            }
            
            NSTimeInterval delay = (animate ? _animationTime : 0.0);
            if ([self.delegate respondsToSelector:@selector(barChartView:hintViewOfBarAtIndexPath:)])
            {
                UIView *hintView = [self.delegate barChartView:self hintViewOfBarAtIndexPath:indexPath];
                if (hintView)
                {
                    hintView.center = CGPointMake(xOffset, (chartYOffset - height - CGRectGetHeight(hintView.bounds) / 2));
                    hintView.alpha = 0.0;
                    [_scrollView addSubview:hintView];
                    // 点击事件
                    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotTapClick:)];
                    hintView.indexPath = indexPath;
                    hintView.userInteractionEnabled = YES;
                    [hintView addGestureRecognizer:tapRecognizer];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        hintView.alpha = 1.0;
                    } completion:nil];
                }
            }
            else if ([self.delegate respondsToSelector:@selector(barChartView:informationOfBarAtIndexPath:)])
            {
                NSString *information = [self.delegate barChartView:self informationOfBarAtIndexPath:indexPath];
                if (information)
                {
                    SYChartInfromationView *informationView = [[SYChartInfromationView alloc] initWithText:information];
                    informationView.center = CGPointMake(xOffset, (chartYOffset - height - CGRectGetHeight(informationView.bounds) / 2));
                    informationView.alpha = 0.0;
                    informationView.informationViewBackgroundColor = _dotTitleBackgroundColor;
                    informationView.informationViewTextColor = _dotTitleColor;
                    informationView.informationViewTextFont = _dotTitleFont;
                    [_scrollView addSubview:informationView];
                    // 点击事件
                    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotTapClick:)];
                    informationView.indexPath = indexPath;
                    informationView.userInteractionEnabled = YES;
                    [informationView addGestureRecognizer:tapRecognizer];
                    
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        informationView.alpha = 1.0;
                    } completion:nil];
                }
            }
            
            xOffset += (_barWidth + (index == array.count - 1 ? 0 : _paddingBar));
        }
        
        if ([self.delegate respondsToSelector:@selector(barChartView:titleOfBarForSection:)])
        {
            CGFloat originYBar = (_chartHeight + SYChart_BAR_CHART_TOP_PADDING);
            CGFloat widthBar = (array.count * _barWidth + (array.count - 1) * _paddingBar + _paddingSection);
            CGFloat heightBar = SYChart_BAR_CHART_TEXT_HEIGHT;
            CGFloat originXBar = (xOffset - widthBar);
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(originXBar, originYBar, widthBar, heightBar)];
            textLabel.textColor = _colorOfXText;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:_xFontSize];
            textLabel.numberOfLines = 0;
            if (_xFontSizeAuto)
            {
                textLabel.numberOfLines = 1;
                textLabel.adjustsFontSizeToFitWidth = YES;
            }
            textLabel.text = [self.dataSource barChartView:self titleOfBarForSection:section];
            
            [_scrollView addSubview:textLabel];
            
            {
                // X坐标轴刻度
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
        }

        xOffset += _paddingSection;
        xSection = xOffset;
    }
}

#pragma mark - 响应事件

- (void)barTapClick:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(barChartView:didSelectBarAtIndexPath:)])
    {
        UIView *view = recognizer.view;
        NSIndexPath *indexPath = view.indexPath;
        [self.delegate barChartView:self didSelectBarAtIndexPath:indexPath];
    }
}

- (void)dotTapClick:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(barChartView:didSelectBarDotViewAtIndexPath:)])
    {
        UIView *view = recognizer.view;
        NSIndexPath *indexPath = view.indexPath;
        [self.delegate barChartView:self didSelectBarDotViewAtIndexPath:indexPath];
    }
}

@end
