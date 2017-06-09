//
//  eventsViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/8/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "eventsViewController.h"
#import "eventTableViewCell.h"
#import "eventDescriptionViewController.h"
#import "eventSettingsViewController.h"
#import "localSettings.h"

@interface eventsViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *date;
    NSString *element;
    NSString *image;
    NSMutableString *description;
    NSArray <NSString*> *showCategories;;
    NSMutableArray <NSString*> *categories;
    NSDictionary *sendItem;
    NSString *sendTitle;
    NSString *sendDate;
    NSDictionary <NSString*,NSNumber*> *isSelected;
    
    UIView *loadingView;
    
    CGFloat minus;
    
    NSDictionary <NSString*, NSArray*> *showDict;
    
    BOOL doneParsing;
    
    BOOL hasLoaded;
}

@end

@implementation eventsViewController


- (void)viewDidLoad {
    hasLoaded=NO;
    [super viewDidLoad];
    loadingView=nil;
    // Do any additional setup after loading the view.
    _tableView.layoutMargins=UIEdgeInsetsZero;
    _tableView.separatorInset=UIEdgeInsetsZero;
    minus=98;
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
    showCategories=setShow;
    [self initIsSelected];
    _showSections=_sortedSections;
    self.view.translatesAutoresizingMaskIntoConstraints=YES;
    showDict=_dateDict;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    
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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!hasLoaded)
    {
        [self pullToRefresh:nil];
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
    [self configureView];
    [self initIsSelected];
    _showSections=_sortedSections;
    showDict=_dateDict;
    [_tableView reloadData];
    [ref endRefreshing];
}

-(void)initIsSelected
{
    NSMutableDictionary *setSelected=[[NSMutableDictionary alloc] init];
    for(NSString *show in showCategories)
    {
        [setSelected setObject:[NSNumber numberWithInt:1] forKey:show];
    }
    isSelected=setSelected;
}

-(void)configureView
{
    feeds = [[NSMutableArray alloc] init];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://calendar.kenyon.edu/calendar.xml"]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    doneParsing=NO;
    NSBlockOperation *op=[NSBlockOperation blockOperationWithBlock:^{
        [parser parse];
    }];
    [[NSOperationQueue new] addOperation:op];
    while(!doneParsing)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05f]];
    }
    [self seperateEvents];
    [self sortSections];
    [self sortEvents];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initIsSelected];
        [_tableView reloadData];
    });
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

#pragma mark - parser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    element = elementName;
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        date    = [[NSMutableString alloc] init];
        description=[[NSMutableString alloc] init];
        categories = [[NSMutableArray alloc] init];
        
    }
    else if([element isEqualToString:@"media:content"])
    {
        image=[attributeDict objectForKey:@"url"];
        //NSLog(@"|%@|",image);
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    //NSLog(@"parsing");
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:date forKey:@"date"];
        if(image!=nil) {
            [item setObject:image forKey:@"image"];
        }
        if(categories.count==0)
        {
            [categories addObject:@"Other"];
        }
        [item setObject:categories forKey:@"categories"];
        [item setObject:[self parseDescription] forKey:@"description"];
        //[item setObject:description forKey:@"description"];
        
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
    
    if([element isEqualToString:@"title"])
    {
        [title appendString:string];
    }
    else if([element isEqualToString:@"dc:date"])
    {
        [date appendString:string];
    }
    else if([element isEqualToString:@"category"])
    {
        [categories addObject:string];
    }
    /*else if([element isEqualToString:@"description"])
    {
        [description appendString:string];
    }*/
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    [description appendString:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
    
    //NSLog(@"%@",description);
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"called");
    doneParsing=YES;
}

#pragma mark table functions

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_showSections.count==0)
    {
        UITableViewCell *new=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noResults"];
        [new setUserInteractionEnabled:NO];
        new.textLabel.text=@"No Results";
        new.textLabel.textAlignment=NSTextAlignmentCenter;
        UIFont *noneFont=[[localSettings shared] objectForKey:@"tableFont"];
        [new.textLabel setFont:noneFont];
        [new.textLabel setTextColor:[UIColor grayColor]];
        [new setSeparatorInset:UIEdgeInsetsZero];
        return new;
    }
    eventTableViewCell *new=[tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    NSString *dateSection=[_showSections objectAtIndex:indexPath.section];
    //NSLog(@"%@",dateSection);
    NSString *eventTitle=[[showDict objectForKey:dateSection] objectAtIndex:indexPath.row];
    NSDictionary *things=[self itemForTitle:eventTitle date:dateSection];
    //NSDictionary *things=[feeds objectAtIndex:indexPath.row];
    NSMutableString *eventListing=[[NSMutableString alloc] init];
    [eventListing appendString:[[things objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    //NSLog(@"first");
    NSString *dateFull=[things objectForKey:@"date"];
    NSArray <NSString*> *seperateTime=[dateFull componentsSeparatedByString:@"T"];
    //NSLog(@"%@",eventListing);
    NSString *startTime=[[seperateTime[1] componentsSeparatedByString:@"-"] firstObject];
    //NSLog(@"second");
    //NSString *endTime=[[seperateTime[1] componentsSeparatedByString:@"-"] objectAtIndex:1];
    
    NSArray<NSString*> *startTimeComponents=[startTime componentsSeparatedByString:@":"];
    //NSArray<NSString*> *endTimeComponents=[endTime componentsSeparatedByString:@":"];
    
    NSString *ap=[[NSString alloc] init];
    NSString *hourString =[startTimeComponents firstObject];
    if([[hourString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"])
    {
        hourString=[hourString substringWithRange:NSMakeRange(1, hourString.length-1)];
    }
    if([hourString intValue]>11)
    {
        if([hourString intValue]>12) {
            hourString=[NSString stringWithFormat:@"%d",[hourString intValue]-12];
        }
        ap=@"PM";
    }
    else if([hourString intValue]==0)
    {
        ap=@"N";
    }
    else
    {
        ap=@"AM";
    }
    NSString *dateString;
    if(![ap isEqualToString:@"N"])
    {
        dateString=[[NSString stringWithFormat:@"%@:%@ %@",hourString,startTimeComponents[1],ap] copy];
    }
    else
    {
        dateString=@"";
    }
    
    NSArray<NSString*> *titleComponents=[eventListing componentsSeparatedByString:@":"];
    eventListing=[[NSMutableString alloc] init];
    NSMutableString *fullTitle=[[NSMutableString alloc] init];
    for(NSInteger i=1; i<titleComponents.count; i++)
    {
        if(i!=1)
        {
            [fullTitle appendString:@":"];
        }
        [fullTitle appendString:[titleComponents objectAtIndex:i]];
    }
    if(![dateString isEqualToString:@""])
    {
        [eventListing appendFormat:@"%@: %@",dateString,fullTitle];
    }
    else
    {
        [eventListing appendFormat:@"%@",fullTitle];
    }
    
    
    //new.textLabel.text=[[things objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    new.textLabel.text=eventListing;
    //NSLog(@"%@",new.textLabel.text);
    new.textLabel.numberOfLines=0;
    new.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    
    [new.imageView sd_setImageWithURL:[NSURL URLWithString:[things objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"lightK.jpg"]];
    
    /*NSString *labelText=[things objectForKey:@"title"];
    UIFont* labelFont=[UIFont systemFontOfSize:18];
    NSDictionary* cellFont=[[NSDictionary alloc] initWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];
    CGSize textSize=[labelText sizeWithAttributes:cellFont];
    CGFloat area=textSize.height*textSize.width;
    CGFloat lines=ceilf((area/((tableView.bounds.size.width-minus)*.9))/labelFont.lineHeight);*/
    //new.height=((lines*labelFont.lineHeight)+30);
    new.height=[self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    //new.layoutMargins=UIEdgeInsetsZero;
    //[new.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //[new.imageView setFrame:CGRectMake(new.imageView.frame.origin.x, new.imageView.frame.origin.y, 52, 52)];
    //[new setNeedsLayout];
    //[new setUserInteractionEnabled:YES];
    //[new layoutSubviews];
    new.item=things;
    [new setSeparatorInset:UIEdgeInsetsZero];
    [new layoutIfNeeded];
    return new;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_showSections.count==0)
    {
        return 0;
    }
    return _showSections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_showSections.count==0)
    {
        return 0;
    }
    return [showDict objectForKey:[_showSections objectAtIndex:section]].count;
    //return feeds.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *labelText=[[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    if(_showSections.count==0)
    {
        return  _tableView.frame.size.height;
    }
    NSString *labelText=[[showDict objectForKey:_showSections[indexPath.section]] objectAtIndex:indexPath.row];
    UIFont* labelFont=[UIFont systemFontOfSize:18];
    NSDictionary* cellFont=[[NSDictionary alloc] initWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];
    CGSize textSize=[labelText sizeWithAttributes:cellFont];
    CGFloat area=textSize.height*textSize.width;
    CGFloat lines=ceilf((area/((tableView.bounds.size.width-minus)*.9))/labelFont.lineHeight);
    if(((lines*labelFont.lineHeight)+30)<(minus-30))
    {
        return minus-30;
    }
    return ((lines*labelFont.lineHeight)+30);
    //return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eventTableViewCell *selected=[tableView cellForRowAtIndexPath:indexPath];
    sendItem=[selected.item copy];
    sendTitle=selected.textLabel.text;
    sendDate=[_showSections objectAtIndex:indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showDescription" sender:self];
}

#pragma mark - Seperate Events

-(void)seperateEvents
{
    NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
    for(NSDictionary* anItem in feeds)
    {
        NSArray <NSString*> *seperateTitle=[[anItem objectForKey:@"title"] componentsSeparatedByString:@": "];
        NSMutableString *rest=[[NSMutableString alloc] initWithFormat:@"%@",[seperateTitle objectAtIndex:1]];
        for(NSInteger i=2; i<seperateTitle.count; i++)
        {
            [rest appendFormat:@": %@",[seperateTitle objectAtIndex:i]];
        }
        [temp setObject:[seperateTitle firstObject] forKey:rest];
    }
    NSSet <NSString*> *dates=[[NSSet alloc] initWithArray:[temp allValues]];
    NSMutableDictionary *final=[[NSMutableDictionary alloc] init];
    for(NSString *aDate in dates)
    {
        [final setObject:[temp allKeysForObject:aDate] forKey:aDate];
    }
    
    
    _dateDict=final;
}

/*-(NSArray <NSString*> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray <NSString*> *full=[_dateDict allKeys];
    full=[full sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return full;
}*/

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_showSections.count==0)
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
    NSString *string =[_showSections objectAtIndex:section];
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
#pragma mark - retrieving items from feed

-(NSDictionary*)itemForTitle:(NSString *)atitle date:(NSString *)adate
{
    NSString *full=[adate stringByAppendingFormat:@": %@",atitle];
    for(NSDictionary *anItem in feeds)
    {
        if([[anItem objectForKey:@"title"] isEqualToString:full])
        {
            return anItem;
        }
    }
    NSMutableDictionary *error=[[NSMutableDictionary alloc] init];
    [error setObject:@"Error" forKey:@"title"];
    return error;
}

#pragma mark - sort section dates

-(void)sortSections
{
    //NSLog(@"called");
    NSMutableArray *sorted=[[NSMutableArray alloc] initWithArray:[_dateDict allKeys]];
    for(NSInteger i=0; i<sorted.count; i++)
    {
        NSString *temp=[[_dateDict allKeys] objectAtIndex:i];
        //[sorted insertObject:[self intoNumber:temp] atIndex:i];
        [sorted replaceObjectAtIndex:i withObject:[self intoNumber:temp]];
        //NSLog(@"%@",sorted[i]);
    }
    NSArray *ref=[sorted sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2)
    {
        double n1=[obj1 doubleValue];
        double n2=[obj2 doubleValue];
        if(n1>n2)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if(n2>n1)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return NSOrderedSame;
            
    }];
    //[sorted sortedArrayUsingSelector:@selector(localizedCompare:)];
    for(NSInteger i=0; i<sorted.count; i++)
    {
        //NSLog(@"%@",ref[i]);
        [sorted replaceObjectAtIndex:i withObject:[self fromNumber:ref[i]]];
    }
    _sortedSections=[sorted copy];
}

-(void)sortEvents
{
    NSArray <NSString*> *onThisDay=[[NSArray alloc] init];
    NSMutableDictionary *temp=[[NSMutableDictionary alloc] initWithDictionary:_dateDict];
    for(NSString *thisDay in [_dateDict allKeys])
    {
        onThisDay=[_dateDict objectForKey:thisDay];
        /*NSMutableArray *eventTimes=[[NSMutableArray alloc] init];
        for(NSString *event in onThisDay)
        {
            NSDictionary *thisItem=[self itemForTitle:event date:thisDay];
            
        }*/
        onThisDay=[onThisDay sortedArrayUsingComparator:^(NSString* obj1, NSString* obj2) {
            NSDictionary *firstItem=[self itemForTitle:obj1 date:thisDay];
            NSDictionary *secondItem=[self itemForTitle:obj2 date:thisDay];
            double n1=[[self numForTime:[firstItem objectForKey:@"date"]] doubleValue];
            double n2=[[self numForTime:[secondItem objectForKey:@"date"]] doubleValue];
            if(n1>n2)
            {
                //NSLog(@"%f>%f",n1,n2);
                return NSOrderedDescending;
            }
            if(n2>n1)
            {
                //NSLog(@"%f<%f",n1,n2);
                return NSOrderedAscending;
            }
            //NSLog(@"%f=%f",n1,n2);
            return NSOrderedSame;
        }];
        [temp setObject:onThisDay forKey:thisDay];
    }
    _dateDict=temp;
    
}

-(NSString*)intoNumber:(NSString *)dateString
{
    NSMutableDictionary *months=[[NSMutableDictionary alloc] init];
    [months setObject:@"Jan" forKey:@"01"];
    [months setObject:@"Feb" forKey:@"02"];
    [months setObject:@"Mar" forKey:@"03"];
    [months setObject:@"Apr" forKey:@"04"];
    [months setObject:@"May" forKey:@"05"];
    [months setObject:@"Jun" forKey:@"06"];
    [months setObject:@"Jul" forKey:@"07"];
    [months setObject:@"Aug" forKey:@"08"];
    [months setObject:@"Sep" forKey:@"09"];
    [months setObject:@"Oct" forKey:@"10"];
    [months setObject:@"Nov" forKey:@"11"];
    [months setObject:@"Dec" forKey:@"12"];
    
    NSArray <NSString*> *dateComponents=[dateString componentsSeparatedByString:@" "];
    
    NSMutableString *dateNumString=[[NSMutableString alloc] init];
    [dateNumString appendString:dateComponents[2]];
    NSString *month=[[months allKeysForObject:dateComponents[0]] firstObject];
    NSString *day=[dateComponents[1] substringWithRange:NSMakeRange(0, dateComponents[1].length-1)];
    if(day.length==1)
    {
        day=[NSString stringWithFormat:@"0%@",day];
    }
    [dateNumString appendString:month];
    [dateNumString appendFormat:@".%@",day];
    return dateNumString;
}

-(NSString*)fromNumber:(NSString*)dateNum
{
    NSMutableDictionary *months=[[NSMutableDictionary alloc] init];
    [months setObject:@"Jan" forKey:@"01"];
    [months setObject:@"Feb" forKey:@"02"];
    [months setObject:@"Mar" forKey:@"03"];
    [months setObject:@"Apr" forKey:@"04"];
    [months setObject:@"May" forKey:@"05"];
    [months setObject:@"Jun" forKey:@"06"];
    [months setObject:@"Jul" forKey:@"07"];
    [months setObject:@"Aug" forKey:@"08"];
    [months setObject:@"Sep" forKey:@"09"];
    [months setObject:@"Oct" forKey:@"10"];
    [months setObject:@"Nov" forKey:@"11"];
    [months setObject:@"Dec" forKey:@"12"];
    
    NSString *year=[dateNum substringWithRange:NSMakeRange(0, 4)];
    NSArray <NSString*> *dayMonth=[[dateNum substringWithRange:NSMakeRange(4, dateNum.length-4)] componentsSeparatedByString:@"."];
    NSString *day=dayMonth[1];
    //NSLog(@"%@",day);
    if([[day substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"])
    {
        day=[day substringFromIndex:1];
    }
    return [NSString stringWithFormat:@"%@ %@, %@",[months objectForKey:[dayMonth firstObject]],day,year];
    
    
}

- (IBAction)refresh:(id)sender {
    
    [self viewDidLoad];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSArray<NSString*> *)parseDescription
{
    NSMutableArray <NSString*> *paragraphs=[[NSMutableArray alloc] initWithArray:[description componentsSeparatedByString:@"<p>"]];
    NSMutableArray <NSString*> *tempArray=[[NSMutableArray alloc] initWithArray:paragraphs];
    for(NSString* paragraph in paragraphs)
    {
        if([paragraph containsString:@"http://"]||[paragraph containsString:@"a href"])
        {
            //[paragraphs removeObject:paragraph];
            [tempArray removeObject:paragraph];
        }
        else
        {
            NSMutableString *temp=[[NSMutableString alloc] initWithString:[paragraph stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            //NSMutableString *temp=[[NSMutableString alloc] initWithString:[paragraph stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            //NSArray <NSString*> *stringArray=[temp componentsSeparatedByString:@"</p>"];
            [temp replaceOccurrencesOfString:@"</p>" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, temp.length)];
            [temp replaceOccurrencesOfString:@"<br />" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, temp.length)];
            //temp=[[NSMutableString alloc] initWithString:[stringArray firstObject]];
            [tempArray replaceObjectAtIndex:[tempArray indexOfObject:paragraph] withObject:temp];
        }
    }
    return tempArray;
}


#pragma mark prepare for navigation

-(IBAction)prepareForUnwind:(UIStoryboardSegue*)segue
{
    if([[segue identifier] isEqualToString:@"fromSettings"])
    {
        eventSettingsViewController *prev=[segue sourceViewController];
        isSelected=prev.isOn;
        [self filterCategories];
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showDescription"])
    {
        eventDescriptionViewController *sendTo=[segue destinationViewController];
        sendTo.titleText=sendTitle;
        sendTo.image=[sendItem objectForKey:@"image"];
        NSMutableString *descriptionText=[[NSMutableString alloc] init];
        NSArray <NSString*> *paragraphs=[sendItem objectForKey:@"description"];
        for(NSString *paragraph in paragraphs)
        {
            //NSLog(@"%@",paragraph);
            [descriptionText appendFormat:@"%@\n",paragraph];
        }
        sendTo.descriptionText=descriptionText;
        sendTo.dateText=sendDate;
        sendTo.myDate=[self dateFromString:sendDate];
    }
    if([[segue identifier] isEqualToString:@"toSettings"])
    {
        eventSettingsViewController *sendTo=[segue destinationViewController];
        if(_showSections.count>0)
        {
            sendTo.initialDate=[_showSections firstObject];}
        sendTo.theSections=_sortedSections;
        sendTo.wasOn=[isSelected copy];
    }
    [super prepareForSegue:segue sender:sender];
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

-(NSString*)numForTime:(NSString*)time
{
    NSArray<NSString*> *dateComponents=[time componentsSeparatedByString:@"T"];
    dateComponents=[[dateComponents objectAtIndex:1] componentsSeparatedByString:@"-"];
    dateComponents=[[dateComponents firstObject] componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@.%@",dateComponents[0],dateComponents[1]];
}

#pragma mark - filter nsdictionary into selected sections

-(void)filterCategories
{
    BOOL allSelected=YES;
    for(NSString *key in [isSelected allKeys])
    {
        if([[isSelected objectForKey:key] isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            allSelected=NO;
            break;
        }
    }
    if(allSelected)
    {
        showDict=_dateDict;
        return;
    }
    NSMutableDictionary <NSString*,NSMutableArray*> *temp=[[NSMutableDictionary alloc] init];
    for(NSString *dateItem in _showSections)
    {
        [temp setObject:[[NSMutableArray alloc] initWithArray:[_dateDict objectForKey:dateItem] copyItems:YES] forKey:dateItem];
        for(NSString *event in [_dateDict objectForKey:dateItem])
        {
            
            NSDictionary *thisItem=[self itemForTitle:event date:dateItem];
            NSArray <NSString*> *cats=[thisItem objectForKey:@"categories"];
            BOOL found=NO;
            if(cats.count>0)
            {
                for(NSString *cat in cats)
                {
                    if([[isSelected objectForKey:cat] isEqualToNumber:[NSNumber numberWithInt:1]])
                    {
                        found=YES;
                        break;
                    }
                }
                
            }
            if(!found)
            {
                [[temp objectForKey:dateItem] removeObject:event];
            }
        }
        
    }
    showDict=temp;
    NSMutableArray *titles=[[NSMutableArray alloc] initWithArray:_showSections];
    for(NSString *sec in _showSections)
    {
        if([showDict objectForKey:sec].count==0)
        {
            [titles removeObject:sec];
        }
    }
    _showSections=titles;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end























