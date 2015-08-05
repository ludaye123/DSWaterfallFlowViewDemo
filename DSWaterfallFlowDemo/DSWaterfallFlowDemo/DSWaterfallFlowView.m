//
//  DSWaterfallFlowView.m
//  DSWaterfallFlowDemo
//
//  Created by LS on 8/4/15.
//  Copyright (c) 2015 LS. All rights reserved.
//

#import "DSWaterfallFlowView.h"
#import "DSWaterfallFlowViewCell.h"

@interface DSWaterfallFlowView ()

@property (strong, nonatomic) NSMutableArray *allCellFrames;
@property (strong, nonatomic) NSMutableDictionary *visibleCells;
@property (strong, nonatomic) NSMutableSet *reusableCells;

@end

static CGFloat const kCellOfDefaultHeight = 80;
static NSInteger const kNumberOfColumns = 2;
static CGFloat const kDefaultMargin = 2;

@implementation DSWaterfallFlowView


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}

#pragma mark - Public Method

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger numberOfCells = self.allCellFrames.count;
    
    for(int i = 0; i < numberOfCells; i++)
    {
        CGRect cellFrame = [self.allCellFrames[i] CGRectValue];
        DSWaterfallFlowViewCell *cell = [self.visibleCells objectForKey:@(i)];
    
        //i位置的cellFrame在当前屏幕内
        if([self isInScreen:cellFrame])
        {
            if(!cell)
            {
                cell = [self.dataSource waterfallFlowView:self cellForRowAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                [self.visibleCells setObject:cell forKey:@(i)];
            }
        }
        else
        {
            if(cell)
            {
                [cell removeFromSuperview];
                [self.visibleCells removeObjectForKey:@(i)];
                [self.reusableCells addObject:cell];
            }
        }
    }
}


- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block DSWaterfallFlowViewCell *reusableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(DSWaterfallFlowViewCell *cell, BOOL *stop) {
      
        if([cell.identifier isEqualToString:identifier])
        {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if(reusableCell)
    {
        [self.reusableCells removeObject:reusableCell];
    }
    
    return reusableCell;
}

- (void)reloadData
{
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterfallFlowView:self];
    NSUInteger numberOfColumns = [self numberOfColumns];
    
    CGFloat topMargin = [self marginWithType:DSWaterfallFlowViewTypeTop];
    CGFloat leftMargin = [self marginWithType:DSWaterfallFlowViewTypeLeft];
    CGFloat downMargin = [self marginWithType:DSWaterfallFlowViewTypeDown];
    CGFloat rightMargin = [self marginWithType:DSWaterfallFlowViewTypeRight];
    CGFloat rowMargin = [self marginWithType:DSWaterfallFlowViewTypeRow];
    CGFloat columnMargin = [self marginWithType:DSWaterfallFlowViewTypeColumn];
    
    CGFloat cellWidth = (self.frame.size.width-leftMargin-rightMargin-(numberOfColumns-1)*columnMargin)/numberOfColumns;
    
    CGFloat maxOriginYOfColumns[numberOfColumns];
    for(int i = 0; i < numberOfColumns; i++)
    {
        maxOriginYOfColumns[i] = 0.0;
    }
    
    for(int i = 0; i < numberOfCells; i++)
    {
        NSUInteger indexOfColumn = 0;
        CGFloat maxOriginY = maxOriginYOfColumns[indexOfColumn];
        for(int j = 1; j < numberOfColumns; j++)
        {
            if(maxOriginYOfColumns[j] < maxOriginY)
            {
                indexOfColumn = j;
                maxOriginY = maxOriginYOfColumns[j];
            }
        }
        
        CGFloat cellHeight = [self heightForCellAtIndex:i];
        CGFloat cellOriginX = leftMargin+(cellWidth+columnMargin)*indexOfColumn;
        CGFloat cellOriginY = 0;
        if(maxOriginY == 0)
        {
            cellOriginY = topMargin;
        }
        else
        {
            cellOriginY = maxOriginY + rowMargin;
        }
        
        CGRect cellFrame = CGRectMake(cellOriginX, cellOriginY, cellWidth, cellHeight);
        [self.allCellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        maxOriginYOfColumns[indexOfColumn] = CGRectGetMaxY(cellFrame);
    }
    
    CGFloat maxOriginY = maxOriginYOfColumns[0];
    for(int j = 1; j < numberOfColumns; j++)
    {
        if(maxOriginYOfColumns[j] > maxOriginY)
        {
            maxOriginY = maxOriginYOfColumns[j];
        }
    }
    maxOriginY += downMargin;
    self.contentSize = CGSizeMake(0, maxOriginY);
}

#pragma mark - Private Method

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(![self.delegate respondsToSelector:@selector(waterfallFlowView:didSelectCellAtIndex:)])  return ;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *selectIndex = nil;
    [self.visibleCells enumerateKeysAndObjectsUsingBlock:^(id key, DSWaterfallFlowViewCell *cell, BOOL *stop) {
        
        if(CGRectContainsPoint(cell.frame, point))
        {
            selectIndex = key;
            *stop = YES;
        }
    }];
    if(selectIndex)
    {
        [self.delegate waterfallFlowView:self didSelectCellAtIndex:selectIndex.unsignedIntegerValue];
    }
}

- (BOOL)isInScreen:(CGRect)frame
{
    return CGRectGetMaxY(frame) > self.contentOffset.y && CGRectGetMinY(frame) < self.contentOffset.y+CGRectGetHeight(self.bounds);
}

- (NSInteger)numberOfColumns
{
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterfallFlowView:)])
    {
        return [self.dataSource numberOfColumnsInWaterfallFlowView:self];
    }
    
    return kNumberOfColumns;
}

- (CGFloat)heightForCellAtIndex:(NSUInteger)index
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(waterfallFlowView:heightForCellAtIndex:)])
    {
        return [self.delegate waterfallFlowView:self heightForCellAtIndex:index];
    }
    
    return kCellOfDefaultHeight;
}

- (CGFloat)marginWithType:(DSWaterfallFlowViewType)type
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(waterfallFlowView:marginForType:)])
    {
        return [self.delegate waterfallFlowView:self marginForType:type];
    }
    
    return kDefaultMargin;
}

#pragma mark - Getter

- (NSMutableArray *)allCellFrames
{
    if(!_allCellFrames)
    {
        _allCellFrames = [[NSMutableArray alloc] init];
    }
    
    return _allCellFrames;
}

- (NSMutableDictionary *)visibleCells
{
    if(!_visibleCells)
    {
        _visibleCells = [[NSMutableDictionary alloc] init];
    }
    
    return _visibleCells;
}

- (NSMutableSet *)reusableCells
{
    if(!_reusableCells)
    {
        _reusableCells = [[NSMutableSet alloc] init];
    }
    
    return _reusableCells;
}


@end
