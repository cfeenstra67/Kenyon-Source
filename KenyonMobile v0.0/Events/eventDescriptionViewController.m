//
//  eventDescriptionViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/10/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "eventDescriptionViewController.h"
#import "UIImageView+WebCache.h"
#import "localSettings.h"
#import "commonUseFunctions.h"
#import <EventKit/EventKit.h>


@interface eventDescriptionViewController (){
    UIScrollView *fullView;
    UIScrollView *swipeView;
}
@end

@implementation eventDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _date=self.navigationItem;
    // Do any additional setup after loading the view.
    [self getFullDate];
    CGFloat margin=8;
    _titleView=[[UILabel alloc] initWithFrame:CGRectMake(margin, margin, self.view.frame.size.width-margin*2, [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2].lineHeight+16)];
    _titleView.text=_titleText;
    _titleView.numberOfLines=0;
    _titleView.lineBreakMode=NSLineBreakByWordWrapping;
    _titleView.textAlignment=NSTextAlignmentCenter;
    [_titleView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    CGSize titleSize=[_titleText sizeWithAttributes:[NSDictionary dictionaryWithObject:_titleView.font forKey:NSFontAttributeName]];
    NSInteger numberOfLines=ceil(titleSize.width*titleSize.height/_titleView.frame.size.width/_titleView.font.lineHeight);
    [_titleView setFrame:CGRectMake(_titleView.frame.origin.x, _titleView.frame.origin.y, _titleView.frame.size.width, 16+_titleView.font.lineHeight*numberOfLines)];
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, _titleView.frame.size.width, self.view.frame.size.height/3)];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(margin, _imageView.frame.origin.y+_imageView.frame.size.height+margin, _titleView.frame.size.width, 0)];
    _textView.text=_descriptionText;
    _textView.font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [_textView setFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, _textView.frame.size.width*_textView.contentSize.height/_textView.contentSize.width)];
    _textView.scrollEnabled=NO;
    _textView.editable=NO;
    
    CGFloat buttonHeight=64;
    __block UIButton *addToCalendar;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_image] completed:^(UIImage *image, NSError *error, SDImageCacheType type, NSURL *url){
        [_imageView setFrame:CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.width*image.size.height/image.size.width)];
        [_textView setFrame:CGRectMake(_textView.frame.origin.x, _imageView.frame.origin.y+_imageView.frame.size.height, _textView.frame.size.width, _textView.frame.size.height)];
        addToCalendar=[[UIButton alloc] initWithFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y+_textView.frame.size.height+margin, _textView.frame.size.width, buttonHeight)];
        [addToCalendar setTitle:@"Add to Calendar" forState:UIControlStateNormal];
        [addToCalendar setBackgroundColor:[UIColor blackColor]];
        [addToCalendar.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [addToCalendar addTarget:self action:@selector(addThisEventToCalendar:) forControlEvents:UIControlEventTouchUpInside];
        
        _date.title=_dateText;
        [_titleView setFrame:CGRectMake(_titleView.frame.origin.x, 0, _titleView.frame.size.width, _titleView.frame.size.height)];
        CGFloat navBarHeight=self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
        fullView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, _titleView.frame.origin.y+_titleView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-_titleView.frame.origin.y-_titleView.frame.size.height-navBarHeight)];
        [fullView setContentSize:CGSizeMake(self.view.frame.size.width, addToCalendar.frame.origin.y+addToCalendar.frame.size.height+margin)];
        [fullView addSubview:_textView];
        [fullView addSubview:_imageView];
        [fullView addSubview:addToCalendar];
        [self.view addSubview:fullView];
        [self.view addSubview:_titleView];
    }];
    
}

-(void)createScroller
{
    swipeView=[[UIScrollView alloc] initWithFrame:self.view.frame];
    [swipeView setContentSize:CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height)];
    UIView *myPage=[[UIView alloc] initWithFrame:self.view.frame];
    [myPage setBackgroundColor:self.view.backgroundColor];
    for(UIView *sub in self.view.subviews)
    {
        [sub removeFromSuperview];
        [myPage addSubview:sub];
    }
    [myPage setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [swipeView setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
    [swipeView addSubview:myPage];
    [swipeView setPagingEnabled:YES];
    [swipeView setScrollEnabled:YES];
    [self.view addSubview:swipeView];
}

-(void)getFullDate
{
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSDateComponents *rn=[cal components:(NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:_myDate];
    _myDate=[cal dateFromComponents:rn];
    NSMutableArray<NSString*> *comps=[NSMutableArray arrayWithArray:[_titleText componentsSeparatedByString:@":"]];
    if(comps.count<2)
    {
        return;
    }
    NSString *beforeFirst=comps.firstObject;
    NSString *afterFirst=comps[1];
    NSArray<NSString*> *moreComps=[afterFirst componentsSeparatedByString:@" "];
    if(moreComps.count<2)
    {
        return;
    }
    BOOL isPM=NO;
    if([moreComps[1] isEqualToString:@"PM"])
    {
        isPM=YES;
    }
    if(beforeFirst.length>2)
    {
        beforeFirst=[beforeFirst substringFromIndex:beforeFirst.length-2];
    }
    NSInteger hour=beforeFirst.integerValue;
    NSInteger minute=moreComps.firstObject.integerValue;
    if(isPM)
    {
        hour+=12;
    }
    rn.hour=hour;
    rn.minute=minute;
    NSDate *new=[cal dateFromComponents:rn];
    _myDate=new;
}

-(IBAction)addThisEventToCalendar:(id)sender
{
    NSString *currentTitleText=_titleText;
    if([currentTitleText rangeOfString:@":"].location==1)
    {
        currentTitleText=[currentTitleText substringFromIndex:9];
    }
    else
    {
        currentTitleText=[currentTitleText substringFromIndex:10];
    }
    NSLog(@"yep");
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = currentTitleText;
        event.startDate = _myDate; //today
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        if(!err)
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Added" message:@"Event was added to your calendar successfully." preferredStyle:UIAlertControllerStyleAlert];
            [alert targetForAction:@selector(dismissAlert:) withSender:alert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
            }]];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            [alert.view setTintColor:[UIColor blackColor]];
        }
        else
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Error" message:@"An error occurred while adding the event to your calendar." preferredStyle:UIAlertControllerStyleAlert];
            [alert targetForAction:@selector(dismissAlert:) withSender:alert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
            }]];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            [alert.view setTintColor:[UIColor blackColor]];
        }
    }];
}

-(IBAction)dismissAlert:(UIAlertController*)alert
{
    [self dismissAlert:alert];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
