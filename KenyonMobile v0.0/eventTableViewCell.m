//
//  eventTableViewCell.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/9/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "eventTableViewCell.h"

@implementation eventTableViewCell

//@synthesize imageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageHeight=60;
    self.autoresizingMask=UIViewAutoresizingNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews] ;
    if(self.imageView.bounds.size.height>self.imageView.bounds.size.width)
    {
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    else
    {
        self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    }
    self.imageView.bounds = CGRectMake(4,(_height-_imageHeight)/2,_imageHeight,_imageHeight);
    self.imageView.clipsToBounds=YES;
    self.imageView.frame = CGRectMake(4,(_height-_imageHeight)/2,_imageHeight,_imageHeight);
    
    //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = _imageHeight+4;
    tmpFrame.origin.x=self.imageView.frame.origin.x*2+self.imageView.frame.size.width+4;
    tmpFrame.size.width=self.frame.size.width-tmpFrame.origin.x-30;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = _imageHeight+4;
    self.detailTextLabel.frame = tmpFrame;
    
    self.separatorInset=UIEdgeInsetsZero;
    self.layoutMargins=UIEdgeInsetsZero;
    //[self setUserInteractionEnabled:YES];
    //[self layoutIfNeeded];
    
}

@end
