//
//  sectionViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/30/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Handbook.h"
#import "ViewController.h"

@interface sectionViewController : ViewController <UITextViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) NSString* section;

@property (weak, nonatomic) IBOutlet UITextView *sectionView;

-(void)configureView;

@property (weak, nonatomic) IBOutlet UILabel *SectionTitle;

@property (weak, nonatomic) handbook* nav;

- (IBAction)chooseSectionView:(id)sender;

@property (weak, nonatomic) NSString* backSection;

- (IBAction)swipeLeft:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *searchBarView;

- (IBAction)glassButton:(id)sender;

- (IBAction)nextResult:(id)sender;

- (IBAction)prevResult:(id)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSString *searchFor;

@end
