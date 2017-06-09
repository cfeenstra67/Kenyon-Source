//
//  athleticsViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/6/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "athleticsViewController.h"
#import "UIImageView+WebCache.h"
#import "gameTableViewCell.h"
#import "sportSelectionViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface athleticsViewController () {
    NSXMLParser *parser;
    NSMutableArray <NSDictionary*> *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *date;
    NSString *element;
    
    UIView *loadingView;
    
    
    BOOL hasLoaded;
}

@end

@implementation athleticsViewController

- (void)viewDidLoad {
    hasLoaded=NO;
    // Do any additional setup after loading the view from its nib.
    feeds = [[NSMutableArray alloc] init];
    //NSURL *url = [NSURL URLWithString:@"http://athletics.kenyon.edu/calendar.ashx/calendar.rss?sport_id=9"];
    [_navBar setTitle:_topTitle];
    [super viewDidLoad];
    
    _tableView.layoutMargins=UIEdgeInsetsZero;
    _tableView.separatorInset=UIEdgeInsetsZero;
    _tableView.rowHeight=44;
    [self.view layoutIfNeeded];
    
    [_tableView setRefreshControl:[[UIRefreshControl alloc] init]];
    [_tableView.refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!hasLoaded)
    {
        [self createLoadingView];
    }
    [_tableView setFrame:self.view.bounds];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(!hasLoaded)
    {
        [super viewDidAppear:animated];
        [self configureView];
        [self removeLoadingView];
        hasLoaded=YES;
    }
}

-(void)createLoadingView
{
    CGFloat h=(self.view.frame.size.width/2)/1.618;
    UIView *veView=[[UIView alloc] initWithFrame:CGRectMake(_tableView.frame.size.width/2-h/2, _tableView.frame.size.height/2-h/2, h, h)];
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
    [_tableView addSubview:loadingView];
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
    }];
    
}

-(IBAction)pullToRefresh:(UIRefreshControl*)ref
{
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.75]];
    [self refresh:nil];
    [ref endRefreshing];
}



-(void)configureView
{
    feeds = [[NSMutableArray alloc] init];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:_rssURL];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    __block BOOL doneFlag=NO;
    NSBlockOperation *op=[NSBlockOperation blockOperationWithBlock:^{
        [parser parse];
    }];
    [op setCompletionBlock:^{
        [self seperateEvents];
        doneFlag=YES;
    }];
    [[NSOperationQueue new] addOperation:op];
    while(!doneFlag)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05f]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });/*
    doneFlag=NO;
    NSBlockOperation *o=[NSBlockOperation blockOperationWithBlock:^{
        [_tableView reloadData];
        [_tableView layoutIfNeeded];
    }];
    [o setCompletionBlock:^{
        doneFlag=YES;
    }];
    [[NSOperationQueue mainQueue] addOperation:o];
    while(!doneFlag)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05f]];
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if(![athleticsViewController hasConnectivity])
    {
        [self presentViewController:alert animated:YES completion:nil];
    }
}*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View functions

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_sectionDates.count==0)
    {
        return 0;
    }
    //NSLog(@"%lu objects in section %@",[_dateDict objectForKey:[_sectionDates objectAtIndex:section]].count,[_sectionDates objectAtIndex:section]);
    return [_dateDict objectForKey:[_sectionDates objectAtIndex:section]].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_sectionDates.count==0)
    {
        return 0;
    }
    return [_dateDict allKeys].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_sectionDates.count==0)
    {
        UITableViewCell *new=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noResults"];
        new.textLabel.text=@"No Results";
        [new.textLabel setTextColor:[UIColor grayColor]];
        [new.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
        new.textLabel.textAlignment=NSTextAlignmentCenter;
        return new;
    }
    gameTableViewCell *newCell=[tableView dequeueReusableCellWithIdentifier:@"gameInfo"];
    //UITableViewCell *new=[tableView dequeueReusableCellWithIdentifier:@"gameInfo"];
    //NSDictionary *temp=[feeds objectAtIndex:indexPath.row];
    NSDictionary *temp=[[_dateDict objectForKey:[_sectionDates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    //[[new textLabel] setText:[temp objectForKey:@"title"]];
    //return new;
    
    [newCell fillCell:[temp objectForKey:@"title"] startTime:[temp objectForKey:@"date"] imageLink:[temp objectForKey:@"link"]];
    if(newCell.dateLabel.text==nil)
    {
        //newCell.scoreWidth.constant=0;
        CGFloat initail=newCell.scoreLabel.bounds.size.width;
        [newCell.scoreLabel setFrame:CGRectMake(newCell.scoreLabel.bounds.origin.x+newCell.scoreWidth.constant, newCell.scoreLabel.bounds.origin.y, 0, newCell.scoreLabel.bounds.size.height)];
        newCell.scoreWidth.constant=0;
        [newCell.versusLabel setFrame:CGRectMake(newCell.versusLabel.bounds.origin.x, newCell.versusLabel.bounds.origin.y, initail, newCell.bounds.size.height)];
        [newCell updateConstraints];
        [newCell layoutIfNeeded];
        
    }
    
    
    return newCell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_sectionDates.count==0)
    {
        return nil;
    }
    UIFont *font=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    CGFloat tSize=font.lineHeight;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tSize+10)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, tSize)];
    [label setFont:font];
    [label setTextAlignment:NSTextAlignmentCenter];
    NSString *string =[self dateFormat:[_sectionDates objectAtIndex:section]];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3].lineHeight+10;
}

#pragma mark - Parser

-(void)parser:(NSXMLParser*)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict
{
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        date    = [[NSMutableString alloc] init];
        
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:date forKey:@"date"];
        
        [feeds addObject:[item copy]];
        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string
{
    /*if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }*/
    
    if([element isEqualToString:@"description"])
    {
        [title appendString:string];
    }
    else if([element isEqualToString:@"s:localstartdate"])
    {
        [date appendString:string];
    }
    else if([element isEqualToString:@"s:opponentlogo"])
    {
        [link appendString:string];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

#pragma mark rewind segue

-(IBAction)prepareForUnwind:(UIStoryboardSegue*)segue
{
    //NSLog(@"called");
    if([[segue identifier] isEqualToString:@"chooseSport"])
    {
        
    sportSelectionViewController *from=segue.sourceViewController;
    _rssURL=from.sendSport.sportURL;
    //NSLog([_rssURL absoluteString]);
    _topTitle=from.sendSport.sportName;
    [self configureView];
    [_tableView reloadData];
    [_navBar setTitle:from.sendSport.sportName];
    //[_tableView setScrollsToTop:YES];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self numberOfSectionsInTableView:tableView]>0)
    {
        return 80;
    }
    return 64;
}

#pragma mark parseIt

-(void)parseIt:(NSURL *)url
{
    
}

#pragma mark status bar style

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark parse events into sections

-(void)seperateEvents
{
    NSMutableDictionary<NSString*,NSArray<NSDictionary*>*> *temp=[[NSMutableDictionary alloc] init];
    NSMutableArray<NSString*> *sortDates=[[NSMutableArray alloc] init];
    NSInteger index=0;
    while(index<feeds.count)
    {
        NSMutableArray<NSDictionary*> *oneDay=[[NSMutableArray alloc] init];
        NSString *day=[[NSString alloc] initWithString:[[[[feeds objectAtIndex:index] objectForKey:@"date"] componentsSeparatedByString:@"T"] firstObject]];
        NSString *dayCounter=[[NSString alloc] initWithString:day];
        while([dayCounter isEqualToString:day]&(index<feeds.count))
        {
            [oneDay addObject:[feeds objectAtIndex:index]];
            
            index++;
            if(index>=feeds.count)
            {
                break;
            }
            else
            {
                dayCounter=[[[[feeds objectAtIndex:index] objectForKey:@"date"] componentsSeparatedByString:@"T"] firstObject];
            }
            
        }
        
        [temp setObject:oneDay forKey:day];
        [sortDates addObject:day];
    }
    _sectionDates=sortDates;
    _dateDict=temp;
}

#pragma mark change date string to readable form

-(NSString*)dateFormat:(NSString*)initialDate
{
    NSArray <NSString*> *components=[initialDate componentsSeparatedByString:@"-"];
    NSMutableDictionary *monthLookup=[[NSMutableDictionary alloc] init];
    [monthLookup setObject:@"01" forKey:@"Jan"];
    [monthLookup setObject:@"02" forKey:@"Feb"];
    [monthLookup setObject:@"03" forKey:@"Mar"];
    [monthLookup setObject:@"04" forKey:@"Apr"];
    [monthLookup setObject:@"05" forKey:@"May"];
    [monthLookup setObject:@"06" forKey:@"Jun"];
    [monthLookup setObject:@"07" forKey:@"Jul"];
    [monthLookup setObject:@"08" forKey:@"Aug"];
    [monthLookup setObject:@"09" forKey:@"Sep"];
    [monthLookup setObject:@"10" forKey:@"Oct"];
    [monthLookup setObject:@"11" forKey:@"Nov"];
    [monthLookup setObject:@"12" forKey:@"Dec"];
    NSString *month=[[monthLookup allKeysForObject:components[1]] firstObject];
    NSString *day=components[2];
    if([[day substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"])
    {
        day=[day substringWithRange:NSMakeRange(1, 1)];
    }
    return [NSString stringWithFormat:@"%@ %@, %@",month,day,components[0]];
    
}

- (IBAction)refresh:(id)sender {
    [self configureView];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
