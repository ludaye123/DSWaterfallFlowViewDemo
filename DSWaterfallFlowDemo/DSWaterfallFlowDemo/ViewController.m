//
//  ViewController.m
//  DSWaterfallFlowDemo
//
//  Created by LS on 8/4/15.
//  Copyright (c) 2015 LS. All rights reserved.
//

#import "ViewController.h"
#import "DSWaterfallFlowView.h"
#import "DSWaterfallFlowViewCell.h"

@interface ViewController () <DSWaterfallFlowViewDataSource,DSWaterfallFlowViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DSWaterfallFlowView *waterfallFlowView = [[DSWaterfallFlowView alloc] initWithFrame:self.view.frame];
    waterfallFlowView.dataSource = self;
    waterfallFlowView.delegate  = self;
    [self.view addSubview:waterfallFlowView];
}

- (UIColor *)randonColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
   
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

#pragma mark - DSWaterfallFlowViewDataSource

- (NSInteger)numberOfCellsInWaterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView
{
    return 150;
}

- (NSInteger)numberOfColumnsInWaterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView
{
    return 3;
}

- (DSWaterfallFlowViewCell *)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView cellForRowAtIndex:(NSUInteger)index
{
    static NSString *identifier = @"cell";
    
    DSWaterfallFlowViewCell *cell = [waterfallFlowView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[DSWaterfallFlowViewCell alloc] initWithIdentifier:identifier];
        cell.backgroundColor = [self randonColor];
    }
    
    NSLog(@"%zd --- %p",index,cell);
    
    return cell;
}


#pragma mark - DSWaterfallFlowViewDelegate

- (CGFloat)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView heightForCellAtIndex:(NSUInteger)index
{
    switch (index % 3) {
        case 0: return 90;
        case 1: return 70;
        case 2: return 160;
            
        default: return 100;
    }
}

- (CGFloat)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView marginForType:(DSWaterfallFlowViewType)type
{
    switch (type) {
        case DSWaterfallFlowViewTypeTop:
        case DSWaterfallFlowViewTypeLeft:
        case DSWaterfallFlowViewTypeDown:
        case DSWaterfallFlowViewTypeRight:
            return 10;
            
        default: return 5;
    }
}

- (void)waterfallFlowView:(DSWaterfallFlowView *)waterfallFlowView didSelectCellAtIndex:(NSUInteger)index
{
    NSLog(@"click in %zd",index);
}

@end
