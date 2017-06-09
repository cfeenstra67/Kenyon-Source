//
//  sectionViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/30/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "sectionViewController.h"
#import "Handbook.h"
#import "FoundationsExtensions.h"
#import "handBookViewController.h"

@interface sectionViewController () {
    NSRange searchedTermRange;
}

@end

@implementation sectionViewController: ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    /*UITextRange* top=[_sectionView textRangeFromPosition:_sectionView.beginningOfDocument toPosition:[_sectionView positionFromPosition:_sectionView.beginningOfDocument offset:0]];
    CGRect start=[self.sectionView firstRectForRange:top];
    CGRect startingView=CGRectMake(start.origin.x, start.origin.y, _sectionView.bounds.size.width, _sectionView.bounds.size.height);
    [self.sectionView scrollRectToVisible:startingView animated:NO];*/
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([_searchFor isEqualToString:@"None"])
    {
        
    }
    else
    {
        _searchBar.text=_searchFor;
        [self performSelector:@selector(glassButton:) withObject:self];
        [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:_searchBar];
    }
}

-(void)viewDidLayoutSubviews
{
    [self.sectionView setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView
{
    self.SectionTitle.text=_section;
    
    //NSData* book=[[NSData alloc] init];
    //book=[NSData dataWithContentsOfURL:self.handbookPath];
    
    NSDictionary* handbook=[[NSDictionary alloc] init];
    //handbook=[NSKeyedUnarchiver unarchiveObjectWithData:book];
    handbook=self.handbookPath;
    
    self.sectionView.attributedText=handbook[_section];
    
    _SectionTitle.numberOfLines=2;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _searchBarView.hidden=YES;
    searchedTermRange.location=NSNotFound;
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] containsString:@"toSections"])
    {
        handBookViewController* next=[segue destinationViewController];
        next.handbookPath=self.handbookPath;
        next.topTitle=_backSection;
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

- (IBAction)chooseSectionView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)swipeLeft:(id)sender {
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma Search Bar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSRange rangeOfTerm=[_sectionView.text rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
    //[_sectionView resignFirstResponder];
    [_sectionView setScrollEnabled:YES];
    [_sectionView scrollRangeToVisible:NSMakeRange(rangeOfTerm.location, 200)];
    //_sectionView.selectedTextRange=termRange;
    [_sectionView becomeFirstResponder];
    [_sectionView setSelectedRange:rangeOfTerm];
    searchedTermRange=rangeOfTerm;
    
}

- (IBAction)glassButton:(id)sender {
    if(_searchBarView.hidden)
    {
        _searchBarView.hidden=NO;
    }
    else
    {
        _searchBarView.hidden=YES;
        _searchBar.text=@"";
        searchedTermRange.location=NSNotFound;
        
    }
}

- (IBAction)nextResult:(id)sender {
    if(searchedTermRange.location!=NSNotFound)
    {
        NSString* searchString=[_sectionView.text substringWithRange:searchedTermRange];
        NSRange nextRange=[_sectionView.text rangeOfString:searchString options:NSCaseInsensitiveSearch range:NSMakeRange(searchedTermRange.location+searchedTermRange.length, _sectionView.text.length-searchedTermRange.location-searchedTermRange.length)];
        if(nextRange.location==NSNotFound)
        {
            nextRange=[_sectionView.text rangeOfString:searchString options:NSCaseInsensitiveSearch];
        }
        [_sectionView scrollRangeToVisible:NSMakeRange(nextRange.location-100, 200)];
        [_sectionView becomeFirstResponder];
        [_sectionView setSelectedRange:nextRange];
        searchedTermRange=nextRange;
        
    }
    else
    {
        [self searchBarSearchButtonClicked:_searchBar];
    }
}

- (IBAction)prevResult:(id)sender {
    if(searchedTermRange.location!=NSNotFound)
    {
        NSString* searchString=[_sectionView.text substringWithRange:searchedTermRange];
        NSRange nextRange=[_sectionView.text rangeOfString:searchString options:(NSCaseInsensitiveSearch | NSBackwardsSearch) range:NSMakeRange(0, searchedTermRange.location)];
        if(nextRange.location==NSNotFound)
        {
            nextRange=[_sectionView.text rangeOfString:searchString options:(NSCaseInsensitiveSearch | NSBackwardsSearch)];
        }
        
        [_sectionView scrollRangeToVisible:NSMakeRange(nextRange.location-100, 200)];
        [_sectionView becomeFirstResponder];
        [_sectionView setSelectedRange:nextRange];
        searchedTermRange=nextRange;
    }
}
@end
