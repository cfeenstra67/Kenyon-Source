//
//  segmentedLabel.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/3/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol segmentedLabelDataSource;

@interface segmentedLabel : UILabel

@property (strong, nonatomic) id<segmentedLabelDataSource> dataSource;

@property NSInteger index;

-(void)completeBlock:(void(^)(UILabel*))labelBlock forLabelAtIndex:(NSInteger)index;

-(void)reloadData;

@end

@protocol segmentedLabelDataSource<NSObject>

-(NSInteger)numberOfSegmentsInLabel;

-(NSString*)segmentedLabel:(segmentedLabel*)segLabel textForLabelAtIndex:(NSInteger)index;

@end
