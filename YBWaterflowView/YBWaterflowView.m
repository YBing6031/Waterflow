//
//  YBWaterflowView.m
//  瀑布流
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import "YBWaterflowView.h"
#import "YBWaterflowViewCell.h"

#define kNumberOfClumnsDefault 3//默认有多少列
#define kWaterflowViewMarginDefault 8//默认边距
#define kWaterflowViewCellHeightDefaulf 70//默认每个cell的高度

@interface YBWaterflowView ()

@property (strong, nonatomic)NSMutableArray *cellOfFrames;

@property (strong, nonatomic)NSMutableDictionary *displayingCellDict;

@property (strong, nonatomic)NSMutableSet *reusableCellSet;

@end

@implementation YBWaterflowView

- (NSMutableSet *)reusableCellSet
{
    if (_reusableCellSet == nil) {
        _reusableCellSet = [NSMutableSet set];
    }
    return _reusableCellSet;
}

- (NSMutableDictionary *)displayingCellDict
{
    if (_displayingCellDict == nil) {
        _displayingCellDict = [NSMutableDictionary dictionary];
    }
    return _displayingCellDict;
}

- (NSMutableArray *)cellOfFrames
{
    if (_cellOfFrames == nil) {
        _cellOfFrames = [NSMutableArray array];
    }
    return _cellOfFrames;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //创建cell
    for (int i = 0; i < self.cellOfFrames.count; i++) {
        //判断frame是否在屏幕上显示
        CGRect cellOfFrame = [self.cellOfFrames[i] CGRectValue];
        //先到字典中取这个cell
        YBWaterflowViewCell *cell = self.displayingCellDict[@(i)];
        if ([self isScreenWithFrame:cellOfFrame]) {//在屏幕上
            if (cell == nil) {
                cell = [self.dataSource waterflowView:self cellAtIndex:i];
                cell.frame = cellOfFrame;
                //存放到字典中
                self.displayingCellDict[@(i)] = cell;
            }
            [self addSubview:cell];
        } else {//不在屏幕上
            if (cell == nil) {
                continue;
            }
            [cell removeFromSuperview];
            [self.displayingCellDict removeObjectForKey:@(i)];
            //添加到缓存池中
            [self.reusableCellSet addObject:cell];
        }
    }
}

- (YBWaterflowViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block YBWaterflowViewCell *reusableCell = nil;
    [self.reusableCellSet enumerateObjectsUsingBlock:^(YBWaterflowViewCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) {
        [self.reusableCellSet removeObject:reusableCell];
    }
    
    return reusableCell;
}

- (void)reloadData
{
    //清除之前的数据
    [self.displayingCellDict.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCellDict removeAllObjects];
    [self.reusableCellSet removeAllObjects];
    [self.cellOfFrames removeAllObjects];
    
    //多少个cell
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterflowView:self];
    //多少列
    NSUInteger numberOfClumns = [self numberOfClumns];
    //边距
    CGFloat marginTop = [self marginWithType:YBWaterflowViewMarginTypeTop];
    CGFloat marginBottom = [self marginWithType:YBWaterflowViewMarginTypeBottom];
    CGFloat marginLeft = [self marginWithType:YBWaterflowViewMarginTypeLeft];
    CGFloat marginRight = [self marginWithType:YBWaterflowViewMarginTypeRight];
    CGFloat marginRow = [self marginWithType:YBWaterflowViewMarginTypeRow];
    CGFloat marginClumn = [self marginWithType:YBWaterflowViewMarginTypeClumn];
    
    //cell的宽度
    CGFloat cellW = (self.bounds.size.width - marginLeft - marginRight - marginClumn*(numberOfClumns - 1))/numberOfClumns;
    
    //数组存放所有列的最大Y值
    CGFloat maxYOfClumns[numberOfClumns];
    for (int i = 0; i < numberOfClumns; i++) {
        maxYOfClumns[i] = 0;
    }
    //计算每个cell的frame
    for (int i = 0; i < numberOfCells; i++) {
        //cell处在第几列
        NSUInteger cellClumn = 0;
        //cell所出那列的最大Y值
        CGFloat maxYOfClumn = maxYOfClumns[cellClumn];
        for (int j = 1; j < numberOfClumns; j++) {
            if (maxYOfClumn > maxYOfClumns[j]) {
                maxYOfClumn = maxYOfClumns[j];
                cellClumn = j;
            }
        }
        CGFloat cellX = marginLeft + (marginClumn + cellW)*cellClumn;
        CGFloat cellY = 0;
        if (maxYOfClumn == 0) {
            cellY = marginTop;
        } else {
            cellY = maxYOfClumn + marginRow;
        }
        
        CGFloat cellH = [self heightAtIndex:i];
        
        CGRect cellOfFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellOfFrames addObject:[NSValue valueWithCGRect:cellOfFrame]];
        
        maxYOfClumns[cellClumn] = CGRectGetMaxY(cellOfFrame);
    }
    //设置contentSize
    //cell处在第几列
    NSUInteger cellClumn = 0;
    //cell所出那列的最大Y值
    CGFloat maxYOfClumn = maxYOfClumns[cellClumn];
    for (int j = 1; j < numberOfClumns; j++) {
        if (maxYOfClumn < maxYOfClumns[j]) {
            maxYOfClumn = maxYOfClumns[j];
            cellClumn = j;
        }
    }
    self.contentSize = CGSizeMake(0, maxYOfClumn + marginBottom);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectAtIndex:)])return;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *selectIndex = nil;
    [self.displayingCellDict enumerateKeysAndObjectsUsingBlock:^(id key, YBWaterflowViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
        }
    }];
    if (selectIndex) {
        [self.delegate waterflowView:self didSelectAtIndex:[selectIndex unsignedIntegerValue]];
    }
}

#pragma mark - 私有方法
- (BOOL)isScreenWithFrame:(CGRect)frame
{
    CGFloat offsetY = self.contentOffset.y;
    return (CGRectGetMaxY(frame) > offsetY) &&
    (frame.origin.y < offsetY + self.bounds.size.height);
}

- (NSUInteger)numberOfClumns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)]) {
        return [self.dataSource numberOfColumnsInWaterflowView:self];
    } else {
        return kNumberOfClumnsDefault;
    }
}

- (CGFloat)marginWithType:(YBWaterflowViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginAtType:)]) {
        return [self.delegate waterflowView:self marginAtType:type];
    } else {
        return kWaterflowViewMarginDefault;
    }
}

- (CGFloat)heightAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    }
    return kWaterflowViewCellHeightDefaulf;
}

@end
