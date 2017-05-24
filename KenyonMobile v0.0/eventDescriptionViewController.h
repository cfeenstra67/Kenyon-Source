//
//  eventDescriptionViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/10/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventDescriptionViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *titleView;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *titleText;

@property (strong, nonatomic) NSString *image;

@property (strong, nonatomic) NSString *descriptionText;

@property (strong, nonatomic) NSString *dateText;

@property (strong, nonatomic) NSDate *myDate;

@property (strong, nonatomic) IBOutlet UINavigationItem *date;

- (IBAction)backPressed:(id)sender;

@end
