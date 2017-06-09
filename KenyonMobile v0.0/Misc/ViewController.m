//
//  ViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/28/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "ViewController.h"
#import "handBookViewController.h"
#import "athleticsViewController.h"
#import "Handbook.h"
#import "recordIDManager.h"

@interface ViewController () {
    CGFloat shieldX;
    BOOL shouldAnimate;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray<NSString*> *buttons=[[NSMutableArray alloc] init];
    [buttons addObject:@"Handbook"];
    [buttons addObject:@"Map"];
    [buttons addObject:@"Events"];
    [buttons addObject:@"Athletics"];
    [buttons addObject:@"The Wall"];
    _buttonTitles=buttons;
    NSMutableDictionary<NSString*,NSString*> *segues=[[NSMutableDictionary alloc] init];
    [segues setObject:@"toHandbook" forKey:_buttonTitles[0]];
    [segues setObject:@"toMapView" forKey:_buttonTitles[1]];
    [segues setObject:@"toEvents" forKey:_buttonTitles[2]];
    [segues setObject:@"toAthletics" forKey:_buttonTitles[3]];
    [segues setObject:@"toTheWall" forKey:_buttonTitles[4]];
    _segueDict=segues;
    self.view.translatesAutoresizingMaskIntoConstraints=YES;
    //shieldX=_shieldView.frame.origin.x;
    //[self initialAnimation];
    shouldAnimate=YES;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.tableHeaderView = ({UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1 / UIScreen.mainScreen.scale)];
        line.backgroundColor = self.tableView.separatorColor;
        line;
    });
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    shieldX=_shieldView.frame.origin.x;
    if(shouldAnimate)
    {
        [self initialAnimation];
    }
}

-(void)initialAnimation
{
    CGFloat initialTop=_shieldTopDist.constant;
    _tableView.alpha=0;
    _shieldTopDist.constant=(self.view.frame.size.height/2)-(_shieldView.frame.size.height/2);
    [_shieldView setFrame:CGRectMake(shieldX, _shieldTopDist.constant, _shieldView.frame.size.width, _shieldView.frame.size.height)];
    
    [UIView animateKeyframesWithDuration:1.5 delay:1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.4 animations:^{
            _shieldCenterAlignment.constant=initialTop;
            _shieldView.frame=CGRectMake(shieldX, initialTop, _shieldView.frame.size.width, _shieldView.frame.size.height);
            [_shieldView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:1 animations:^{
            _tableView.alpha=1;
        }];
    }completion:NULL];
    _shieldTopDist.constant=initialTop;
    _shieldCenterAlignment.constant=0;
    [_shieldView layoutIfNeeded];
    shouldAnimate=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toHandbook"])
    {
        
    }
    if([[segue identifier] isEqualToString:@"toAthletics"])
    {
        athleticsViewController *vc=[segue destinationViewController];
        vc.rssURL=[NSURL URLWithString:@"http://athletics.kenyon.edu/calendar.ashx/calendar.rss?sport_id=&han="];
        vc.topTitle=@"Upcoming";
        
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue*)segue {
    
}

#pragma table function

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buttonTitles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *new=[tableView dequeueReusableCellWithIdentifier:@"button"];
    new.textLabel.text=[_buttonTitles objectAtIndex:indexPath.row];
    new.textLabel.font=[UIFont boldSystemFontOfSize:24];
    new.textLabel.textAlignment=NSTextAlignmentCenter;
    [new setSeparatorInset:UIEdgeInsetsZero];
    [new setLayoutMargins:UIEdgeInsetsZero];
    return new;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[_segueDict objectForKey:[_buttonTitles objectAtIndex:indexPath.row]] sender:self];
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return ((tableView.bounds.size.height-1)/_buttonTitles.count);
}

@end











