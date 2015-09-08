//
//  ViewController.m
//  瀑布流
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import "ViewController.h"
#import "YBWaterflowView.h"
#import "YBWaterflowViewCell.h"

@interface ViewController ()<YBWaterflowViewDelegate, YBWaterflowViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    YBWaterflowView *waterflowView = [[YBWaterflowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    waterflowView.delegate = self;
    waterflowView.dataSource = self;
    [self.view addSubview:waterflowView];
}

#pragma mark - YBWaterflowViewDataSource
- (NSUInteger)numberOfCellsInWaterflowView:(YBWaterflowView *)waterflowView
{
    return 100;
}

- (NSUInteger)numberOfColumnsInWaterflowView:(YBWaterflowView *)waterflowView
{
    return 4;
}

- (YBWaterflowViewCell *)waterflowView:(YBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
    static NSString *ID = @"cell";
    YBWaterflowViewCell *cell = [waterflowView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YBWaterflowViewCell alloc] initWithReuseIdentifier:ID];
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.tag = 10;
        [cell addSubview:label];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%zi", index];
    
    return cell;
}

- (CGFloat)waterflowView:(YBWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    return arc4random()%100+50;
}

- (CGFloat)waterflowView:(YBWaterflowView *)waterflowView marginAtType:(YBWaterflowViewMarginType)type
{
    switch (type) {
        case YBWaterflowViewMarginTypeTop:return 20;
        case YBWaterflowViewMarginTypeBottom:return 20;
        case YBWaterflowViewMarginTypeLeft:return 10;
        case YBWaterflowViewMarginTypeRight:return 10;
        case YBWaterflowViewMarginTypeRow:return 8;
        case YBWaterflowViewMarginTypeClumn:return 8;
    }
}

- (void)waterflowView:(YBWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"%zi", index);
}

@end
