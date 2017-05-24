//
//  commentsViewController.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/2/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "composeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface commentsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) wallPost *originPost;

- (IBAction)backPressed:(id)sender;

@end
