//
//  eventsViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/8/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface eventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)configureView;

@property (strong, nonatomic) NSArray* types;

@property NSDictionary <NSString*, NSArray*> *dateDict;

@property (strong, nonatomic) NSArray *sortedSections;

@property (strong, nonatomic) NSArray *showSections;

-(void)seperateEvents;

-(NSDictionary*)itemForTitle:(NSString*)title date:(NSString*)date;

-(NSString*)intoNumber:(NSString*)dateString;

-(NSString*)fromNumber:(NSString*)dateNum;

- (IBAction)refresh:(id)sender;

- (IBAction)backPressed:(id)sender;

@end
