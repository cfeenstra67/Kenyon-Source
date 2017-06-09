//
//  segmentedLabel.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/3/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "segmentedLabel.h"

@interface segmentedLabel(){
    NSInteger numberOfLabels;
    NSArray<UILabel*>* labels;
}
@end

@implementation segmentedLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    _dataSource=nil;
    numberOfLabels=0;
    labels=nil;
    return self;
}

-(void)setDataSource:(id<segmentedLabelDataSource>)dataSource
{
    _dataSource=dataSource;
    [self reloadData];
}

-(void)setTextColor:(UIColor *)textColor
{
    [self completeBlockForLabels:^(UILabel *label, NSInteger integer){
        [label setTextColor:textColor];
    }];
}

-(void)setFont:(UIFont *)font
{
    [self completeBlockForLabels:^(UILabel *label, NSInteger integer){
        [label setFont:font];
    }];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [self completeBlockForLabels:^(UILabel *label, NSInteger integer){
        [label setTextAlignment:textAlignment];
    }];
}

-(void)reloadData
{
    if(_dataSource!=nil)
    {
        for(UIView *v in self.subviews)
        {
            [v removeFromSuperview];
        }
        numberOfLabels=[_dataSource numberOfSegmentsInLabel];
        NSMutableArray *temp=[[NSMutableArray alloc] init];
        for(NSInteger i=0; i<numberOfLabels; i++)
        {
            UILabel *lab=[[UILabel alloc] initWithFrame:[self frameForLabelAtIndex:i]];
            lab.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
            [lab setText:[_dataSource segmentedLabel:self textForLabelAtIndex:i]];
            [temp addObject:lab];
            [self addSubview:lab];
        }
        labels=temp;
    }
}

-(void)completeBlockForLabels:(void(^)(UILabel* label, NSInteger index))labelBlock
{
    for(NSInteger i=0; i<labels.count; i++)
    {
        labelBlock(labels[i], i);
    }
}

-(void)completeBlock:(void (^)(UILabel *))labelBlock forLabelAtIndex:(NSInteger)index
{
    labelBlock(labels[index]);
}

-(CGRect)frameForLabelAtIndex:(NSInteger)index
{
    CGFloat labelWidth=self.frame.size.width/(float)numberOfLabels;
    return CGRectMake(labelWidth*index, 0, labelWidth, self.frame.size.height);
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self reloadData];
}

@end
