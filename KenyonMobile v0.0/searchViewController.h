//
//  searchViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/12/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property NSInteger tableBack;

- (IBAction)closeSearch:(id)sender;

@property (strong, nonatomic) NSDictionary *handbook;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
