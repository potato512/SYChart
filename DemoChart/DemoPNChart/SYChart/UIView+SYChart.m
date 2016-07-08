//
//  UIView+SYChart.m
//  DemoChart
//
//  Created by zhangshaoyu on 16/7/8.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "UIView+SYChart.h"
#import <objc/runtime.h>

static NSString *const keyViewIndexPath = @"keyViewIndexPath";

@implementation UIView (SYChart)

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, &keyViewIndexPath, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath
{
    NSIndexPath *indexpath = objc_getAssociatedObject(self, &keyViewIndexPath);
    return indexpath;
}

@end
