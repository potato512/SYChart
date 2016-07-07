//
//  SYChartInfromationView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/6/23.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYChartInfromationView.h"

CGFloat static const kSYChartInfromationViewCornerRadius = 5.0;
CGFloat const kSYChartInfromationViewTextWidth = 40.0f;
CGFloat const kSYChartInfromationViewTextHeight = 20.0f;
CGFloat const kSYChartInfromationViewTipWidth = 8.0f;
CGFloat const kSYChartInfromationViewTipHeight = 5.0f;

#define kSYChartInfromationViewColor [UIColor colorWithWhite:1.0 alpha:0.9]

@interface SYChartInfromationView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SYChartInfromationView

- (instancetype)initWithText:(NSString *)text
{
    self = [super initWithFrame:CGRectMake(0, 0, kSYChartInfromationViewTextWidth, kSYChartInfromationViewTextHeight + kSYChartInfromationViewTipHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = kSYChartInfromationViewCornerRadius;
        self.layer.masksToBounds = YES;
        
        self.textLabel.text = text;
        [self addSubview:self.textLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, kSYChartInfromationViewTextWidth, kSYChartInfromationViewTextHeight);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSaveGState(context);
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, CGRectGetMidX(rect) - kSYChartInfromationViewTipWidth / 2, kSYChartInfromationViewTextHeight);
        CGContextAddLineToPoint(context, CGRectGetMidX(rect) + kSYChartInfromationViewTipWidth / 2, kSYChartInfromationViewTextHeight);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, _informationViewBackgroundColor.CGColor);
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
}

#pragma mark - getter

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.layer.cornerRadius = kSYChartInfromationViewCornerRadius;
        _textLabel.layer.masksToBounds = YES;
        _textLabel.font = [UIFont systemFontOfSize:12.0];
        _textLabel.backgroundColor = kSYChartInfromationViewColor;
        _textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.numberOfLines = 1;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _textLabel;
}

#pragma mark - setter

- (void)setInformationViewBackgroundColor:(UIColor *)informationViewBackgroundColor
{
    _informationViewBackgroundColor = informationViewBackgroundColor;
    self.textLabel.backgroundColor = _informationViewBackgroundColor;
}

- (void)setInformationViewTextColor:(UIColor *)informationViewTextColor
{
    _informationViewTextColor = informationViewTextColor;
    self.textLabel.textColor = _informationViewTextColor;
}

- (void)setInformationViewTextFont:(UIFont *)informationViewTextFont
{
    _informationViewTextFont = informationViewTextFont;
    self.textLabel.font = _informationViewTextFont;
}

@end
