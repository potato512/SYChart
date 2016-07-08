//
//  ViewController.m
//  DemoPNChart
//
//  Created by zhangshaoyu on 16/6/22.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"

#import "LineVC.h"
#import "BarVC.h"
#import "PieVC.h"
#import "CycleVC.h"
#import "ScatterVC.h"
#import "SYLineVC.h"
#import "SYBarVC.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *vcArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Chart";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
//    UITableViewDataSource UITableViewDelegate
    
    self.vcArray = @[[LineVC class], [BarVC class], [PieVC class], [CycleVC class], [ScatterVC class], [SYLineVC class], [SYBarVC class]];
    CGFloat originY = 10.0;
    for (int i = 0; i < self.vcArray.count; i++)
    {
        NSString *title = NSStringFromClass(self.vcArray[i]);
        
        UIButton *button = [[UIButton alloc] init];
        [self.view addSubview:button];
        button.frame = CGRectMake(10.0, originY, (CGRectGetWidth(self.view.bounds) - 10.0 * 2), 40.0);
        button.backgroundColor = [UIColor yellowColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        originY += (40.0 + 10.0);
    }
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger index = button.tag;
    
    Class vcClass = self.vcArray[index];
    UIViewController *vc = [[vcClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
