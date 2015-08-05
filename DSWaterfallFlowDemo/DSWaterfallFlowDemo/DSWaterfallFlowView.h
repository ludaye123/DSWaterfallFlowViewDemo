//
//  DSWaterfallFlowView.h
//  DSWaterfallFlowDemo
//
//  Created by LS on 8/4/15.
//  Copyright (c) 2015 LS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSWaterfallFlowView;
@class DSWaterfallFlowViewCell;

typedef NS_ENUM(NSInteger,  DSWaterfallFlowViewType){
    /**
     * The waterfallFlowView of top margin
     */
    DSWaterfallFlowViewTypeTop,
    /**
     * The waterfallFlowView of left margin
     */
    DSWaterfallFlowViewTypeLeft,
    /**
     *  The waterfallFlowView of down margin
     */
    DSWaterfallFlowViewTypeDown,
    /**
     *  The waterfallFlowView of right margin
     */
    DSWaterfallFlowViewTypeRight,
    /**
     *  The waterfallFlowView of row margin
     */
    DSWaterfallFlowViewTypeRow,
    /**
     *  The waterfallFlowView of column margin
     */
    DSWaterfallFlowViewTypeColumn
};

@protocol DSWaterfallFlowViewDataSource <NSObject>

@required
- (NSInteger)numberOfCellsInWaterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView; // Default is 2,if not

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (DSWaterfallFlowViewCell *)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView cellForRowAtIndex:(NSUInteger)index;

@optional
- (NSInteger)numberOfColumnsInWaterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView; //Default is 2,if not

@end


@protocol DSWaterfallFlowViewDelegate <UIScrollViewDelegate>

@optional

- (CGFloat)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView heightForCellAtIndex:(NSUInteger)index; //Default is 80.0, if not
- (CGFloat)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView marginForType:(DSWaterfallFlowViewType)type; //Default is 2.0, if not
- (void)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView didSelectCellAtIndex:(NSUInteger)index;

@end

@interface DSWaterfallFlowView : UIScrollView
{
    
}

@property (assign, nonatomic) id<DSWaterfallFlowViewDataSource> dataSource;
@property (nonatomic, assign) id<DSWaterfallFlowViewDelegate> delegate;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;  // Used by the delegate to acquire an already allocated cell, in lieu of allocating a new one.
- (void)reloadData;

@end
