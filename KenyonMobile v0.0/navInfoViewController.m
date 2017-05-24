//
//  navInfoViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/30/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "navInfoViewController.h"
#import "FoundationsExtensions.h"
#import "Handbook.h"

@interface navInfoViewController () {
    NSDate *startTime;
}

@end

@implementation navInfoViewController {
    NSRange searchedTermRange;
}

/*@synthesize SectionTitle;

@synthesize handbookPath;

@synthesize section;

@synthesize sectionView;*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView
{
    self.SectionTitle.text=self.section;
    
    //NSData* book=[[NSData alloc] init];
    //book=[NSData dataWithContentsOfURL:self.handbookPath];
    
    NSDictionary* handbook=[[NSDictionary alloc] init];
    handbook=self.handbookPath;
    
    self.sectionView.attributedText=handbook[self.section];
    
    _miniSections=[findTitles findBold:self.sectionView.attributedText fontSize:[UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize];
    
    /*self.SectionTitle.numberOfLines=2;
    self.SectionTitle.minimumScaleFactor=.01;
    
    while(self.SectionTitle.attributedText.size.width>(self.SectionTitle.bounds.size.width*1.65))
    {
        self.SectionTitle.font=[self.SectionTitle.font fontWithSize:self.SectionTitle.font.pointSize-1];
        self.SectionTitle.numberOfLines=3;
    }
    [self.SectionTitle sizeToFit];*/
    
    self.SectionTitle.numberOfLines=2;
    
    self.searchBarView.hidden=YES;
    searchedTermRange.location=NSNotFound;
    startTime=[NSDate date];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _miniSections.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString* temp=[[NSAttributedString alloc] initWithAttributedString:[_miniSections objectAtIndex:row]];
    return temp.string;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSAttributedString* title=[[NSAttributedString alloc] initWithAttributedString:[_miniSections objectAtIndex:row]];
    
    NSRange titleRange=[self.sectionView.attributedText.string rangeOfString:title.string];
    
    UITextPosition* begin=self.sectionView.beginningOfDocument;
    UITextPosition* start=[self.sectionView positionFromPosition:begin offset:titleRange.location];
    UITextPosition* end=[self.sectionView positionFromPosition:start offset:titleRange.length];
    UITextRange* textRange=[self.sectionView textRangeFromPosition:start toPosition:end];
    CGRect initial=[self.sectionView firstRectForRange:textRange];
    CGRect page=CGRectMake(CGRectGetMinX(initial), CGRectGetMinY(initial), self.sectionView.bounds.size.width, self.sectionView.bounds.size.height);
    wasSelected=YES;
    [self.sectionView scrollRectToVisible:page animated:NO];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!wasSelected&((int)ceil([startTime timeIntervalSinceNow]*10)%2==0))
    {
        UITextPosition* beginning=self.sectionView.beginningOfDocument;
        for(NSAttributedString* key in _miniSections)
        {
            NSRange titleRange=[self.sectionView.attributedText.string rangeOfString:key.string];
            //NSRange titleRange=NSMakeRange([[titleStarts objectAtIndex:[_miniSections indexOfObject:key]] integerValue], key.length);
            UITextPosition* start=[self.sectionView positionFromPosition:beginning offset:titleRange.location];
            UITextPosition* end=[self.sectionView positionFromPosition:start offset:titleRange.length];
            UITextRange* textRange=[self.sectionView textRangeFromPosition:start toPosition:end];
            CGRect title=[self.sectionView firstRectForRange:textRange];
            double dist=(title.origin.y-self.sectionView.bounds.origin.y);
            if((fabs(dist)<(self.sectionView.bounds.size.height/3))&&(dist>0)&&(!([_miniSections indexOfObject:key]==[_picker selectedRowInComponent:0]))) 
            {
                [_picker selectRow:[_miniSections indexOfObject:key] inComponent:0 animated:YES];
                break;
            }
            else if(([_miniSections indexOfObject:key]==[_picker selectedRowInComponent:0])&&(dist>((2*self.sectionView.bounds.size.height)/3))&&([_miniSections indexOfObject:key]!=0))
            {
                [_picker selectRow:([_miniSections indexOfObject:key]-1) inComponent:0 animated:YES];
                break;
            }
        }
        
    }
    else
    {
        wasSelected=NO;
    }
}

- (IBAction)chooseSectionView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        
        tView.minimumScaleFactor=.7;
        
        tView.textAlignment = NSTextAlignmentCenter;
        
        tView.adjustsFontSizeToFitWidth = YES;
        // Setup label properties - frame, font, colors etc
    }
    
    tView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    //Add any logic you want here
    
    return tView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
)
*/

/*-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSRange rangeOfTerm=[self.sectionView.text rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
    [self.sectionView scrollRangeToVisible:NSMakeRange(rangeOfTerm.location, 500)];
    //_sectionView.selectedTextRange=termRange;
    [self.sectionView becomeFirstResponder];
    [self.sectionView setSelectedRange:rangeOfTerm];
    searchedTermRange=rangeOfTerm;
}*/

- (IBAction)swipeLeft:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)glassButton:(id)sender {
    if(self.searchBarView.hidden)
    {
        self.searchBarView.hidden=NO;
    }
    else
    {
        self.searchBarView.hidden=YES;
        self.searchBar.text=@"";
        searchedTermRange.location=NSNotFound;
        
    }
}

/*- (IBAction)nextResult:(id)sender {
    if(searchedTermRange.location!=NSNotFound)
    {
        NSString* searchString=[self.sectionView.text substringWithRange:searchedTermRange];
        NSRange nextRange=[self.sectionView.text rangeOfString:searchString options:NSCaseInsensitiveSearch range:NSMakeRange(searchedTermRange.location+searchedTermRange.length, self.sectionView.text.length-searchedTermRange.location-searchedTermRange.length)];
        if(nextRange.location==NSNotFound)
        {
            nextRange=[self.sectionView.text rangeOfString:searchString options:NSCaseInsensitiveSearch];
        }
        
        [self.sectionView scrollRangeToVisible:NSMakeRange(nextRange.location, 500)];
        [self.sectionView becomeFirstResponder];
        [self.sectionView setSelectedRange:nextRange];
        searchedTermRange=nextRange;
        
    }
    else
    {
        [self searchBarSearchButtonClicked:self.searchBar];
    }
}*/

/*- (IBAction)prevResult:(id)sender {
    if(searchedTermRange.location!=NSNotFound)
    {
        NSString* searchString=[self.sectionView.text substringWithRange:searchedTermRange];
        NSRange nextRange=[self.sectionView.text rangeOfString:searchString options:(NSCaseInsensitiveSearch | NSBackwardsSearch) range:NSMakeRange(0, searchedTermRange.location)];
        if(nextRange.location==NSNotFound)
        {
            nextRange=[self.sectionView.text rangeOfString:searchString options:(NSCaseInsensitiveSearch | NSBackwardsSearch)];
        }
        
        [self.sectionView scrollRangeToVisible:NSMakeRange(nextRange.location, 500)];
        [self.sectionView becomeFirstResponder];
        [self.sectionView setSelectedRange:nextRange];
        searchedTermRange=nextRange;
    }
}*/




@end
