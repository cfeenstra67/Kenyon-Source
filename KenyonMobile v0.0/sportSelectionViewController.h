//
//  sportSelectionViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/7/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface sport : NSObject

@property NSString *sportName;

@property NSURL *sportURL;

-(void)setURL:(NSArray*)sportNames;

@end


@interface sportSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *sports;

@property (strong, nonatomic) sport *sendSport;

@property (strong, nonatomic) NSArray *viewOrder;

-(void)setViewOrder:(NSArray *)sports;

- (IBAction)backPressed:(id)sender;

@end

