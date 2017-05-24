//
//  athleticsViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/6/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface athleticsViewController : UIViewController <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSURL *rssURL;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) NSString *topTitle;

@property (strong, nonatomic) NSDictionary <NSString*,NSArray<NSDictionary*>*> *dateDict;

@property (strong, nonatomic) NSArray<NSString*> *sectionDates;
- (IBAction)refresh:(id)sender;

- (IBAction)backPressed:(id)sender;

-(IBAction)prepareForUnwind:(UIStoryboardSegue*)segue;

@end
