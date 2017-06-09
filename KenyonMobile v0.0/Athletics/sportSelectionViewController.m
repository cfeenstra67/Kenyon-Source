//
//  sportSelectionViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/7/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "sportSelectionViewController.h"
#import "athleticsViewController.h"

@implementation sport

-(void)setURL:(NSArray*)sportNames;
{
    NSString *template=@"http://athletics.kenyon.edu/calendar.ashx/calendar.rss?sport_id=";
    NSMutableDictionary *sportURLs=[[NSMutableDictionary alloc] init];
    [sportURLs setObject:[template stringByAppendingString:@"1"] forKey:[sportNames objectAtIndex:0]];
    [sportURLs setObject:[template stringByAppendingString:@"2"] forKey:[sportNames objectAtIndex:1]];
    [sportURLs setObject:[template stringByAppendingString:@"3"] forKey:[sportNames objectAtIndex:2]];
    [sportURLs setObject:[template stringByAppendingString:@"5"] forKey:[sportNames objectAtIndex:3]];
    [sportURLs setObject:[template stringByAppendingString:@"6"] forKey:[sportNames objectAtIndex:4]];
    [sportURLs setObject:[template stringByAppendingString:@"7"] forKey:[sportNames objectAtIndex:5]];
    [sportURLs setObject:[template stringByAppendingString:@"9"] forKey:[sportNames objectAtIndex:6]];
    [sportURLs setObject:[template stringByAppendingString:@"10"] forKey:[sportNames objectAtIndex:7]];
    [sportURLs setObject:[template stringByAppendingString:@"11"] forKey:[sportNames objectAtIndex:8]];
    [sportURLs setObject:[template stringByAppendingString:@"12"] forKey:[sportNames objectAtIndex:9]];
    [sportURLs setObject:[template stringByAppendingString:@"13"] forKey:[sportNames objectAtIndex:10]];
    [sportURLs setObject:[template stringByAppendingString:@"14"] forKey:[sportNames objectAtIndex:11]];
    [sportURLs setObject:[template stringByAppendingString:@"15"] forKey:[sportNames objectAtIndex:12]];
    [sportURLs setObject:[template stringByAppendingString:@"16"] forKey:[sportNames objectAtIndex:13]];
    [sportURLs setObject:[template stringByAppendingString:@"18"] forKey:[sportNames objectAtIndex:14]];
    [sportURLs setObject:[template stringByAppendingString:@"19"] forKey:[sportNames objectAtIndex:15]];
    [sportURLs setObject:[template stringByAppendingString:@"20"] forKey:[sportNames objectAtIndex:16]];
    [sportURLs setObject:[template stringByAppendingString:@"21"] forKey:[sportNames objectAtIndex:17]];
    [sportURLs setObject:[template stringByAppendingString:@"22"] forKey:[sportNames objectAtIndex:18]];
    [sportURLs setObject:[template stringByAppendingString:@"23"] forKey:[sportNames objectAtIndex:19]];
    [sportURLs setObject:[template stringByAppendingString:@"&han="] forKey:[sportNames objectAtIndex:20]];
    self.sportURL=[NSURL URLWithString:[sportURLs objectForKey:self.sportName]];
    //return [NSURL URLWithString:[sportURLs objectForKey:self.sportName]];
}

@end

@interface sportSelectionViewController ()

@end

@implementation sportSelectionViewController

- (void)viewDidLoad {    // Do any additional setup after loading the view.
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:@"Baseball"];
    [temp addObject:@"Field Hockey"];
    [temp addObject:@"Football"];
    [temp addObject:@"Men's Basketball"];
    [temp addObject:@"Men's Cross Country"];
    [temp addObject:@"Golf"];
    [temp addObject:@"Men's Lacrosse"];
    [temp addObject:@"Men's Soccer"];
    [temp addObject:@"Men's Swim & Dive"];
    [temp addObject:@"Men's Tennis"];
    [temp addObject:@"Men's Track & Field"];
    [temp addObject:@"Softball"];
    [temp addObject:@"Women's Basketball"];
    [temp addObject:@"Women's Cross Country"];
    [temp addObject:@"Women's Lacrosse"];
    [temp addObject:@"Women's Soccer"];
    [temp addObject:@"Women's Swim & Dive"];
    [temp addObject:@"Women's Tennis"];
    [temp addObject:@"Women's Track & Field"];
    [temp addObject:@"Volleyball"];
    [temp addObject:@"Upcoming"];
    _sports=temp;
    [self setViewOrder:_sports];
    [super viewDidLoad];
    

    
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

#pragma mark Table View Methods

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text=[_viewOrder objectAtIndex:indexPath.row];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sports.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)
indexPath {
    _sendSport=[[sport alloc] init];
    _sendSport.sportName=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    //_sendSport.sportURL=[_sendSport getURL:_sports];
    [_sendSport setURL:_sports];
    athleticsViewController *vc=[self.navigationController viewControllers][self.navigationController.viewControllers.count-2];
    [self.navigationController popViewControllerAnimated:YES];
    [vc prepareForUnwind:[UIStoryboardSegue segueWithIdentifier:@"chooseSport" source:self destination:vc performHandler:^{
        
    }]];
}

-(void)setViewOrder:(NSArray *)sports
{
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    [temp addObject:[_sports objectAtIndex:20]];
    [temp addObject:[_sports objectAtIndex:0]];
    [temp addObject:[_sports objectAtIndex:3]];
    [temp addObject:[_sports objectAtIndex:4]];
    [temp addObject:[_sports objectAtIndex:2]];
    [temp addObject:[_sports objectAtIndex:5]];
    [temp addObject:[_sports objectAtIndex:6]];
    [temp addObject:[_sports objectAtIndex:7]];
    [temp addObject:[_sports objectAtIndex:8]];
    [temp addObject:[_sports objectAtIndex:9]];
    [temp addObject:[_sports objectAtIndex:10]];
    [temp addObject:[_sports objectAtIndex:11]];
    [temp addObject:[_sports objectAtIndex:13]];
    [temp addObject:[_sports objectAtIndex:1]];
    [temp addObject:[_sports objectAtIndex:14]];
    [temp addObject:[_sports objectAtIndex:15]];
    [temp addObject:[_sports objectAtIndex:11]];
    [temp addObject:[_sports objectAtIndex:16]];
    [temp addObject:[_sports objectAtIndex:17]];
    [temp addObject:[_sports objectAtIndex:18]];
    [temp addObject:[_sports objectAtIndex:19]];
    
    _viewOrder=temp;
    
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
