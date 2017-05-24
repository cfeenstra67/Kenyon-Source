//
//  ViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/28/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *appdel;
}

@property (strong, nonatomic) NSDictionary* handbookPath;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <NSString*> *buttonTitles;

@property (strong, nonatomic) NSDictionary <NSString*,NSString*> *segueDict;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shieldTopDist;

@property (weak, nonatomic) IBOutlet UIImageView *shieldView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shieldCenterAlignment;

@end

