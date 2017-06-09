//
//  gameTableViewCell.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 7/6/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "gameTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation gameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillCell:(NSString *)description startTime:(NSString *)startTime imageLink:(NSString *)imageURL
{
    NSArray <NSString*> *checkType=[description componentsSeparatedByString:@" "];
    if(([[checkType firstObject] isEqualToString:@"[W]"])||([[checkType firstObject] isEqualToString:@"[L]"])||([[checkType firstObject] isEqualToString:@"CANCELLED"]))
    {
        [self fillOldCell:description startTime:startTime imageLink:imageURL];
    }
    else
    {
        NSString* pass;
        if([[checkType firstObject] isEqualToString:@"[N]"])
        {
            pass=[description substringFromIndex:4];
        }
        else
        {
            pass=description;
        }
        [self fillNewCell:pass startTime:startTime imageLink:imageURL];
    }
    self.layoutMargins=UIEdgeInsetsZero;
    self.separatorInset=UIEdgeInsetsZero;
}

-(void)fillOldCell:(NSString *)description startTime:(NSString *)startTime imageLink:(NSString *)imageURL
{
    //[_versusLabel setFrame:CGRectMake(_versusLabel.frame.origin.x, _versusLabel.frame.origin.y, ([_versusLabel superview].frame.size.width-rightMargin-_versusLabel.frame.origin.x), _versusLabel.frame.size.height)];
    
    //IMAGE URL
    //NSLog(@"|%@|",imageURL);
    NSURL *image=[NSURL URLWithString:[imageURL substringWithRange:NSMakeRange(0, imageURL.length-1)]];
    //[_awayImage sd_setImageWithURL:image];
    [_awayImage sd_setImageWithURL:image placeholderImage:[UIImage imageNamed:@"lightK.jpg"]];
    
    //USING DESCRIPTION
    NSArray <NSString*> *components=[description componentsSeparatedByString:@"\\n"];
    //NSLog(@"%@",[components firstObject]);
    NSString *secondComponent=[components objectAtIndex:1];
    NSArray <NSString*> *tester=[secondComponent componentsSeparatedByString:@" "];
    
    if([[tester objectAtIndex:0] isEqualToString:@"Streaming"])
    {
        _scoreLabel.text=@"CANCELLED";
        _scoreLabel.adjustsFontSizeToFitWidth=YES;
        
    }
    else
    {
        NSString *fullScore=[components objectAtIndex:1];
        NSArray <NSString*> *scoreParts=[fullScore componentsSeparatedByString:@" "];
        NSMutableString *final=[[NSMutableString alloc] initWithString:[scoreParts firstObject]];
        [final appendString:@" "];
        [final appendString:[scoreParts objectAtIndex:1]];
        _scoreLabel.text=final;
        _scoreLabel.adjustsFontSizeToFitWidth=YES;
    }
    
    NSString* firstComponent=[components firstObject];
    tester=[firstComponent componentsSeparatedByString:@" "];
    
    NSUInteger at=[tester indexOfObject:@"at"];
    NSUInteger vs=[tester indexOfObject:@"vs"];
    NSUInteger seperator;
    if(vs==NSNotFound)
    {
        seperator=at;
    }
    else
    {
        seperator=vs;
    }
    
    NSMutableString *sportText=[[NSMutableString alloc] initWithString:[tester objectAtIndex:1]];
    for(NSUInteger i=2; i<seperator; i++)
    {
        [sportText appendString:@" "];
        [sportText appendString:[tester objectAtIndex:i]];
    }
    NSMutableString *versusText=[[NSMutableString alloc] initWithString:[tester objectAtIndex:seperator]];
    for(NSUInteger i=seperator+1; i<tester.count; i++)
    {
        if(i!=seperator+1)
        {
            [versusText appendString:@" "];
        }
        [versusText appendString:[tester objectAtIndex:i]];
    }
    
    _sportLabel.text=sportText;
    _sportLabel.adjustsFontSizeToFitWidth=YES;
    _versusLabel.text=versusText;
    
    //SETTING DATE
    
    tester=[startTime componentsSeparatedByString:@"T"];
    NSArray <NSString*> *dateComponents=[[tester firstObject] componentsSeparatedByString:@"-"];
    NSMutableString *date=[[NSMutableString alloc] initWithCapacity:20];
                           //initWithString:[dateComponents objectAtIndex:1]];
    [date appendString:[dateComponents objectAtIndex:1]];
    [date appendString:@"/"];
    [date appendString:[dateComponents objectAtIndex:2]];
    [date appendString:@"/"];
    [date appendString:[dateComponents firstObject]];
    
    [date appendString:@" "];
    
    if([tester count]>1)
    {
        NSArray <NSString*> *timeComponents=[[tester objectAtIndex:1] componentsSeparatedByString:@":"];
    
        NSInteger time=[[timeComponents firstObject] integerValue];
        NSString *ap;
        if(time>12)
        {
            ap=@"PM";
            time-=12;
        }
        else if(time==12)
        {
            ap=@"PM";
        }
        else if(time<12)
            {
                ap=@"AM";
            }
        NSString *hourString=[NSString stringWithFormat:@"%ld",(long)time];
    
        [date appendString:[NSString stringWithFormat:@"%@:%@ %@",hourString,[timeComponents objectAtIndex:1],ap]];
    }
    
    _dateLabel.text=date;
    
    
}

-(void)fillNewCell:(NSString *)description startTime:(NSString *)startTime imageLink:(NSString *)imageURL
{
    //IMAGE URL
    //NSLog(@"|%@|",imageURL);
    if([imageURL isEqualToString:@"\n"])
    {
        imageURL=[NSString stringWithFormat:@"http://athletics.kenyon.edu/images/logos/Kenyon_Shield.pngz"];
    }
    NSURL *image=[NSURL URLWithString:[imageURL substringWithRange:NSMakeRange(0, imageURL.length-1)]];
    //[_awayImage sd_setImageWithURL:image];
    [_awayImage sd_setImageWithURL:image];
    
    //USING DESCRIPTION
    NSArray <NSString*> *components=[description componentsSeparatedByString:@"\\n"];
    //NSLog(@"%@",[components firstObject]);
    //NSString *secondComponent=[components objectAtIndex:1];
    NSArray <NSString*> *tester=[[NSArray alloc] init];
    
    /*if([[tester objectAtIndex:0] isEqualToString:@"Streaming"])
    {
        _scoreLabel.text=@"CANCELLED";
        _scoreLabel.adjustsFontSizeToFitWidth=YES;
        
    }
    else
    {
        NSString *fullScore=[components objectAtIndex:1];
        NSArray <NSString*> *scoreParts=[fullScore componentsSeparatedByString:@" "];
        NSMutableString *final=[[NSMutableString alloc] initWithString:[scoreParts firstObject]];
        [final appendString:@" "];
        [final appendString:[scoreParts objectAtIndex:1]];
        _scoreLabel.text=final;
    }*/
    _scoreLabel.text=@"";
    
    NSString* firstComponent=[components firstObject];
    tester=[firstComponent componentsSeparatedByString:@" "];
    
    NSUInteger at=[tester indexOfObject:@"at"];
    NSUInteger vs=[tester indexOfObject:@"vs"];
    NSUInteger seperator;
    if(vs==NSNotFound)
    {
        seperator=at;
    }
    else
    {
        seperator=vs;
    }
    
    NSMutableString *sportText=[[NSMutableString alloc] initWithString:[tester objectAtIndex:0]];
    for(NSUInteger i=1; i<seperator; i++)
    {
        [sportText appendString:@" "];
        [sportText appendString:[tester objectAtIndex:i]];
    }
    NSMutableString *versusText=[[NSMutableString alloc] initWithString:[tester objectAtIndex:seperator]];
    for(NSUInteger i=seperator+1; i<tester.count; i++)
    {
        if(i!=seperator+1)
        {[versusText appendString:@" "];}
        [versusText appendString:[tester objectAtIndex:i]];
    }
    
    _sportLabel.text=sportText;
    _sportLabel.adjustsFontSizeToFitWidth=YES;
    _versusLabel.text=versusText;
    
    //SETTING DATE
    
    tester=[startTime componentsSeparatedByString:@"T"];
    NSArray <NSString*> *dateComponents=[[tester firstObject] componentsSeparatedByString:@"-"];
    NSMutableString *date=[[NSMutableString alloc] initWithString:[dateComponents objectAtIndex:1]];
    [date appendString:@"/"];
    [date appendString:[dateComponents objectAtIndex:2]];
    [date appendString:@"/"];
    [date appendFormat:@"%@",[dateComponents firstObject]];
    
    //[date appendString:@" "];
    BOOL hasTime=YES;
    if(tester.count==1)
    {
        hasTime=NO;
    }
    if(hasTime)
    {
        [date appendString:@" "];
        NSArray <NSString*> *timeComponents=[[tester objectAtIndex:1] componentsSeparatedByString:@":"];
    
        NSInteger time=[[timeComponents firstObject] integerValue];
        NSString *ap;
        if(time>12)
        {
            ap=@"PM";
            time-=12;
        }
        else if(time==12)
        {
            ap=@"PM";
        }
        else if(time<12)
        {
            ap=@"AM";
        }
        NSString *hourString=[NSString stringWithFormat:@"%ld",(long)time];
    
        [date appendString:[NSString stringWithFormat:@"%@:%@ %@",hourString,[timeComponents objectAtIndex:1],ap]];
    }
    else
    {
        date=[NSMutableString stringWithFormat:@"%@ Time TBD",date];
        //[date appendString:@"Time TBD"];
    }
    _dateLabel.text=date;
    
    
}

@end
