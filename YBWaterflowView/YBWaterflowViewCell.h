//
//  YBWaterflowViewCell.h
//  瀑布流
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBWaterflowViewCell : UIView

@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithReuseIdentifier:(NSString *)identifier;

@end
