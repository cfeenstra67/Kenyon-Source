//
//  navInfoViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/30/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sectionViewController.h"

@interface navInfoViewController : sectionViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate> {
    BOOL wasSelected;
}

/*@property (weak, nonatomic) IBOutlet UILabel *SectionTitle;

@property (strong, nonatomic) NSURL* handbookPath;

@property (strong, nonatomic) NSString* section;

@property (weak, nonatomic) IBOutlet UITextView *sectionView;*/

@property (strong, nonatomic) NSArray* miniSections;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

-(void)configureView;

- (IBAction)swipeLeft:(id)sender;

@end
