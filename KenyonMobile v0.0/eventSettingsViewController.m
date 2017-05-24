//
//  eventSettingsViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/14/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "eventSettingsViewController.h"
#import "eventsViewController.h"

@interface eventSettingsViewController () {
    NSDate *initial;
    NSDate *end;
    NSDate *picked;
    CGFloat initialViewHeight;
    BOOL loaded;
    NSArray <NSString*> *allCategories;
    BOOL hitOnce;
}

@end

@implementation eventSettingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _startDatePicker.datePickerMode=UIDatePickerModeDate;
    [_pickerView setUserInteractionEnabled:YES];
    [_pickerView becomeFirstResponder];
    [self setTapGesture:_tapGesture];
    //[_pickerView addGestureRecognizer:_tapGesture];
    loaded=FALSE;
    [self getStartEnd];
    
    NSMutableArray <NSString*> *setShow=[[NSMutableArray alloc] init];
    [setShow addObject:@"Arts"];
    [setShow addObject:@"Academic Calendar"];
    [setShow addObject:@"Athletics"];
    [setShow addObject:@"Career Development"];
    [setShow addObject:@"Community Service"];
    [setShow addObject:@"Diversity Related"];
    [setShow addObject:@"Hillel"];
    [setShow addObject:@"Lectures"];
    [setShow addObject:@"Meetings"];
    [setShow addObject:@"Memorial"];
    [setShow addObject:@"Recreation"];
    [setShow addObject:@"Sustainability"];
    [setShow addObject:@"Other"];
    allCategories=setShow;
    _isOn=[[NSMutableDictionary alloc] initWithDictionary: _wasOn];
    [_tableView reloadData];
    
    [_longPress setDelegate:self];
    [_longPress setMinimumPressDuration:.5];
    [_longPress setNumberOfTapsRequired:1];
    [_longPress setAllowableMovement:100];
    [_longPress setNumberOfTouchesRequired:1];
    //[_tableView becomeFirstResponder];
    hitOnce=NO;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(!loaded)
    {
    initialViewHeight=_pickerViewHeight.constant;
        loaded=TRUE;}
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

#pragma mark - table view functions

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allCategories.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *new=[tableView dequeueReusableCellWithIdentifier:@"category"];
    NSString *cat=[allCategories objectAtIndex:indexPath.row];
    if([[_isOn objectForKey:cat] isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        new.accessoryType=UITableViewCellAccessoryNone;
    }
    else
    {
        new.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    //selectOne=cat;
    //[new addGestureRecognizer:add];
    [new.accessoryView setTintColor:[UIColor colorWithRed:.458824 green:.231373 blue:.741176 alpha:1]];
    [new.accessoryView tintColorDidChange];
    new.textLabel.text=cat;
    [new setAlpha:1];
    [new setHidden:NO];
    [new setLayoutMargins:UIEdgeInsetsZero];
    [new setSeparatorInset:UIEdgeInsetsZero];
    return new;
}

-(IBAction)selectOnly:(UILongPressGestureRecognizer*)sender
{
    if(hitOnce)
    {
        hitOnce=NO;
        return;
    }
    hitOnce=YES;
    CGPoint p=[sender locationInView:_tableView];
    NSIndexPath *path=[_tableView indexPathForRowAtPoint:p];
    NSString *select=[allCategories objectAtIndex:path.row];
    NSInteger count=0;
    for(NSString *cat in [_isOn allKeys])
    {
        if(![cat isEqualToString:select])
        {
            if([[_isOn objectForKey:cat] isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                count++;
            }
            [_isOn setObject:[NSNumber numberWithInt:0] forKey:cat];
        }
        else
        {
            [_isOn setObject:[NSNumber numberWithInt:1] forKey:cat];
        }
    }
    if(count>=[_isOn allKeys].count-1)
    {
        for(NSString *cat in [_isOn allKeys])
        {
            [_isOn setObject:[NSNumber numberWithInt:1] forKey:cat];
        }
    }
    [_tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cat=[allCategories objectAtIndex:indexPath.row];
    if([[_isOn objectForKey:cat] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [_isOn setObject:[NSNumber numberWithInt:0] forKey:cat];
        [_tableView reloadData];
    }
    else
    {
        [_isOn setObject:[NSNumber numberWithInt:1] forKey:cat];
        [_tableView reloadData];
    }
    
}

- (IBAction)tappedPicker:(id)sender {
    if(_pickerViewHeight.constant==initialViewHeight)
    {
        [UIView transitionWithView:_pickerView duration:.4 options:UIViewAnimationOptionCurveLinear animations:^{
            _pickerViewHeight.constant=self.view.frame.size.height*.5;
            [self.view layoutIfNeeded];
        }completion:NULL];
    }
    else
    {
        [UIView transitionWithView:_pickerView duration:.4 options:UIViewAnimationOptionCurveLinear animations:^{
            _pickerViewHeight.constant=initialViewHeight;
            [self.view layoutIfNeeded];
        }completion:NULL];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return TRUE;
}

-(void)getStartEnd
{
    NSMutableDictionary *fullMonths=[[NSMutableDictionary alloc] init];
    [fullMonths setObject:@"January" forKey:@"Jan"];
    [fullMonths setObject:@"February" forKey:@"Feb"];
    [fullMonths setObject:@"March" forKey:@"Mar"];
    [fullMonths setObject:@"April" forKey:@"Apr"];
    [fullMonths setObject:@"May" forKey:@"May"];
    [fullMonths setObject:@"June" forKey:@"Jun"];
    [fullMonths setObject:@"July" forKey:@"Jul"];
    [fullMonths setObject:@"August" forKey:@"Aug"];
    [fullMonths setObject:@"September" forKey:@"Sep"];
    [fullMonths setObject:@"October" forKey:@"Oct"];
    [fullMonths setObject:@"November" forKey:@"Nov"];
    [fullMonths setObject:@"December" forKey:@"Dec"];
    NSString *startDate=_initialDate;
    /*if(_initialDate!=nil) {
        startDate=_initialDate;}
    else
    {
        startDate=nil;
    }*/
    NSString *endDate=[_theSections lastObject];
    NSString *monthCode=[[startDate componentsSeparatedByString:@" "] firstObject];
    [startDate stringByReplacingOccurrencesOfString:monthCode withString:[fullMonths objectForKey:monthCode]];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterLongStyle];
    if(startDate!=nil)
    {
        initial=[format dateFromString:startDate];}
    else
    {
        initial=[NSDate date];
    }
    monthCode=[[endDate componentsSeparatedByString:@" "] firstObject];
    [endDate stringByReplacingOccurrencesOfString:monthCode withString:[fullMonths objectForKey:monthCode]];
    end=[format dateFromString:endDate];
    [_startDatePicker setDate:initial];
    initial=[initial earlierDate:[NSDate date]];
    //[_startDatePicker setMinimumDate:initial];
    [_startDatePicker setMaximumDate:end];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    picked=[_startDatePicker date];
    eventsViewController *back=[segue destinationViewController];
    [self reformSections];
    back.showSections=_theSections;
    
}

-(void)reformSections
{
    NSMutableArray *sections=[[NSMutableArray alloc] initWithArray:_theSections];
    for(NSString *date in _theSections)
    {
        NSDate *thisDate=[self dateFromString:date];
        //NSLog(@"%@,%@,%@",[format stringFromDate:thisDate],[format stringFromDate:initial],[format stringFromDate:[thisDate earlierDate:initial]]);
        if(([[thisDate earlierDate:picked] isEqualToDate:thisDate]&![thisDate isEqualToDate:picked])||([[thisDate laterDate:end] isEqualToDate:thisDate]&![thisDate isEqualToDate:end]))
        {
            [sections removeObject:date];
        }
    }
    _theSections=sections;
}

-(NSDate*)dateFromString:(NSString*)string
{
    NSMutableDictionary *fullMonths=[[NSMutableDictionary alloc] init];
    [fullMonths setObject:@"January" forKey:@"Jan"];
    [fullMonths setObject:@"February" forKey:@"Feb"];
    [fullMonths setObject:@"March" forKey:@"Mar"];
    [fullMonths setObject:@"April" forKey:@"Apr"];
    [fullMonths setObject:@"May" forKey:@"May"];
    [fullMonths setObject:@"June" forKey:@"Jun"];
    [fullMonths setObject:@"July" forKey:@"Jul"];
    [fullMonths setObject:@"August" forKey:@"Aug"];
    [fullMonths setObject:@"September" forKey:@"Sep"];
    [fullMonths setObject:@"October" forKey:@"Oct"];
    [fullMonths setObject:@"November" forKey:@"Nov"];
    [fullMonths setObject:@"December" forKey:@"Dec"];
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterLongStyle];
    NSString *monthCode=[[string componentsSeparatedByString:@" "] firstObject];
    NSString *newDate=[string stringByReplacingOccurrencesOfString:monthCode withString:[fullMonths objectForKey:monthCode]];
    return [format dateFromString:newDate];
    //NSLog(@"%@,%@,%@",[format stringFromDate:thisDate]
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
