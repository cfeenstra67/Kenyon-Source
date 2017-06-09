//
//  commentsViewController.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/2/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "commentsViewController.h"

@interface commentsViewController (){
    NSArray<wallPostComment*>* comments;
    
    UIView *loadingView;
    
    BOOL hasLoaded;
    
    void (^add10Comments)(commentsViewController* contr);
    
    UIFont *titleFont;
    UIFont *font;
    UIFont *smallFont;
    
    CGSize contentSizeBeforeKeyboard;
    
    CGRect keyboardFrame;
    
    UIView *commentAddView;
    UITextField *field;
    
    BOOL keyboardShowing;
}

@end

@implementation commentsViewController

- (void)viewDidLoad {
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    keyboardFrame=CGRectZero;
    keyboardShowing=NO;
    titleFont=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    smallFont=[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    CGFloat commentAddheight=32.0f+font.lineHeight;
    commentAddView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-commentAddheight, self.view.frame.size.width, commentAddheight)];
    CALayer *background=[CALayer layer];
    [background setFrame:commentAddView.bounds];
    [background setBackgroundColor:[UIColor blackColor].CGColor];
    [background setOpacity:.5];
    [commentAddView.layer addSublayer:background];
    [commentAddView setBackgroundColor:[UIColor clearColor]];
    CGFloat margin=8.0f;
    field=[[UITextField alloc] initWithFrame:CGRectMake(margin, margin, self.view.frame.size.width-margin*2, commentAddheight-margin*2)];
    [field setFont:font];
    [field setBackgroundColor:[UIColor whiteColor]];
    [field.layer setCornerRadius:commentAddheight/2-margin];
    field.delegate=self;
    [field addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventTouchDown];
    UIView *padding=[[UIView alloc] initWithFrame:CGRectMake(0, 0, (commentAddheight-margin*2)/3, commentAddheight)];
    field.leftView=padding;
    field.leftViewMode=UITextFieldViewModeAlways;
    field.placeholder=@"Add Comment...";
    
    
    padding=[[UIView alloc] initWithFrame:CGRectMake(0, 0, (commentAddheight-2*margin)/4, commentAddheight)];
    field.rightView=[padding copyView];
    field.rightViewMode=UITextFieldViewModeAlways;
    
    [commentAddView addSubview:field];
    [_tableView setAllowsSelection:NO];
    [_tableView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *ap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTouched:)];
    [_tableView addGestureRecognizer:ap];
    
    add10Comments=^(commentsViewController *contr){
        NSInteger num=1;
        __block NSInteger count=0;
        for(NSInteger i=0; i<num; i++)
        {
            [[postManager shared] publishCommentWithString:[NSString stringWithFormat:@"%@",[NSDate date]] post:contr.originPost completion:^{
                count++;
            }];
        }
        while(count<num)
        {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
        }
    };
    [super viewDidLoad];
    comments=nil;
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(IBAction)tableTouched:(id)sender
{
    if([field canResignFirstResponder])
    {
        [field resignFirstResponder];
        [field endEditing:YES];
    }
}

-(UIView*)inputAccessoryView
{
    return commentAddView;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    if([[UIApplication sharedApplication] applicationState]!=UIApplicationStateActive)
    {
        return;
    }
    NSDictionary *keyboardInfo=[notification userInfo];
    NSValue *keyboardFrameBegin=[keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect=[keyboardFrameBegin CGRectValue];
    if(keyboardFrameBeginRect.size.height==commentAddView.frame.size.height)
    {
        return;
    }
    keyboardFrame=keyboardFrameBeginRect;
    keyboardShowing=YES;
    [self moveTableViewUp];
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    if([[UIApplication sharedApplication] applicationState]!=UIApplicationStateActive)
    {
        return;
    }
    keyboardShowing=NO;
    [self moveTableViewDown];
}

-(void)moveTableViewUp
{
    [self moveTableViewBottomUpBy:keyboardFrame.size.height-commentAddView.frame.size.height animatedFrame:YES];
}

-(void)moveTableViewDown
{
    [self moveTableViewBottomUpBy:-keyboardFrame.size.height+commentAddView.frame.size.height animatedFrame:YES];
}

-(void)moveTableViewBottomUpBy:(CGFloat)value animatedFrame:(BOOL)animated
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if(!animated)
        {
            [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-value)];
            if(comments.count>0)
            {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:comments.count] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        else
        {
            [UIView animateWithDuration:.25 animations:^{
                [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-value)];
         } completion:^(BOOL finished){
             if(comments.count>0)
             {
                 [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:comments.count] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
        }];
        }
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(field.frame.size.width-field.frame.size.height+field.frame.origin.x, field.frame.origin.y, field.frame.size.height, field.frame.size.height)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.layer setCornerRadius:button.frame.size.height/2];
    UIImage *back=[UIImage imageNamed:@"backButton.png"];
    [button setImage:back forState:UIControlStateNormal];
    [button.layer setAffineTransform:CGAffineTransformMakeScale(-1, 1)];
    [button addTarget:self action:@selector(publishCommentPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setAlpha:0];
    CGRect newFieldFrame=CGRectMake(field.frame.origin.x, field.frame.origin.y, field.frame.size.width-field.frame.origin.x-field.frame.size.height, field.frame.size.height);
    [commentAddView addSubview:button];
    [UIView animateWithDuration:.4 animations:^{
        [field setFrame:newFieldFrame];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.1 animations:^{
            [button setAlpha:1.0f];
        }];
        
    }];
}

-(IBAction)publishCommentPressed:(id)sender
{
    [self tableTouched:nil];
    [self createLoadingView];
    __block BOOL doneFlag=NO;
    NSString *content=field.text;
    [[postManager shared] publishCommentWithString:content post:_originPost completion:^{
        doneFlag=YES;
    }];
    field.text=@"";
    while(!doneFlag)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
    wallPostComment *comm=[[wallPostComment alloc] initWithContent:content date:[NSDate date] wallPost:_originPost];
    NSMutableArray *mut=[NSMutableArray arrayWithArray:comments];
    [mut addObject:comm];
    comments=[NSArray arrayWithArray:mut];
    [_tableView reloadData];
    [self removeLoadingView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    UIButton *button;
    for(UIView *view in commentAddView.subviews)
    {
        if(view.class==[UIButton class])
        {
            button=(UIButton*)view;
            break;
        }
    }
    CGRect newFieldFrame=CGRectMake(field.frame.origin.x, field.frame.origin.y, button.frame.origin.x+button.frame.size.width-field.frame.origin.x, field.frame.size.height);
    
    [UIView animateWithDuration:.1 animations:^{
        [button setAlpha:0.0f];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.4 animations:^{
            [field setFrame:newFieldFrame];
        }];
        [button removeFromSuperview];
    }];
    
}

-(void)setOriginPost:(wallPost *)originPost
{
    NSLog(@"set origin post, %@",originPost.myRecordID.recordID.recordName);
    _originPost=originPost;
    NSLog(@"has been set, %@",_originPost.myRecordID.recordID.recordName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    comments=nil;
    [super viewWillAppear:animated];
    if(comments==nil)
    {
        [self createLoadingView];
    }
}

-(void)createLoadingView
{
    [self.view setUserInteractionEnabled:NO];
    CGFloat h=(self.view.frame.size.width/2)/1.618;
    UIView *veView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-h/2, self.view.frame.size.height/2-h/2, h, h)];
    [veView setBackgroundColor:[UIColor grayColor]];
    [veView setAlpha:0.5f];
    [veView.layer setCornerRadius:12];
    [veView.layer setMasksToBounds:YES];
    
    [veView setUserInteractionEnabled:NO];
    CGFloat dimension=128;
    UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(veView.frame.size.width/2-dimension/2, veView.frame.size.height/2-dimension/2, dimension, dimension)];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [veView addSubview:indicator];
    loadingView=veView;
    [self.view addSubview:loadingView];
    [indicator startAnimating];
}

-(void)removeLoadingView
{
    for(UIView *v in loadingView.subviews)
    {
        if([v class]==[UIActivityIndicatorView class])
        {
            [(UIActivityIndicatorView*)v stopAnimating];
        }
    }
    [UIView animateWithDuration:.25 animations:^{
        [loadingView setAlpha:0.0f];
    } completion:^(BOOL finished){
        [loadingView removeFromSuperview];
        loadingView=nil;
        [self.view setUserInteractionEnabled:YES];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(comments==nil)
    {
        [self fetch];
        [self removeLoadingView];
        hasLoaded=YES;
        [_tableView reloadData];
    }
    [super viewDidAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)fetch
{
    __block BOOL doneFlag=NO;
    comments=[[NSArray alloc] init];
    [[postManager shared] getCommentsForPost:_originPost completion:^(NSArray<wallPostComment*>*coms){
        comments=[NSArray arrayWithArray:coms];
        NSLog(@"%ld comments",(long)coms.count);
        doneFlag=YES;
    }];
    while (!doneFlag) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
    }
    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(hasLoaded)
    {
        return comments.count+1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(indexPath.section==0)
    {
        [cell.textLabel setText:_originPost.content];
        [cell.textLabel setFont:titleFont];
        [cell.detailTextLabel setText:[_originPost dateString]];
    }
    else
    {
        NSString *temp=comments[indexPath.section-1].content;
        [cell.textLabel setText:temp];
        [cell.textLabel setFont:font];
        [cell.detailTextLabel setText:comments[indexPath.section-1].dateString];
    }
    cell.textLabel.numberOfLines=0;
    
    [cell.detailTextLabel setFont:smallFont];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    return cell;
}

-(IBAction)textFieldTapped:(UITextField*)field
{
    
    //[commentAddView setHidden:YES];
    //[field becomeFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        NSAttributedString *atr=[[NSAttributedString alloc] initWithString:_originPost.content attributes:[NSDictionary dictionaryWithObject:titleFont forKey:NSFontAttributeName]];
        NSInteger numberOfLines=ceil((atr.size.height*atr.size.width)/(_tableView.bounds.size.width-16)/font.lineHeight);
        return numberOfLines*font.lineHeight+smallFont.lineHeight+24;
    }
    else if(indexPath.section<=comments.count)
    {
        NSString *temp=comments[indexPath.section-1].content;
        NSAttributedString *atr=[[NSAttributedString alloc] initWithString:temp attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
        NSInteger numberOfLines=ceil((atr.size.height*atr.size.width)/(_tableView.bounds.size.width-16)/font.lineHeight);
        return numberOfLines*font.lineHeight+smallFont.lineHeight+24;
    }
    else
    {
    }
    return 44.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0f)];
    [footer setBackgroundColor:[UIColor blackColor]];
    return footer;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self tableView:tableView viewForFooterInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}


- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
