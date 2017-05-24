//
//  gameTableViewCell.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/6/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *awayImage;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *versusLabel;

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;

-(void)fillCell:(NSString*)description startTime:(NSString*)startTime imageLink:(NSString*)imageURL;

-(void)fillOldCell:(NSString*)description startTime:(NSString*)startTime imageLink:(NSString*)imageURL;

-(void)fillNewCell:(NSString*)description startTime:(NSString*)startTime imageLink:(NSString*)imageURL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreWidth;

@end
