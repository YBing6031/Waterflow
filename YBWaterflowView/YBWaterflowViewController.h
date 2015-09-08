//
//  YBWaterflowViewController.h
//  瀑布流
//
//  Created by Jason on 15/9/1.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBWaterflowView.h"
#import "YBWaterflowViewCell.h"

@interface YBWaterflowViewController : UIViewController<YBWaterflowViewDataSource, YBWaterflowViewDelegate>

@property (nonatomic, strong) YBWaterflowView *waterflowView;

@end
