//
//  handBookViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/28/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "handBookViewController.h"
#import "Handbook.h"
#import "AppDelegate.h"
#import "sectionViewController.h"
#import "navInfoViewController.h"
#import "searchViewController.h"

@interface handBookViewController (){
    NSArray* data;
    NSInteger children;
    BOOL searching;
    NSString *searchTerm;
    
    searchViewController *searchController;
}

@end

@implementation handBookViewController: ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchController=nil;
    /*NSOperationQueue* backgroundQueue=[[NSOperationQueue alloc] init];
    [backgroundQueue addOperationWithBlock:^{*/
    
    if(self.topTitle.length<=0)
    {
        self.handbookPath=[handbook initializeHandbook];
        self.topTitle=@"Student Handbook";
    }
    
    _tableTitle.title=_topTitle;
    children=[self childViewControllers].count;
    
    data=[handbook sortedKeysForObject:_tableTitle.title];
    self.table.separatorInset=UIEdgeInsetsMake(10, 10, 10, 10);
    searching=NO;
    searchTerm=@"None";
    
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setSeparatorInset:UIEdgeInsetsZero];
    [_table setLayoutMargins:UIEdgeInsetsZero];
}

-(UINavigationItem*)navigationItem
{
    return _tableTitle;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier=@"sectionItem";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString* string=data[indexPath.section];
    cell.textLabel.text=string;
    
    cell.textLabel.font=[UIFont systemFontOfSize:18];
    [cell.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    _choice=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString* segueIden=[findTitles findSegue:_choice];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:segueIden sender:self];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toTextView"])
    {
        sectionViewController* temp=[segue destinationViewController];
        temp.self.handbookPath=self.handbookPath;
        if(searching)
        {
            temp.searchFor=searchTerm;
        }
        else
        {
            temp.searchFor=@"None";
        }
        temp.section=_choice;
        temp.backSection=_topTitle;
    }
    else if([[segue identifier] isEqualToString:@"toSections"])
    {
        handBookViewController* temp=[segue destinationViewController];
        temp.handbookPath=self.handbookPath;
        temp.topTitle=_choice;
        
    }
    else if([[segue identifier] isEqualToString:@"toNavView"])
    {
        navInfoViewController* temp=[segue destinationViewController];
        temp.self.handbookPath=self.handbookPath;
        if(searching)
        {
            temp.searchFor=searchTerm;
        }
        else
        {
            temp.searchFor=@"None";
        }
        temp.self.section=_choice;
        temp.self.backSection=_topTitle;
        
    }
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue*)segue {
    searching=NO;
    searchTerm=@"None";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* labelText=[data objectAtIndex:indexPath.section];
    UIFont* labelFont=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    NSDictionary* cellFont=[[NSDictionary alloc] initWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];
    CGSize textSize=[labelText sizeWithAttributes:cellFont];
    CGFloat area=textSize.height*textSize.width;
    CGFloat lines=ceilf((area/(tableView.bounds.size.width*.9))/labelFont.lineHeight);
    return ((lines*labelFont.lineHeight)+20);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)reverseSection:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)swipeRight:(id)sender {
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (IBAction)searchPressed:(id)sender {
    if(searchController==nil)
    {
        searchController=[self.storyboard instantiateViewControllerWithIdentifier:@"handbookSearch"  ];
        searchController.handbook=self.handbookPath;
        [self presentViewController:searchController animated:YES completion:^{
            
        }];
    }
}

#pragma mark- searching

-(void)hideSearch
{
    /*[UIView transitionWithView:_searchContainer duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _searchContainer.alpha=0;
    }completion:NULL];*/
    [self dismissViewControllerAnimated:YES completion:^{
        searchController=nil;
    }];
}

-(void)searchFor:(NSString*)sectionTitle term:(NSString *)searcher
{
    [self dismissViewControllerAnimated:YES completion:^{
        _choice=sectionTitle;
        searchTerm=searcher;
        searching=YES;
        NSString *segueIden=[findTitles findSegue:_choice];
        [self performSegueWithIdentifier:segueIden sender:self];
        searchController=nil;
    }];
}
@end
