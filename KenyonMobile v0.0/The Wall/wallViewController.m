//
//  wallViewController.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "wallViewController.h"
#import "commentsViewController.h"
#import "wallPostTableViewCell.h"

@interface wallViewController (){
    NSInteger highestCalled;
    
    UIFont *font;
    
    UIFont *smallFont;
    
    BOOL didReload;
    
    UIView *loadingView;
    
    BOOL hasLoaded;
    
    NSArray<wallPost*>* posts;
    
    CKQueryCursor *cursor;
    
    NSInteger selectedRow;
}

@end

@implementation wallViewController

- (void)viewDidLoad {
    hasLoaded=NO;
    loadingView=nil;
    font=[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    smallFont=[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    highestCalled=0;
    didReload=NO;
    posts=nil;
    cursor=nil;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[postManager shared] setMyDelegate:self];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.rowHeight=44;
    
    
    [_tableView setAllowsSelection:YES];
    [_tableView setRefreshControl:[[UIRefreshControl alloc] init]];
    [_tableView.refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(posts==nil)
    {
        [self createLoadingView];
    }
}

-(void)createLoadingView
{
    self.view.userInteractionEnabled=NO;
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
        self.view.userInteractionEnabled=YES;
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(posts==nil)
    {
        [[NSOperationQueue new] addOperationWithBlock:^{
            [self fetch:^{
                [self removeLoadingView];
                hasLoaded=YES;
            }];
        }];
    }
}



-(IBAction)pullToRefresh:(UIRefreshControl*)ref
{
    if(didReload)
    {
        return;
    }
    else if(!didReload)
    {
        didReload=YES;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.5]];
        [self fetch];
        [ref endRefreshing];
        didReload=NO;
    }
}

-(void)fetch
{
    __block BOOL isDone=NO;
    [self fetch:^{
        isDone=YES;
    }];
    while(!isDone)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
}

-(void)fetch:(void(^)())completion
{
    posts=[[NSArray alloc] init];
    [[postManager shared] getNextBatchWithCursor:cursor completion:^(NSArray<wallPost*>* wallposts, CKQueryCursor *c){
        cursor=c;
        posts=wallposts;        [_tableView reloadData];
        if(completion!=nil)
        {
            completion();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchNext
{
    if(cursor!=nil)
    {
        __block BOOL doneFlag=NO;
        __block NSMutableArray *newP=[NSMutableArray arrayWithArray:posts];
        [[postManager shared] getNextBatchWithCursor:cursor completion:^(NSArray<wallPost*>* wallposts, CKQueryCursor *c){
            cursor=c;
            [newP addObjectsFromArray:wallposts];
            posts=newP;
            doneFlag=YES;
        }];
        while (!doneFlag) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.05]];
        }
        [_tableView reloadData];
    }
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section>highestCalled)
    {
        highestCalled=indexPath.section;
    }
    wallPostTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    wallPost *thisPost=posts[indexPath.section];
    [cell.postLabel setText:thisPost.content];
    [cell.postLabel setFont:font];
    cell.textLabel.numberOfLines=0;
    
    [cell.leftTextLabel setText:[thisPost dateString]];
    [cell.leftTextLabel setFont:smallFont];
    [cell.leftTextLabel setTextColor:[UIColor grayColor]];
    
    [cell.rightTextLabel setText:[NSString stringWithFormat:@"%ld Comment(s)",(long)thisPost.comments]];
    [cell.rightTextLabel setFont:smallFont];
    [cell.rightTextLabel setTextColor:[UIColor grayColor]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(posts==nil||posts.count==0)
    {
        return 0;
    }
    return posts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *atr=[[NSAttributedString alloc] initWithString:posts[indexPath.section].content attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    NSInteger numberOfLines=ceil((atr.size.height*atr.size.width)/(_tableView.bounds.size.width-16)/font.lineHeight);
    return numberOfLines*font.lineHeight+smallFont.lineHeight+24;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow=indexPath.section;
    [self performSegueWithIdentifier:@"segueToComments" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self tableView:tableView viewForFooterInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
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


//postManagerDelegate methods
-(void)managerDidReset:(postManager *)manager
{
    [_tableView reloadData];
}

-(void)managerDidFetchNewBatch:(postManager *)manager
{
    
}

-(void)managerDidPublishPost:(postManager *)manager
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (IBAction)newPost:(id)sender {
    [self performSegueWithIdentifier:@"startComposing" sender:self];
}

//Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"wallToHome"])
    {
        
    }
    else if([[segue identifier] isEqualToString:@"segueToComments"])
    {
        wallPost *temp=posts[selectedRow];
        commentsViewController *dest=(commentsViewController*)[segue destinationViewController];
        dest.originPost=temp;
    }
    [super prepareForSegue:segue sender:sender];
}



-(void)prepareForUnwind:(UIStoryboardSegue*)segue
{
    
}
@end
