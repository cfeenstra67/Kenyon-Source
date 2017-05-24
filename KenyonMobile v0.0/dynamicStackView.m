//
//  dynamicStackView.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "dynamicStackView.h"

@interface dynamicStackView(){
    CGFloat cellHeight;
    CGFloat accessoryHeight;
    NSInteger numCells;
}
@end

@implementation dynamicStackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    self=[super init];
    _dataSource=nil;
    _myDelegate=nil;
    cellHeight=0;
    accessoryHeight=0;
    self.contentSize=CGSizeZero;
    numCells=0;
    return self;
}

-(void)setMyDelegate:(id<dynamicStackViewDelegate>)myDelegate
{
    _myDelegate=myDelegate;
}

-(void)setDataSource:(id<dynamicStackViewDataSource>)dataSource
{
    _dataSource=dataSource;
    cellHeight=[_dataSource headerCellHeight];
    accessoryHeight=[_dataSource accessoryViewHeight];
    numCells=[_dataSource numberofCellsForDynamicStackView];
    [self reloadData];
}

-(void)reloadData
{
    for(NSInteger i=0; i<numCells; i++)
    {
        
    }
}



@end
