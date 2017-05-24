//
//  composeViewController.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "composeViewController.h"

@interface composeViewController (){
    CGRect keyboardFrame;
    
    UIView *keyboardHeader;
    
    UILabel *charactersLabel;
    
    NSInteger maxCharacters;
    
    
}

@end

@implementation composeViewController

- (void)viewDidLoad {
    maxCharacters=200;
    [super viewDidLoad];
    [self setKeyboardHeader];
    [self registerForKeyboardNotifications];
    keyboardFrame=CGRectZero;
    [_textView setInputAccessoryView:keyboardHeader];
    [_textView setText:@""];
    [_textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    [_textView becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)setKeyboardHeader
{
    CGFloat headerHeight=44;
    keyboardHeader=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, headerHeight)];
    [keyboardHeader setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    charactersLabel=[[UILabel alloc] initWithFrame:keyboardHeader.bounds];
    [charactersLabel setTextAlignment:NSTextAlignmentCenter];
    [charactersLabel setText:[NSString stringWithFormat:@"%ld character(s) remaining",(long)maxCharacters]];
    [keyboardHeader addSubview:charactersLabel];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *keyboardInfo=[notification userInfo];
    NSValue *keyboardFrameBegin=[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect=[keyboardFrameBegin CGRectValue];
    keyboardFrame=keyboardFrameBeginRect;
    [self setKeyboardHeader];
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [_textView endEditing:YES];
}


//TextviewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    if([textView.text isEqualToString:@""])
    {
        return;
    }
    if([[textView.text substringFromIndex:textView.text.length-1] isEqualToString:@"\n"])
    {
        [textView setText:[textView.text substringToIndex:textView.text.length-1]];
        [self shouldPublishCurrentPost];
        return;
        
    }
    if(textView.text.length==141)
    {
        [textView setText:[textView.text substringToIndex:textView.text.length-1]];
    }
    for(UIView *v in textView.inputAccessoryView.subviews)
    {
        if([v class]==[UILabel class])
        {
            [(UILabel*)v setText:[NSString stringWithFormat:@"%ld character(s) remaining",(long)(maxCharacters-textView.text.length)]];
            
        }
    }
}

-(void)shouldPublishCurrentPost
{
    wallPost *new=[[wallPost alloc] initWithContent:_textView.text date:[NSDate date]];
    [[postManager shared] publishPost:new completion:^{
        
    }];
    [self xPressed:nil];
}

-(wallPost*)postForCurrentState
{
    return [[wallPost alloc] initWithContent:_textView.text date:[NSDate date]];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (IBAction)xPressed:(id)sender {
    [self performSegueWithIdentifier:@"stopComposing" sender:self];
}
@end
