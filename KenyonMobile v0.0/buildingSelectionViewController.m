//
//  buildingSelectionViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/11/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "buildingSelectionViewController.h"

@interface buildingSelectionViewController () {
    NSArray<NSString*> *alph;
}

@end

@implementation buildingSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"Old Kenyon"];
    
    [temp addObject:@"Leonard Hall"];
    [temp addObject:@"Hanna Hall"];
    [temp addObject:@"Higley Hall"];
    [temp addObject:@"Maintenance Buildings"];
    [temp addObject:@"Taft Cottages"];
    [temp addObject:@"Manning Hall"];
    [temp addObject:@"Bushnell Hall"];
    [temp addObject:@"Bolton Theater"];
    [temp addObject:@"Shaffer Speech Building"];
    [temp addObject:@"Bolton Dance Studio"];
    [temp addObject:@"Tomsich Hall"];
    [temp addObject:@"Hayes Hall"];
    [temp addObject:@"Samuel Mather Hall"];
    [temp addObject:@"Ascension Hall"];
    [temp addObject:@"Horovitz Hall"];
    [temp addObject:@"Sunset Cottage"];
    [temp addObject:@"Bailey House"];
    [temp addObject:@"Storer Hall"];
    [temp addObject:@"Rosse Hall"];
    [temp addObject:@"Chalmers Library"];
    [temp addObject:@"Olin Library"];
    [temp addObject:@"Gund Gallery"];
    [temp addObject:@"Cromwell Cottage"];
    [temp addObject:@"Lentz House"];
    [temp addObject:@"Ransom Hall"];
    [temp addObject:@"Stephens Hall"];
    [temp addObject:@"Church of the Holy Spirit"];
    [temp addObject:@"Peirce Hall"];
    [temp addObject:@"Dempsey Hall"];
    [temp addObject:@"Horn Gallery"];
    [temp addObject:@"Edelstein House"];
    [temp addObject:@"Timberlake House"];
    [temp addObject:@"Horvitz House"];
    [temp addObject:@"O'Connor House"];
    [temp addObject:@"Seitz House"];
    [temp addObject:@"Acland House"];
    [temp addObject:@"Acland Street Apartments"];
    [temp addObject:@"Morgan Apartments"];
    [temp addObject:@"Gambier Child Care Center"];
    [temp addObject:@"Gambier Community Center"];
    [temp addObject:@"Kenyon Athletic Center"];
    [temp addObject:@"McBride Field"];
    [temp addObject:@"Tennis Courts"];
    [temp addObject:@"Village Maintenance Building"];
    [temp addObject:@"Soccer Field"];
    [temp addObject:@"Baseball Field"];
    [temp addObject:@"Phi Kappa Sigma"];
    [temp addObject:@"Ralston House"];
    [temp addObject:@"Palme House"];
    [temp addObject:@"Parish House"];
    [temp addObject:@"Davis House"];
    [temp addObject:@"Finn House"];
    [temp addObject:@"Kenyon Inn"];
    [temp addObject:@"Weather Vane"];
    [temp addObject:@"Campus Safety"];
    [temp addObject:@"College Relations Center"];
    [temp addObject:@"Treelaven House"];
    [temp addObject:@"Health and Counseling Center"];
    [temp addObject:@"Rothenberg Hillel House"];
    [temp addObject:@"Campus Auto & Fuel"];
    [temp addObject:@"Post Office"];
    [temp addObject:@"Black Box Theater"];
    [temp addObject:@"Wiggins Street Coffee"];
    [temp addObject:@"Edwards House"];
    [temp addObject:@"Village Inn"];
    [temp addObject:@"Peoples Bank"];
    [temp addObject:@"Crozier Center"];
    [temp addObject:@"Gambier House"];
    [temp addObject:@"Head Quarters"];
    [temp addObject:@"Farr Hall"];
    [temp addObject:@"Village Market"];
    [temp addObject:@"Gambier Deli"];
    [temp addObject:@"Kenyon College Bookstore"];
    [temp addObject:@"Wilson Apartments"];
    [temp addObject:@"Lewis Hall"];
    [temp addObject:@"Gund Hall"];
    [temp addObject:@"Norton Hall"];
    [temp addObject:@"Watson Hall"];
    [temp addObject:@"Hoehn-Saric House"];
    [temp addObject:@"Eaton Center"];
    [temp addObject:@"Snowden Multicultural Center"];
    [temp addObject:@"Gund Commons"];
    [temp addObject:@"McBride Residence"];
    [temp addObject:@"Weaver Cottage"];
    [temp addObject:@"Mather Residence"];
    [temp addObject:@"Caples Residence"];
    [temp addObject:@"Sparrow House"];
    [temp addObject:@"Allen House"];
    [temp addObject:@"North Campus Apartments"];
    [temp addObject:@"Craft Center"];
    [temp addObject:@"Psi Upsilon"];
    [temp addObject:@"Delta Kappa Epsilon"];
    [temp addObject:@"Delta Tau Delta"];
    [temp addObject:@"Alpha Delta Phi"];
    [temp addObject:@"Ganter Price Hall"];
    [temp addObject:@"Bexley Hall"];
    [temp addObject:@"Colburn Hall"];
    [temp addObject:@"New Apartments"];
    [temp addObject:@"Franklin Miller Observatory"];
    [temp addObject:@"Brown Family Environmental Center"];
    _buildingBackup=[temp sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableArray<NSString*> *temp2=[[NSMutableArray alloc] init];
    [temp2 addObject:@"A"];
    [temp2 addObject:@"B"];
    [temp2 addObject:@"C"];
    [temp2 addObject:@"D"];
    [temp2 addObject:@"E"];
    [temp2 addObject:@"F"];
    [temp2 addObject:@"G"];
    [temp2 addObject:@"H"];
    [temp2 addObject:@"I"];
    [temp2 addObject:@"J"];
    [temp2 addObject:@"K"];
    [temp2 addObject:@"L"];
    [temp2 addObject:@"M"];
    [temp2 addObject:@"N"];
    [temp2 addObject:@"O"];
    [temp2 addObject:@"P"];
    [temp2 addObject:@"Q"];
    [temp2 addObject:@"R"];
    [temp2 addObject:@"S"];
    [temp2 addObject:@"T"];
    [temp2 addObject:@"U"];
    [temp2 addObject:@"V"];
    [temp2 addObject:@"W"];
    [temp2 addObject:@"X"];
    [temp2 addObject:@"Y"];
    [temp2 addObject:@"Z"];
    alph=temp2;
    
    [self makeAlphabet];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
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

#pragma mark - table methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{;
    return 26;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(![[_alphabet allKeys] containsObject:[alph objectAtIndex:section]])
    {
        return 0;
    }
    return [_alphabet objectForKey:[alph objectAtIndex:section]].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *new=[tableView dequeueReusableCellWithIdentifier:@"buildingResult"];
    new.textLabel.text=[[_alphabet objectForKey:[alph objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [new setSeparatorInset:UIEdgeInsetsZero];
    [new setLayoutMargins:UIEdgeInsetsZero];
    return new;
}

-(NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    for(NSInteger i=0; i<alph.count; i++)
    {
        [temp addObject:[alph objectAtIndex:i]];
        if((i!=25)&(i%5==2||i%5==4))
        {
            [temp addObject:@""];
        }
    }
    return temp;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if([title isEqualToString:@""])
    {
        return -1;
    }
    return [alph indexOfObject:title];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _picked=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - parse into letters

-(void)makeAlphabet
{
    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
    for(NSString *bname in _buildingBackup)
    {
        NSMutableArray *tempArray=[[NSMutableArray alloc] init];
        NSString *firstLetter=[bname substringWithRange:NSMakeRange(0, 1)];
        if(![[tempDict allKeys] containsObject:firstLetter])
        {
            [tempArray addObject:bname];
            for(NSString *bname2 in _buildingBackup)
            {
                NSString *firstletter2=[bname2 substringWithRange:NSMakeRange(0, 1)];
                if([firstLetter isEqualToString:firstletter2]&![bname2 isEqualToString:bname])
                {
                    [tempArray addObject:bname2];
                }
            }
            [tempArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [tempDict setObject:tempArray forKey:firstLetter];
        }
    }
    _alphabet=tempDict;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


@end
