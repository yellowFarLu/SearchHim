//
//  HYWaterFlowView.m
//  瀑布流实现
//
//  Created by 黄远 on 16/7/8.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYWaterFlowView.h"
#import "HYWaterFlowViewCell.h"

@interface HYWaterFlowView ()
@property (nonatomic, strong) NSMutableArray* cellFrames;
@property (nonatomic, strong) NSMutableDictionary* showingCells;

//NSSet当做缓存池
@property (nonatomic, strong) NSMutableSet* cellPool;
@end


@implementation HYWaterFlowView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    
    [self.showingCells enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, HYWaterFlowViewCell* obj, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            if ([self.delegate respondsToSelector:@selector(waterFlowView:didSelectRowAtIndex:)]) {
                [self.delegate waterFlowView:self didSelectRowAtIndex:key.integerValue];
            }
            *stop = YES;
        }
    }];
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


/*
 * scroollView滚动调用的方法
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i=0; i<self.cellFrames.count; i++) {
        NSValue* value = self.cellFrames[i];
        HYWaterFlowViewCell* cell = self.showingCells[@(i)];
        if ([self isInScreen:value.CGRectValue]) {
            if (!cell) {
                HYWaterFlowViewCell* cell = [self.dataSource waterFlowView:self cellForIndex:i];
                cell.alpha = 0.0;
                [UIView animateWithDuration:1.0 animations:^{
                    cell.frame = value.CGRectValue;
                    cell.alpha = 1.0;
                }];
                [self addSubview:cell];
                self.showingCells[@(i)] = cell;
                [self.cellPool removeObject:cell];
//                NSLog(@"%d  -----  %@", i, cell);
            }
        }else{
            [self.showingCells removeObjectForKey:@(i)];
            [cell removeFromSuperview];
            if (cell) {
                [self.cellPool addObject:cell];
            }
        }
        
    }
}

- (HYWaterFlowViewCell*)dequeCellFromCellPoolWithIdentifited:(NSString*)identified{
    __block HYWaterFlowViewCell* cell = nil;
    [self.cellPool enumerateObjectsUsingBlock:^(HYWaterFlowViewCell* obj, BOOL * _Nonnull stop) {
        if ([obj.reuseIdentifier isEqualToString:identified]) {
            cell = obj;
            *stop = NO;
        }
    }];
    if (cell) {
//        NSLog(@"重用的cell  ---- %@", cell);
    }
    return cell;
}

- (NSMutableSet*)cellPool{
    if (!_cellPool) {
        _cellPool = [NSMutableSet set];
    }
    return _cellPool;
}


- (BOOL)isInScreen:(CGRect)frame{
    return (self.contentOffset.y < CGRectGetMaxY(frame)) && ((self.contentOffset.y + self.bounds.size.height) > frame.origin.y);
}


- (NSMutableDictionary*)showingCells{
    if (!_showingCells) {
        _showingCells = [NSMutableDictionary dictionary];
    }
    return _showingCells;
}

- (NSMutableArray*)cellFrames{
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (CGFloat)cellWidth{
    CGFloat leftMargin = [self marginOfType:HYWaterFlowViewMarginTypeLeft];
    CGFloat rightMargin = [self marginOfType:HYWaterFlowViewMarginTypeRight];
    NSUInteger colNumber = [self numberOfCol];
    CGFloat colMarin = [self marginOfType:HYWaterFlowViewMarginTypeColunm];
    
    return (self.frame.size.width - leftMargin - rightMargin - (colNumber-1)*colMarin) / colNumber;
}

- (void)reloadData{
    self.cellFrames = nil;
    [self.showingCells removeAllObjects];
    [self.cellPool removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = [self.dataSource numberOfCountForWaterFlowView:self];
    NSUInteger colNumber = [self numberOfCol];
    CGFloat cellX, cellY, cellH, cellW, topMargin, leftMargin, rightMargin, colMarin, rowMargin, bottomMargin;
    topMargin = [self marginOfType:HYWaterFlowViewMarginTypeTop];
    leftMargin = [self marginOfType:HYWaterFlowViewMarginTypeLeft];
//    rightMargin = [self marginOfType:HYWaterFlowViewMarginTypeRight];
    colMarin = [self marginOfType:HYWaterFlowViewMarginTypeColunm];
    rowMargin = [self marginOfType:HYWaterFlowViewMarginTypeRow];
    bottomMargin = [self marginOfType:HYWaterFlowViewMarginTypeBottom];
    
    cellW = [self cellWidth];
    CGFloat minYArr[colNumber];
    for (int i=0; i<colNumber; i++) {
        minYArr[i] = 0.0;
    }
    
    int smallYIndex = 0;
    for (int i=0; i<count; i++) {
        cellH = [self heightForCell:i];
        
        for (int j=0; j<colNumber; j++) {
            if (minYArr[smallYIndex] > minYArr[j]) {
                smallYIndex = j;
            }
        }
        
        cellX = leftMargin + smallYIndex * (cellW + colMarin);
        if (minYArr[smallYIndex] == 0.0) {
            cellY = topMargin;
        }else{
            cellY = minYArr[smallYIndex] + rowMargin;
        }
        minYArr[smallYIndex] = cellY + cellH;
        
        CGRect frame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    
    self.contentSize = CGSizeMake(0, minYArr[smallYIndex] + bottomMargin);
}


#define defaultMarginForCell 15
- (CGFloat)marginOfType:(HYWaterFlowViewMarginType)type{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:marginForType:)]) {
        return [self.delegate waterFlowView:self marginForType:type];
    } else {
        return defaultMarginForCell;
    }
}


#define dedaultHeightForCell 70
- (CGFloat)heightForCell:(NSUInteger)index{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:heightForIndex:)]) {
        return [self.delegate waterFlowView:self heightForIndex:index];
    } else {
        return dedaultHeightForCell;
    }
}

#define defaultNumberOfColunm 3
- (NSUInteger)numberOfCol{
    if ([self.dataSource respondsToSelector:@selector(numOfColunmInWaterFlowView:)]) {
        return [self.dataSource numOfColunmInWaterFlowView:self];
    } else {
        return defaultNumberOfColunm;
    }
}

@end
