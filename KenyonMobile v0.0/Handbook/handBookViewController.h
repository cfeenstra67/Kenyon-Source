//
//  handBookViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/28/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Handbook.h"
#import "ViewController.h"

@interface handBookViewController : ViewController <UITableViewDelegate, UITableViewDataSource> {
}

@property (weak, nonatomic) NSString* choice;

@property (weak, nonatomic) NSString* topTitle;

@property (strong, nonatomic) IBOutlet UINavigationItem *tableTitle;

- (IBAction)reverseSection:(id)sender;

- (IBAction)swipeRight:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)searchPressed:(id)sender;

@property NSString *searchTitle;

@property (weak, nonatomic) IBOutlet UIView *searchContainer;

-(void)hideSearch;

-(void)searchFor:(NSString*)sectionTitle term:(NSString*)searchTerm;

@end

