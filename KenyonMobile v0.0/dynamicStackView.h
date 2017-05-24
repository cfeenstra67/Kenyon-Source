//
//  dynamicStackView.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/6/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dynamicStackViewDataSource;

@protocol dynamicStackViewDelegate;

@interface dynamicStackView : UIScrollView

@property (strong, nonatomic) id<dynamicStackViewDataSource> dataSource;

@property (strong, nonatomic) id<dynamicStackViewDelegate> myDelegate;

@end

@protocol dynamicStackViewDataSource <NSObject>

@required

-(UIView*)headerCellForIndex:(NSInteger)index;

-(UIView*)accessoryViewForIndex:(NSInteger)index;

-(CGFloat)headerCellHeight;

-(CGFloat)accessoryViewHeight;

-(NSInteger)numberofCellsForDynamicStackView;

@end

@protocol dynamicStackViewDelegate <UIScrollViewDelegate>

-(void)dynamicStackView:(dynamicStackView*)stackView didShowAccessoryViewAtIndex:(NSInteger)index;

-(void)dynamicStackView:(dynamicStackView *)stackView didHideAccessoryViewAtIndex:(NSInteger)index;

@end
