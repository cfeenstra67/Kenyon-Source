//
//  searchViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/12/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "searchViewController.h"
#import "Handbook.h"
#import "handBookViewController.h"

@interface searchViewController () {
    NSArray <NSString*> *searchResults;
    NSArray <NSArray*> *searchOrder;
    NSDictionary <NSString*,NSNumber*> *searchcounts;
    
    NSDictionary *sources;
    
    NSString *choice;
}

@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
    NSDictionary *use=[handbook generateSources];
    for(sourceData *data in [use allKeys])
    {
        [temp setObject:[use objectForKey:data] forKey:data.text];
    }
    sources=temp;
    [self noResults];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView reloadData];
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

- (IBAction)closeSearch:(id)sender {
    
    [self.view endEditing:YES];
    _searchBar.text=@"";
    [self noResults];
    [_tableView reloadData];
    handBookViewController *par=(handBookViewController*)[(UINavigationController
                                                           *)[self presentingViewController] topViewController];
    [par hideSearch];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self generateResults];
    [self.view endEditing:YES];
    /*[_tableView setUserInteractionEnabled:YES];
    NSString *searchFor=searchBar.text;
    NSMutableArray <NSString*> *titles=[[NSMutableArray alloc] init];
    //NSInteger count=0;
    for(NSString *title in [_handbook allKeys])
    {
        NSAttributedString *inspectText=[_handbook objectForKey:title];
        
        if([inspectText.string localizedCaseInsensitiveContainsString:searchFor])
        {
            if(![[findTitles findSegue:title] isEqualToString:@"toSections"])
            {
                [titles addObject:title];
            
            }
            
        }
    }
    if(titles.count==0)
    {
        [titles addObject:@"No Results"];
    }
    searchResults=titles;
    [_tableView reloadData];
    [self.view endEditing:YES];*/
    
}

#pragma mark - table view

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *new;
    NSString *title=[searchResults objectAtIndex:indexPath.section];
    if([title isEqualToString:@"No Results"])
    {
        new=[tableView dequeueReusableCellWithIdentifier:@"noResults"];
        tableView.userInteractionEnabled=NO;
        new.textLabel.textAlignment=NSTextAlignmentCenter;
        new.textLabel.font=[UIFont boldSystemFontOfSize:new.textLabel.font.pointSize];
        
    }
    else
    {
        new=[tableView dequeueReusableCellWithIdentifier:@"searchResult"];
        new.textLabel.textAlignment=NSTextAlignmentLeft;
        new.textLabel.font=[UIFont systemFontOfSize:new.textLabel.font.pointSize];
        new.detailTextLabel.textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        new.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        new.textLabel.numberOfLines=0;
        NSInteger occur=[[searchcounts objectForKey:title] integerValue];
        NSString *add;
        if(occur==1)
        {
            add=@"";
        }
        else
        {
            add=@"s";
        }
        new.detailTextLabel.text=[NSString stringWithFormat:@"%@ Occurance%@",[searchcounts objectForKey:title],add];
        new.detailTextLabel.textColor=[UIColor colorWithRed:.66667 green:.66667 blue:.66667 alpha:1];
        
    }
    new.textLabel.text=title;
    [new setSeparatorInset:UIEdgeInsetsZero];
    [new setLayoutMargins:UIEdgeInsetsZero];
    return new;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return searchResults.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0f)];
    [footer setBackgroundColor:[UIColor blackColor]];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView reloadData];
    choice=[searchResults objectAtIndex:indexPath.section];
    handBookViewController *par=(handBookViewController*)[(UINavigationController*)[self presentingViewController] topViewController];
    [par searchFor:choice term:_searchBar.text];
}

#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    handBookViewController *next=[segue destinationViewController];
    next.handbookPath=self.handbook;
    next.searchTitle=choice;
}

-(void)noResults
{
    searchResults=[[NSArray alloc] initWithObjects:@"No Results", nil];
}

#pragma mark - searching live update

-(void)generateResults
{
    [_tableView setUserInteractionEnabled:YES];
    NSString *searchFor=_searchBar.text;
    NSMutableArray <NSString*> *titles=[[NSMutableArray alloc] init];
    NSMutableDictionary <NSString*,NSNumber*> *titlecounts=[[NSMutableDictionary alloc] init];
    //NSInteger count=0;
    for(NSString *title in [_handbook allKeys])
    {
        NSAttributedString *inspectText=[_handbook objectForKey:title];
        NSRange range=NSMakeRange(0, inspectText.string.length);
        NSInteger count=0;
        if([inspectText.string localizedCaseInsensitiveContainsString:searchFor])
        {
            
            range=[inspectText.string rangeOfString:searchFor options:NSCaseInsensitiveSearch range:range];
            while(range.length!=0) {
                count++;
                range=[inspectText.string rangeOfString:searchFor options:NSCaseInsensitiveSearch range:NSMakeRange(range.location+1, inspectText.string.length-range.location-1)];
            }
        }
        if(count>0)
        {
            if(![[findTitles findSegue:title] isEqualToString:@"toSections"])
            {
                [titles addObject:title];
                [titlecounts setObject:[NSNumber numberWithInteger:count] forKey:title];
            }
        }
    }
    if(titles.count==0)
    {
        [titles addObject:@"No Results"];
    }
    [titles sortUsingComparator:^(NSString* str1, NSString *str2){
        NSInteger n1=[[titlecounts objectForKey:str1] integerValue];
        NSInteger n2=[[titlecounts objectForKey:str2] integerValue];
        if(n1>n2)
        {
            return NSOrderedAscending;
        }
        if(n1<n2)
        {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    searchcounts=titlecounts;
    searchResults=titles;
    [_tableView reloadData];

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        [self noResults];
        [_tableView reloadData];
    }
    else
    {
        [self generateResults];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* labelText=[searchResults objectAtIndex:indexPath.section];
    UIFont* labelFont=[UIFont systemFontOfSize:18];
    NSDictionary* cellFont=[[NSDictionary alloc] initWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];
    CGSize textSize=[labelText sizeWithAttributes:cellFont];
    CGFloat area=textSize.height*textSize.width;
    CGFloat lines=ceilf((area/(tableView.bounds.size.width*.9))/labelFont.lineHeight);
    return ((lines*labelFont.lineHeight)+30);
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
