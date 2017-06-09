//
//  composeViewController.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postManager.h"
#import "commonUseFunctions.h"

typedef enum composeViewControllerType{
    composeTypePost,
    composeTypeComment
} composeType;

@interface composeViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)xPressed:(id)sender;

@end
