//
//  eventSettingsViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/14/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewHeight;

- (IBAction)tappedPicker:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *pickerView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (strong, nonatomic) NSArray *theSections;

@property (strong, nonatomic) NSString *initialDate;

@property (strong, nonatomic) NSArray <NSString*> *activeCategories;

@property (strong, nonatomic) NSMutableDictionary <NSString*,NSNumber*> *isOn;

@property (strong, nonatomic) NSDictionary <NSString*,NSNumber*> *wasOn;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;


@end
