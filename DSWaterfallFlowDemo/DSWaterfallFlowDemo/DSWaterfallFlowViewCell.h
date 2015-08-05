//
//  DSWaterfallFlowViewCell.h
//  DSWaterfallFlowDemo
//
//  Created by LS on 8/4/15.
//  Copyright (c) 2015 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSWaterfallFlowViewCell : UIView
{
}

@property (copy, nonatomic) NSString *identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier;

@end
