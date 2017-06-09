//
//  wallViewController.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postManager.h"
#import "segmentedLabel.h"

@interface wallViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, postManagerDelegate>

- (IBAction)backPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)newPost:(id)sender;

@end
