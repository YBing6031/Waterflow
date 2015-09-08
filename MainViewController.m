//
//  MainViewController.m
//  瀑布流
//
//  Created by Jason on 15/9/1.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfCellsInWaterflowView:(YBWaterflowView *)waterflowView
{
    return 100;
}

- (YBWaterflowViewCell *)waterflowView:(YBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
    static NSString *ID = @"cell";
    YBWaterflowViewCell *cell = [waterflowView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YBWaterflowViewCell alloc] initWithReuseIdentifier:ID];
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    }
    return cell;
}

- (CGFloat)waterflowView:(YBWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    return arc4random()%200+50;
}

- (void)waterflowView:(YBWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"%zi", index);
}

@end
