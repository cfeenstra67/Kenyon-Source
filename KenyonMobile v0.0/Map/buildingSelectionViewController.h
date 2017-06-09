//
//  buildingSelectionViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/11/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface buildingSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <NSString*> *buildingBackup;

@property (strong, nonatomic) NSDictionary <NSString*, NSArray*> *alphabet;

@property (strong, nonatomic) NSString *picked;

@property (strong, nonatomic) NSMutableDictionary<NSString*,NSMutableArray*> *showTable;

@end
