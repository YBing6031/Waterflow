//
//  YBWaterflowViewController.m
//  瀑布流
//
//  Created by Jason on 15/9/1.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import "YBWaterflowViewController.h"

@interface YBWaterflowViewController ()

@end

@implementation YBWaterflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waterflowView = [[YBWaterflowView alloc] initWithFrame:self.view.bounds];
    self.waterflowView.delegate = self;
    self.waterflowView.dataSource = self;
    [self.view addSubview:self.waterflowView];
    
}

- (NSUInteger)numberOfCellsInWaterflowView:(YBWaterflowView *)waterflowView
{
    return 0;
}

- (YBWaterflowViewCell *)waterflowView:(YBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
    return nil;
}

@end
