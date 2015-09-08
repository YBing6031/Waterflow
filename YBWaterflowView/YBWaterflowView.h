//
//  YBWaterflowView.h
//  瀑布流
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBWaterflowView, YBWaterflowViewCell;

typedef NS_ENUM(NSInteger, YBWaterflowViewMarginType) {
    YBWaterflowViewMarginTypeTop,
    YBWaterflowViewMarginTypeBottom,
    YBWaterflowViewMarginTypeLeft,
    YBWaterflowViewMarginTypeRight,
    YBWaterflowViewMarginTypeRow,
    YBWaterflowViewMarginTypeClumn
};

/**
 *  瀑布流数据源协议
 */
@protocol YBWaterflowViewDataSource <NSObject>

@required
/**
 *  返回多少个cell
 */
- (NSUInteger)numberOfCellsInWaterflowView:(YBWaterflowView *)waterflowView;
/**
 *  返回cell
 *
 *  @param index         第几个cell
 */
- (YBWaterflowViewCell *)waterflowView:(YBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index;
@optional
/**
 *  返回多少列
 */
- (NSUInteger)numberOfColumnsInWaterflowView:(YBWaterflowView *)waterflowView;

@end

@protocol YBWaterflowViewDelegate <UIScrollViewDelegate>

@optional
/**
 *  返回每个cell的高度
 *
 *  @param index         第几个cell
 */
- (CGFloat)waterflowView:(YBWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index;

/**
 *  选中某个Cell
 *
 *  @param index         第几个cell
 */
- (void)waterflowView:(YBWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index;

/**
 *  返回每个边距
 *
 *  @param type          YBWaterflowViewMarginType
 */
- (CGFloat)waterflowView:(YBWaterflowView *)waterflowView marginAtType:(YBWaterflowViewMarginType)type;
@end


@interface YBWaterflowView : UIScrollView

@property (nonatomic, assign) id<YBWaterflowViewDataSource> dataSource;

@property (nonatomic, assign) id<YBWaterflowViewDelegate> delegate;

- (void)reloadData;

- (YBWaterflowViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
